//
//  NSURLConnection (ModifiedSince).m
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
import Foundation

///class extension
extension NSURLConnection {
    fileprivate class func DDURLCheckerLastContentData(_ url:URL) -> String {
        return "ModifiedSinceCache_content_" + url.absoluteString
    }
    fileprivate class func DDURLCheckerLastModificationDate(_ url:URL) -> String {
        return "ModifiedSinceCache_modDate_" + url.absoluteString
    }

    ///loads url and caches is - it uses a modifiedSince http request
    ///@param url the url to request
    ///@param cb the completion handler to asynchronously call back
    class func doModifiedSinceRequestForURL(_ url:URL, completionHandler:@escaping (_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
        if (url.isFileURL) {
            self.perfromLocalFileRequestForURL(url, completionHandler: completionHandler)
        } else {
            self.performNetworkRequestForURL(url, async: true, completionHandler: completionHandler)
        }
    }

    ///finds the latest cached data available
    ///@param url the url requested earlier
    class func cachedDataForModifiedSinceRequest(_ url:URL) -> (content:Data, date:Date)? {
        let data = self.lastContentDataForURL(url)
        if(data != nil) {
            let date = self.lastModificationDateForURL(url)
            return (data!, date!)
        }
        return nil
    }
    
    ///clears any cached data
    ///@param url the url requested earlier
    class func removeCachedDataForModifiedSinceRequest(_ url:URL) {
        self.setLastContentData(nil,url: url)
        self.setLastModificationDate(nil, url: url)
    }

    //---
    
    ///SYNCHRONOUSLY loads url and caches is - it uses a modifiedSince http request
    ///@param url the url to request
    ///@param pModificationDate a pointer to a date object to fill with the file's modification date
    ///@param pError a pointer to an error object to fill with the request error that happened date
    class func doSynchronousModifiedSinceRequestForURL(_ url:URL, error err:NSErrorPointer) -> (contentData:Data?, modificationDate:Date?, fromCache:Bool) {
        var d:Data?
        var m:Date?
        var c:Bool = false

        if (url.isFileURL) {
            self.perfromLocalFileRequestForURL(url, completionHandler: {url, contentData, modificationDate, fromCache, error in
                d = contentData
                m = modificationDate
                c = fromCache
                err?.pointee = error
            })
        } else {
            self.performNetworkRequestForURL(url, async: true, completionHandler: {url, contentData, modificationDate, fromCache, error in
                d = contentData
                m = modificationDate
                c = fromCache
                err?.pointee = error
            })
        }
        
        return (d, m, c);
    }
    
    //MARK: -
    
    ///the file content last received
    fileprivate class func lastContentDataForURL(_ url:URL) -> Data? {
        return UserDefaults.standard.data(forKey: self.DDURLCheckerLastContentData(url))
    }
    
    fileprivate class func setLastContentData(_ data:Data?, url:URL) {
        if(data != nil) {
            UserDefaults.standard.set(data, forKey: self.DDURLCheckerLastContentData(url))
        } else {
            UserDefaults.standard.removeObject(forKey: self.DDURLCheckerLastContentData(url))
        }
    }
    
    fileprivate class func lastModificationDateForURL(_ url:URL) -> Date? {
        let seconds = UserDefaults.standard.object(forKey: DDURLCheckerLastModificationDate(url)) as! NSNumber?
        if(seconds != nil) {
            return Date(timeIntervalSince1970: seconds!.doubleValue)
        } else {
            return nil
        }
    }
    
    fileprivate class func setLastModificationDate(_ date:Date?, url:URL) {
        if(date != nil) {
            UserDefaults.standard.set(date!.timeIntervalSince1970, forKey: self.DDURLCheckerLastModificationDate(url));
        } else {
            UserDefaults.standard.removeObject(forKey: self.DDURLCheckerLastModificationDate(url))
        }
    }

    // MARK: -

    fileprivate class func perfromLocalFileRequestForURL(_ url:URL, completionHandler:(_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
        var error : NSError?;
        var modDate : Date?
        var data : Data?

        let fileManager = FileManager.default
        let filePath = url.path;
        if (fileManager.fileExists(atPath: filePath)) {
            var attributes : [FileAttributeKey : Any]? = nil
            
            do {
                attributes = try fileManager.attributesOfItem(atPath: filePath)
            }
            catch(_) {}
            
            if (attributes != nil && attributes![FileAttributeKey.modificationDate] != nil) {
                modDate = (attributes![FileAttributeKey.modificationDate] as! NSDate) as Date
                data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
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
            new = (lastModDate == nil || (modDate! as NSDate).earlierDate(lastModDate!) != lastModDate!)
        }
        completionHandler(url, data, modDate, new, error)
        
    }
    
    class func isoDateFormatter() -> DateFormatter {
        struct Static {
            static let RFC1123DateFormatter: DateFormatter = DateFormatter()
        }
        let enUSPOSIXLocale = Locale(identifier:"en_US_POSIX")
        
        Static.RFC1123DateFormatter.locale = enUSPOSIXLocale
        Static.RFC1123DateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        Static.RFC1123DateFormatter.timeZone = TimeZone(secondsFromGMT:0)

        return Static.RFC1123DateFormatter
    }

    fileprivate class func performNetworkRequestForURL(_ url:URL, async:Bool, completionHandler:@escaping (_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
    //prepare request
        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0);
        
        let lastMod = self.lastModificationDateForURL(url)
        if(lastMod != nil) {
            let dateValue = self.isoDateFormatter().string(from: lastMod!)
            request.setValue(dateValue, forHTTPHeaderField: "If-Modified-Since")
        }
    
        //perform request
        if(async) {
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
                self.networkRequestFinished(request as URLRequest, response: response, data: data, error: error as NSError?, completionHandler: completionHandler)
            })
        }
        else {
            if(Thread.isMainThread) {
                print("Should not do a synchronous network request on the main thread");
            }
            
            do {
                var response: URLResponse?;
                let data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
                self.networkRequestFinished(request as URLRequest, response: response, data: data, error: nil, completionHandler: completionHandler)
            }
            catch(let e as NSError) {
                self.networkRequestFinished(request as URLRequest, response: nil, data: nil, error: e, completionHandler: completionHandler)
            
            }
            
        }
    }

    fileprivate class func networkRequestFinished(_ request:URLRequest, response:URLResponse?, data:Data?, error:NSError?, completionHandler:(_ url:URL, _ contentData:Data?, _ modificationDate:
        Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
            let url = request.url!;
            var err = error;

            if let httpResponse = response as! HTTPURLResponse? {
                if (httpResponse.statusCode == 200 && data != nil) {
                    var date:Date?;
                    let dateStr = httpResponse.allHeaderFields["Last-Modified"] as! String?;
                    if (dateStr != nil) {
                        date = self.isoDateFormatter().date(from: dateStr!)
                    }
                    assert((date != nil), "we should have last modified date!")
                    
                    self.setLastContentData(data, url: url)
                    self.setLastModificationDate(date, url: url)
                    
                    completionHandler(url, data, date, false, err)
                }
                else if(httpResponse.statusCode == 304) {
                    //304 --> nothing new
                    let d = self.lastContentDataForURL(url)
                    let m = self.lastModificationDateForURL(url)
                    
                    completionHandler(url, d, m, true, err)
                }
                return
            }
            
            //fallback
            if(err == nil) {
                if let httpResponse = response as! HTTPURLResponse? {
                    err = NSError(domain: "DDURLChecker:", code: 100, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"]);
                }
                else {
                    err = NSError(domain: "DDURLChecker:", code: 100, userInfo: [NSLocalizedDescriptionKey: "unknown comm error"]);
                }
            }
            
            let d = self.lastContentDataForURL(url)
            let m = self.lastModificationDateForURL(url)
            let c = (d != nil) ? true : false;
                    
            completionHandler(url, d, m, c, err)
    }
}
