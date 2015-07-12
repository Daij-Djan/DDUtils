//
//  NSURLConnection (ModifiedSince).m
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
import Foundation

///class extension
extension NSURLConnection {
    private class func DDURLCheckerLastContentData(url:NSURL) -> String {
        return "ModifiedSinceCache_content_" + url.absoluteString!
    }
    private class func DDURLCheckerLastModificationDate(url:NSURL) -> String {
        return "ModifiedSinceCache_modDate_" + url.absoluteString!
    }

    ///loads url and caches is - it uses a modifiedSince http request
    ///@param url the url to request
    ///@param cb the completion handler to asynchronously call back
    class func doModifiedSinceRequestForURL(url:NSURL, completionHandler:(url:NSURL, contentData:NSData?, modificationDate:NSDate?, fromCache:Bool, error:NSError?)->Void) {
        if (url.fileURL) {
            self.perfromLocalFileRequestForURL(url, completionHandler: completionHandler)
        } else {
            self.performNetworkRequestForURL(url, async: true, completionHandler: completionHandler)
        }
    }

    ///finds the latest cached data available
    ///@param url the url requested earlier
    class func cachedDataForModifiedSinceRequest(url:NSURL) -> (content:NSData, date:NSDate)? {
        let data = self.lastContentDataForURL(url)
        if(data != nil) {
            let date = self.lastModificationDateForURL(url)
            return (data!, date!)
        }
        return nil
    }
    
    ///clears any cached data
    ///@param url the url requested earlier
    class func removeCachedDataForModifiedSinceRequest(url:NSURL) {
        self.setLastContentData(nil,url: url)
        self.setLastModificationDate(nil, url: url)
    }

    //---
    
    ///SYNCHRONOUSLY loads url and caches is - it uses a modifiedSince http request
    ///@param url the url to request
    ///@param pModificationDate a pointer to a date object to fill with the file's modification date
    ///@param pError a pointer to an error object to fill with the request error that happened date
    class func doSynchronousModifiedSinceRequestForURL(url:NSURL, error err:NSErrorPointer) -> (contentData:NSData?, modificationDate:NSDate?, fromCache:Bool) {
        var d:NSData?
        var m:NSDate?
        var c:Bool = false

        if (url.fileURL) {
            self.perfromLocalFileRequestForURL(url, completionHandler: {url, contentData, modificationDate, fromCache, error in
                d = contentData
                m = modificationDate
                c = fromCache
                err.memory = error
            })
        } else {
            self.performNetworkRequestForURL(url, async: true, completionHandler: {url, contentData, modificationDate, fromCache, error in
                d = contentData
                m = modificationDate
                c = fromCache
                err.memory = error
            })
        }
        
        return (d, m, c);
    }
    
    //MARK: -
    
    ///the file content last received
    private class func lastContentDataForURL(url:NSURL) -> NSData? {
        return NSUserDefaults.standardUserDefaults().dataForKey(self.DDURLCheckerLastContentData(url))
    }
    
