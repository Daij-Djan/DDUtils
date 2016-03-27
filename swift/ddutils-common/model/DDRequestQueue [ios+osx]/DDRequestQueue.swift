//
//  DDRequestQueue.m
//  myAudi
//
//  Created by Dominik Pich on 2/1/16.
//  Copyright © 2016 Sapient GmbH. All rights reserved.
//
import Foundation
import SystemConfiguration

@objc protocol DDRequestQueueDelegate {
    //called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
    func requestQueueDequeuedRequest(queue:DDRequestQueue, request:NSURLRequest, response:NSURLResponse?, data:NSData?, error:NSError?) -> Void

    
    optional func requestQueueWillStartRequest(queue:DDRequestQueue, request:NSURLRequest) -> Void
    optional func requestQueueBeginWaitingForNetwork(queue:DDRequestQueue, host:String) -> Void
    optional func requestQueueEndWaitingForNetwork(queue:DDRequestQueue, host:String) -> Void
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
    
    private(set) var name = ""
    private(set) var persistent = false
    private(set) var queuedRequests = [NSURLRequest]()
    var delegate: DDRequestQueueDelegate?

    private var queueRunning = false
    private var currentReachability: SCNetworkReachabilityRef!;
    
    init(name:String, persistent:Bool) {
        super.init()

        self.name = name
        self.persistent = persistent
        
        if(self.persistent) {
            self.loadList()
        }
    }
    
