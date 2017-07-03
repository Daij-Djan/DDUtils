//
//  URLSession+ModifiedSince.swift
//
//  Created by Dominik Pich on 19/12/13 (updated 2017).
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
import Foundation

///class extension
public extension URLSession {
    
    ///loads url and caches is - it uses a modifiedSince http request
    ///@param url the url to request
    ///@param cb the completion handler to asynchronously call back
    public func doModifiedSinceRequest(with url:URL, completionHandler:@escaping (_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
        if (url.isFileURL) {
            self.perfromLocalFileRequestForURL(url, completionHandler: completionHandler)
        } else {
            self.performNetworkRequestForURL(url, completionHandler: completionHandler)
        }
    }
    
    ///finds the latest cached data available
    ///@param url the url requested earlier
    public func cachedDataForModifiedSinceRequest(with url:URL) -> (content:Data, date:Date)? {
        let data = lastContentDataForURL(url)
        if(data != nil) {
            let date = lastModificationDateForURL(url)
            return (data!, date!)
        }
        return nil
    }
    
    ///clears any cached data
    ///@param url the url requested earlier
    public func removeCachedDataForModifiedSinceRequest(with url:URL) {
        setLastContentData(nil,url: url)
        setLastModificationDate(nil, url: url)
    }
    
    /// MARK: private
    
    // MARK: -

    fileprivate func perfromLocalFileRequestForURL(_ url:URL, completionHandler:(_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
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
            let lastModDate = lastModificationDateForURL(url)
            new = (lastModDate == nil || (modDate! as NSDate).earlierDate(lastModDate!) != lastModDate!)
        }
        completionHandler(url, data, modDate, new, error)
        
    }
    
    fileprivate func performNetworkRequestForURL(_ url:URL, completionHandler:@escaping (_ url:URL, _ contentData:Data?, _ modificationDate:Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
    //prepare request
        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0);
        
        let lastMod = lastModificationDateForURL(url)
        if(lastMod != nil) {
            let dateValue = isoDateFormatter().string(from: lastMod!)
            request.setValue(dateValue, forHTTPHeaderField: "If-Modified-Since")
        }
    
        //perform request
        self.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            self.networkRequestFinished(request as URLRequest, response: response, data: data, error: error as NSError?, completionHandler: completionHandler)
        }).resume()
    }

    fileprivate func networkRequestFinished(_ request:URLRequest, response:URLResponse?, data:Data?, error:NSError?, completionHandler:(_ url:URL, _ contentData:Data?, _ modificationDate:
        Date?, _ fromCache:Bool, _ error:NSError?)->Void) {
            let url = request.url!;
            var err = error;

            if let httpResponse = response as! HTTPURLResponse? {
                if (httpResponse.statusCode == 200 && data != nil) {
                    var date:Date?;
                    let dateStr = httpResponse.allHeaderFields["Last-Modified"] as! String?;
                    if (dateStr != nil) {
                        date = isoDateFormatter().date(from: dateStr!)
                    }
                    assert((date != nil), "we should have last modified date!")
                    
                    setLastContentData(data, url: url)
                    setLastModificationDate(date, url: url)
                    
                    completionHandler(url, data, date, false, err)
                }
                else if(httpResponse.statusCode == 304) {
                    //304 --> nothing new
                    let d = lastContentDataForURL(url)
                    let m = lastModificationDateForURL(url)
                    
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
            
        let d = lastContentDataForURL(url)
            let m = lastModificationDateForURL(url)
            let c = (d != nil) ? true : false;
                    
            completionHandler(url, d, m, c, err)
    }
}

//helpers

fileprivate func DDURLCheckerLastContentData(_ url:URL) -> String {
    return "ModifiedSinceCache_content_" + url.absoluteString
}
fileprivate func DDURLCheckerLastModificationDate(_ url:URL) -> String {
    return "ModifiedSinceCache_modDate_" + url.absoluteString
}

//---

//MARK: -

///the file content last received
fileprivate func lastContentDataForURL(_ url:URL) -> Data? {
    return UserDefaults.standard.data(forKey: DDURLCheckerLastContentData(url))
}

fileprivate func setLastContentData(_ data:Data?, url:URL) {
    if(data != nil) {
        UserDefaults.standard.set(data, forKey: DDURLCheckerLastContentData(url))
    } else {
        UserDefaults.standard.removeObject(forKey: DDURLCheckerLastContentData(url))
    }
}

fileprivate func lastModificationDateForURL(_ url:URL) -> Date? {
    let seconds = UserDefaults.standard.object(forKey: DDURLCheckerLastModificationDate(url)) as! NSNumber?
    if(seconds != nil) {
        return Date(timeIntervalSince1970: seconds!.doubleValue)
    } else {
        return nil
    }
}

fileprivate func setLastModificationDate(_ date:Date?, url:URL) {
    if(date != nil) {
        UserDefaults.standard.set(date!.timeIntervalSince1970, forKey: DDURLCheckerLastModificationDate(url));
    } else {
        UserDefaults.standard.removeObject(forKey: DDURLCheckerLastModificationDate(url))
    }
}

func isoDateFormatter() -> DateFormatter {
    struct Static {
        static let RFC1123DateFormatter: DateFormatter = DateFormatter()
    }
    let enUSPOSIXLocale = Locale(identifier:"en_US_POSIX")
    
    Static.RFC1123DateFormatter.locale = enUSPOSIXLocale
    Static.RFC1123DateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
    Static.RFC1123DateFormatter.timeZone = TimeZone(secondsFromGMT:0)
    
    return Static.RFC1123DateFormatter
}

