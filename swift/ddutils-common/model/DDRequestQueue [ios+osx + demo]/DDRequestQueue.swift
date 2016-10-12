//
//  DDRequestQueue.m
//  myAudi
//
//  Created by Dominik Pich on 2/1/16.
//  Copyright © 2016 Sapient GmbH. All rights reserved.
//
import Foundation
import SystemConfiguration

func __reachabilityCallback(reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    print("__reachabilityCallback");
    
    guard let info = info else { return }
    
    print("__reachabilityCallback");
    let queue = Unmanaged<DDRequestQueue>.fromOpaque(info).takeUnretainedValue()
    let b = flags.contains(.reachable)
    
    DispatchQueue.main.async {
        queue.hostDidBecomeReachable("", reachable: b)
    }
}
@objc protocol DDRequestQueueDelegate {
    //called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
    func requestQueueDequeuedRequest(_ queue:DDRequestQueue, request:URLRequest, response:URLResponse?, data:Data?, error:NSError?) -> Void

    
    @objc optional func requestQueueWillStartRequest(_ queue:DDRequestQueue, request:URLRequest) -> Void
    @objc optional func requestQueueBeginWaitingForNetwork(_ queue:DDRequestQueue, host:String) -> Void
    @objc optional func requestQueueEndWaitingForNetwork(_ queue:DDRequestQueue, host:String) -> Void
}

///when created/loaded from disk, the queue is suspended by default
///NOTE: should be used on main thread
class DDRequestQueue : NSObject {
    
    static let kDefaultName = "defaultQueue"
    static let kDefaultIsPersistent = true
    static let kDataKey = "Data"
    static let defaultQueue = DDRequestQueue(name: kDefaultName, persistent: kDefaultIsPersistent)
    
    var suspended = true {
        didSet {
            if(!suspended && !self.queueRunning) {
                self.doNextRequest();
            }
        }
    }
    
    fileprivate(set) var name = ""
    fileprivate(set) var persistent = false
    fileprivate(set) var queuedRequests = [URLRequest]()
    var delegate: DDRequestQueueDelegate?

    fileprivate var queueRunning = false
    fileprivate var currentReachability: SCNetworkReachability!;
    
    init(name:String, persistent:Bool) {
        super.init()

        self.name = name
        self.persistent = persistent
        
        if(self.persistent) {
            self.loadList()
        }
    }
    
    func enqueueRequest(_ request:URLRequest) -> Bool {
        let oldSuspended = self.suspended;
        self.suspended = true;
        
        self.queuedRequests.append(request)
        
        var br = (self.queuedRequests.index(of: request) != nil);
        //        NSAssert(br, @"Failed to enqueue the object");
        
        if(br) {
            if(self.persistent) {
                br = self.saveList();
                //                NSAssert(br, @"Failed to persist queue after enqueing request: %@", request);
            }
        }
        
        if(br) {
            self.suspended = oldSuspended;
        }
        
        return br;
    }
    
    func cancelRequest(_ request:URLRequest) -> Bool {
        let oldSuspended = self.suspended;
        self.suspended = true;
        
        var idx = self.queuedRequests.index(of: request)
        var br = (idx != nil);
        //        NSAssert(br, @"request should be enqueued");
        
        if let prevIdx = idx , br {
            self.queuedRequests.remove(at: prevIdx)
            idx = self.queuedRequests.index(of: request)
            br = (idx == nil)
            //            NSAssert(br, @"request shouldnt be enqueued anymore");
        }
        
        if(br) {
            if(self.persistent) {
                br = self.saveList();
                //                NSAssert(br, @"Failed to persist queue after canceling request: %@", request);
            }
        }
        
        self.suspended = oldSuspended;
        
        return br;
    }
    
    func cancelAllRequests() -> Bool {
        let oldSuspended = self.suspended;
        self.suspended = true;
        
        var br = self.queuedRequests.count != 0;
        
        if(br) {
            self.queuedRequests.removeAll()
            br = self.queuedRequests.count == 0;
        }
        //    NSAssert(br, @"no requests shouldnt be enqueued anymore");
        
        if(br) {
            if(self.persistent) {
                br = self.saveList();
                //                NSAssert(br, @"Failed to persist queue after canceling all requests");
            }
        }
        
        self.suspended = oldSuspended;
        
        return br;
    }
    
    // MARK: processing requests
    