    func enqueueRequest(request:NSURLRequest) -> Bool {
        let oldSuspended = self.suspended;
        self.suspended = true;
        
        self.queuedRequests.append(request)
        
        var br = (self.queuedRequests.indexOf(request) != nil);
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
    
    func cancelRequest(request:NSURLRequest) -> Bool {
        let oldSuspended = self.suspended;
        self.suspended = true;
        
        var idx = self.queuedRequests.indexOf(request)
        var br = (idx != nil);
        //        NSAssert(br, @"request should be enqueued");
        
        if let prevIdx = idx where br {
            self.queuedRequests.removeAtIndex(prevIdx)
            idx = self.queuedRequests.indexOf(request)
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
    
    private func doNextRequest() -> Void {
        //break if suspended
        if(self.suspended) {
            return;
        }
        
        //go to main thread
        if(!NSThread.isMainThread()) {
            dispatch_async(dispatch_get_main_queue()) {
                self.doNextRequest()
            }
        }
        
        //dequeue first
        if(self.queuedRequests.count == 0) {
            return;
        }
        let request = self.queuedRequests[0]
        self.queuedRequests.removeAtIndex(0)
        
        self.queueRunning = true;
        
        self.requestQueueWillStartRequest(request)
        
        //hand it off to ios
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { [unowned self] (data, response, error) -> Void in
            self.didFinishRequest(request, response: response, data: data, error: error)
            }.resume()
    }
    
    private func didFinishRequest(request:NSURLRequest, response:NSURLResponse?, data:NSData?, error:NSError?) -> Void {
        //go to main thread if needed
        if !NSThread.isMainThread() {
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.didFinishRequest(request, response: response, data: data, error: error)
            }
            return;
        }

        //handle network error
        if let error=error where self.isNetworkRelatedError(error) {
            //NSLog(@"+ Will Retry when network is up: %@", request.URL);
            
            //prepare to retry the request
            self.queuedRequests.insert(request, atIndex: 0)
            
            //wait for network coming back
            self.beginObservingReachabilityStatusForHost(request.URL!.host!);
            
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
    
    private func isNetworkRelatedError(error:NSError) -> Bool {
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

    func requestQueueWillStartRequest(request:NSURLRequest) -> Void {
        delegate?.requestQueueWillStartRequest?(self, request: request)
    }
    
    func requestQueueBeginWaitingForNetwork(host:String) -> Void {
        delegate?.requestQueueBeginWaitingForNetwork?(self, host: host)
    }
    func requestQueueEndWaitingForNetwork(host:String) -> Void {
        delegate?.requestQueueEndWaitingForNetwork?(self, host: host)
    }
    
    ///NOTE! called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
    func dequeuedRequest(request:NSURLRequest, response:NSURLResponse?, data:NSData?, error:NSError?) {
        if let delegate = self.delegate {
            delegate.requestQueueDequeuedRequest(self, request: request, response: response, data: data, error: error)
        }
    }
    
    // MARK: serialization
    
    private func loadList() -> Bool {
        let docURL = self.URLForPersistentQueue;
        let br = true;
        
        //if it doesnt exist, quit
        //if it does, read it
        if NSFileManager.defaultManager().fileExistsAtPath(docURL.path!) {
            guard let codedData = NSData(contentsOfURL: docURL) else {
                return false
            }
            
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: codedData)
            let array = unarchiver.decodeObjectForKey(DDRequestQueue.kDataKey)
            unarchiver.finishDecoding();
            
            guard let newRequests = array as? [NSURLRequest] else {
                return false
            }
            
            self.queuedRequests = newRequests
        }
        
        return br;
    }
    
    private func saveList() -> Bool {
        let array = self.queuedRequests;
        let docURL = self.URLForPersistentQueue;
        var br = true;
        
        //if the array is empty, delete the doc if it exists
        //if the array isnt empty, write it
        
        if(array.count == 0) {
            if NSFileManager.defaultManager().fileExistsAtPath(docURL.path!) {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(docURL)
                }
                catch {
                    br = false
                }
            }
        }
        else {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(array, forKey: DDRequestQueue.kDataKey)
            archiver.finishEncoding()
            
            br = data.writeToURL(docURL, atomically: true)
        }
        return br;
    }
    
    lazy var URLForPersistentQueue:NSURL = {
        let library = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.LibraryDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL:nil, create: true)
        let appDir = library.URLByAppendingPathComponent(String(DDRequestQueue), isDirectory: true)
        let filename = "QueuedRequests-" + self.name;
        
        try! NSFileManager.defaultManager().createDirectoryAtURL(appDir, withIntermediateDirectories: true, attributes: nil)
        
        return appDir.URLByAppendingPathComponent(filename)
    }()
    
    // MARK: reachability
    
    private func beginObservingReachabilityStatusForHost(host:String) -> Void {
        let block: @convention(block)(SCNetworkReachabilityRef, SCNetworkReachabilityFlags, UnsafePointer<Void>) -> Void = { [unowned self]
            (reachability: SCNetworkReachabilityRef, flags: SCNetworkReachabilityFlags, data: UnsafePointer<Void>) in
            
            //the callback passes the wrong flags ;)
            var newflags = SCNetworkReachabilityFlags()
            let b = SCNetworkReachabilityGetFlags(reachability, &newflags)
            assert(b)
            
            self.hostDidBecomeReachable(host, reachable: newflags.contains(.Reachable))
        }
        
        let blockObject = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
        let fp = unsafeBitCast(blockObject, SCNetworkReachabilityCallBack.self)
        let utfString = (host as NSString).UTF8String
        
        if let reachabilityRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, utfString) where (host.characters.count > 0) {
            var context = SCNetworkReachabilityContext()
            
            if (SCNetworkReachabilitySetCallback(reachabilityRef, fp, &context)){
                if (!SCNetworkReachabilitySetDispatchQueue(reachabilityRef, dispatch_get_main_queue()) ){
                    // Remove our callback if we can't use the queue
                    SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil);
                }
                self.currentReachability = reachabilityRef;
                
                self.requestQueueBeginWaitingForNetwork(host)
            }
        }
    }

    private func hostDidBecomeReachable(host:String, reachable:Bool) {
        if (reachable){
            self.requestQueueEndWaitingForNetwork(host)
            
            self.doNextRequest()
    
            SCNetworkReachabilitySetDispatchQueue(self.currentReachability, nil);
            //?!
//            CFRelease(self.currentReachability);
            self.currentReachability = nil;
        }
    }
}