    private class func setLastContentData(data:NSData?, url:NSURL) {
        if(data != nil) {
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: self.DDURLCheckerLastContentData(url))
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.DDURLCheckerLastContentData(url))
        }
    }
    
    private class func lastModificationDateForURL(url:NSURL) -> NSDate? {
        let seconds = NSUserDefaults.standardUserDefaults().objectForKey(DDURLCheckerLastModificationDate(url)) as! NSNumber?
        if(seconds != nil) {
            return NSDate(timeIntervalSince1970: seconds!.doubleValue)
        } else {
            return nil
        }
    }
    
    private class func setLastModificationDate(date:NSDate?, url:NSURL) {
        if(date != nil) {
            NSUserDefaults.standardUserDefaults().setDouble(date!.timeIntervalSince1970, forKey: self.DDURLCheckerLastModificationDate(url));
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.DDURLCheckerLastModificationDate(url))
        }
    }

    // MARK: -

    private class func perfromLocalFileRequestForURL(url:NSURL, completionHandler:(url:NSURL, contentData:NSData?, modificationDate:NSDate?, fromCache:Bool, error:NSError?)->Void) {
        var error : NSError?;
        var modDate : NSDate?
        var data : NSData?

        let fileManager = NSFileManager.defaultManager()
        let filePath = url.path!;
        if (fileManager.fileExistsAtPath(filePath)) {
            let attributes = fileManager.attributesOfItemAtPath(filePath, error: &error)
        
            if (attributes != nil) {
                modDate = attributes![NSFileModificationDate] as! NSDate?
                data = NSData(contentsOfFile: filePath)
            } else {
                if(error == nil) {
                    error = NSError(domain: "DDURLChecker", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]);
                }
            }
        } else {
            error = NSError(domain: "DDURLChecker", code: 1, userInfo: [NSLocalizedDescriptionKey: "file not found error"]);
        }
    
        var new = false
        if(modDate != nil) {
            let lastModDate = self.lastModificationDateForURL(url)
            new = (lastModDate == nil || modDate!.earlierDate(lastModDate!) != lastModDate!)
        }
        completionHandler(url: url, contentData: data, modificationDate: modDate, fromCache: new, error: error)
        
    }
    
    class func isoDateFormatter() -> NSDateFormatter {
        struct Static {
            static let RFC1123DateFormatter: NSDateFormatter = NSDateFormatter()
        }
        let enUSPOSIXLocale = NSLocale(localeIdentifier:"en_US_POSIX")
        
        Static.RFC1123DateFormatter.locale = enUSPOSIXLocale
        Static.RFC1123DateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        Static.RFC1123DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT:0)

        return Static.RFC1123DateFormatter
    }

    private class func performNetworkRequestForURL(url:NSURL, async:Bool, completionHandler:(url:NSURL, contentData:NSData?, modificationDate:NSDate?, fromCache:Bool, error:NSError?)->Void) {
    //prepare request
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0);
        
        let lastMod = self.lastModificationDateForURL(url)
        if(lastMod != nil) {
            let dateValue = self.isoDateFormatter().stringFromDate(lastMod!)
            request.setValue(dateValue, forHTTPHeaderField: "If-Modified-Since")
        }
    
        //perform request
        if(async) {
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                self.networkRequestFinished(request, response: response, data: data, error: error, completionHandler: completionHandler)
            })
        }
        else {
            if(NSThread.isMainThread()) {
                println("Should not do a synchronous network request on the main thread");
            }
            
            var response: NSURLResponse?;
            var error: NSError?;
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            
            self.networkRequestFinished(request, response: response, data: data, error: error, completionHandler: completionHandler)
        }
    }

    private class func networkRequestFinished(request:NSURLRequest, response:NSURLResponse?, data:NSData?, error:NSError?, completionHandler:(url:NSURL, contentData:NSData?, modificationDate:
        NSDate?, fromCache:Bool, error:NSError?)->Void) {
            let url = request.URL!;
            var err = error;

            if let httpResponse = response as! NSHTTPURLResponse? {
                if (httpResponse.statusCode == 200 && data != nil) {
                    var date:NSDate?;
                    let dateStr = httpResponse.allHeaderFields["Last-Modified"] as! String?;
                    if (dateStr != nil) {
                        date = self.isoDateFormatter().dateFromString(dateStr!)
                    }
                    assert((date != nil), "we should have last modified date!")
                    
                    self.setLastContentData(data, url: url)
                    self.setLastModificationDate(date, url: url)
                    
                    completionHandler(url: url, contentData: data, modificationDate: date, fromCache: false, error: err)
                }
                else if(httpResponse.statusCode == 304) {
                    //304 --> nothing new
                    let d = self.lastContentDataForURL(url)
                    let m = self.lastModificationDateForURL(url)
                    
                    completionHandler(url: url, contentData: d, modificationDate: m, fromCache: true, error: err)
                }
                return
            }
            
            //fallback
            if(err == nil) {
                if let httpResponse = response as! NSHTTPURLResponse? {
                    err = NSError(domain: "DDURLChecker:", code: 100, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"]);
                }
                else {
                    err = NSError(domain: "DDURLChecker:", code: 100, userInfo: [NSLocalizedDescriptionKey: "unknown comm error"]);
                }
            }
            
            let d = self.lastContentDataForURL(url)
            let m = self.lastModificationDateForURL(url)
            let c = (d != nil) ? true : false;
                    
            completionHandler(url: url, contentData: d, modificationDate: m, fromCache: c, error: err)
    }
}