    fileprivate func doNextRequest() -> Void {
        //break if suspended
        if(self.suspended) {
            return;
        }
        
        //go to main thread
        if(!Thread.isMainThread) {
            DispatchQueue.main.async {
                self.doNextRequest()
            }
        }
        
        //dequeue first
        if(self.queuedRequests.count == 0) {
            return;
        }
        let request = self.queuedRequests[0]
        self.queuedRequests.remove(at: 0)
        
        self.queueRunning = true;
        
        self.requestQueueWillStartRequest(request)
        
        //hand it off to ios
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            self.didFinishRequest(request, response: response, data: data, error: error as? NSError)
        }
        task.resume()
    }
    
    private func didFinishRequest(_ request:URLRequest, response:URLResponse?, data:Data?, error:NSError?) -> Void {
        //go to main thread if needed
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                [unowned self] in
                self.didFinishRequest(request, response: response, data: data, error: error)
            }
            return;
        }

        //handle network error
        if let error=error , self.isNetworkRelatedError(error) {
            //NSLog(@"+ Will Retry when network is up: %@", request.URL);
            
            //prepare to retry the request
            self.queuedRequests.insert(request, at: 0)
            
            //wait for network coming back
            self.beginObservingReachabilityStatusForHost(request.url!.host!);
            
            return;
        }
        
        //    NSLog(@"+ Did finish: %@", request.URL);
        
        self.queueRunning = false;
        
        //we are done with this one, saveList the array
        if(self.persistent) {
            self.saveList();
            //errors ignored
        }
        
        //tell our subclass and the delegate everything else
        self.dequeuedRequest(request, response: response, data: data, error: error)
        
        //go on
        self.doNextRequest()
    }
    
    fileprivate func isNetworkRelatedError(_ error:NSError) -> Bool {
        if (error.domain == NSURLErrorDomain){
            switch (error.code){
            case NSURLErrorInternationalRoamingOff, NSURLErrorCallIsActive, NSURLErrorDataNotAllowed, NSURLErrorNotConnectedToInternet:
                return true;
            default:
                return false;
            }
        }
        return false;
    }
    
    // MARK: hooks will inform the delegate but can be overriden for additional behavior

    func requestQueueWillStartRequest(_ request:URLRequest) -> Void {
        delegate?.requestQueueWillStartRequest?(self, request: request)
    }
    
    func requestQueueBeginWaitingForNetwork(_ host:String) -> Void {
        delegate?.requestQueueBeginWaitingForNetwork?(self, host: host)
    }
    func requestQueueEndWaitingForNetwork(_ host:String) -> Void {
        delegate?.requestQueueEndWaitingForNetwork?(self, host: host)
    }
    
    ///NOTE! called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
    func dequeuedRequest(_ request:URLRequest, response:URLResponse?, data:Data?, error:NSError?) {
        if let delegate = self.delegate {
            delegate.requestQueueDequeuedRequest(self, request: request, response: response, data: data, error: error)
        }
    }
    
    // MARK: serialization
    
    fileprivate func loadList() -> Bool {
        let docURL = self.URLForPersistentQueue;
        let br = true;
        
        //if it doesnt exist, quit
        //if it does, read it
        if FileManager.default.fileExists(atPath: docURL.path) {
            guard let codedData = try? Data(contentsOf: docURL) else {
                return false
            }
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: codedData)
            let array = unarchiver.decodeObject(forKey: DDRequestQueue.kDataKey)
            unarchiver.finishDecoding();
            
            guard let newRequests = array as? [URLRequest] else {
                return false
            }
            
            self.queuedRequests = newRequests
        }
        
        return br;
    }
    
    fileprivate func saveList() -> Bool {
        let array = self.queuedRequests;
        let docURL = self.URLForPersistentQueue;
        var br = true;
        
        //if the array is empty, delete the doc if it exists
        //if the array isnt empty, write it
        
        if(array.count == 0) {
            if FileManager.default.fileExists(atPath: docURL.path) {
                do {
                    try FileManager.default.removeItem(at: docURL)
                }
                catch {
                    br = false
                }
            }
        }
        else {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(array, forKey: DDRequestQueue.kDataKey)
            archiver.finishEncoding()
            
            br = data.write(to: docURL, atomically: true)
        }
        return br;
    }
    
    lazy var URLForPersistentQueue:URL = {
        let library = try! FileManager.default.url(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor:nil, create: true)
        let appDir = library.appendingPathComponent(String(describing: DDRequestQueue.self), isDirectory: true)
        let filename = "QueuedRequests-" + self.name;
        
        try! FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true, attributes: nil)
        
        return appDir.appendingPathComponent(filename)
    }()
    
    // MARK: reachability
    
    fileprivate func beginObservingReachabilityStatusForHost(_ host:String) -> Void {
        let utfString = (host as NSString).utf8String
        
        if let reachabilityRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, utfString!) , (host.characters.count > 0) {
            var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
            context.info = UnsafeMutableRawPointer(Unmanaged<DDRequestQueue>.passUnretained(self).toOpaque())
            
            let callbackEnabled = SCNetworkReachabilitySetCallback(reachabilityRef, __reachabilityCallback, &context)
            
            if (callbackEnabled){
                if (!SCNetworkReachabilitySetDispatchQueue(reachabilityRef, DispatchQueue.main) ){
                    // Remove our callback if we can't use the queue
                    SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil);
                }
                self.currentReachability = reachabilityRef;
                
                self.requestQueueBeginWaitingForNetwork(host)
            }
        }
    }

    fileprivate func hostDidBecomeReachable(_ host:String, reachable:Bool) {
        if (reachable){
            if(self.currentReachability != nil) {
                self.requestQueueEndWaitingForNetwork(host)
            
                self.doNextRequest()
    
                SCNetworkReachabilitySetDispatchQueue(self.currentReachability, nil);
                //?!
                //            CFRelease(self.currentReachability);
                self.currentReachability = nil;
            }
        }
    }
}
