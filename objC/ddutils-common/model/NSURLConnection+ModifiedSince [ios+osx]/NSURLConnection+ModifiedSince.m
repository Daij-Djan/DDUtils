//
//  NSURLConnection (ModifiedSince).m
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "NSURLConnection+ModifiedSince.h"

///class extension
@implementation NSURLConnection (ModifiedSince)

static inline NSString *DDURLCheckerLastContentData(NSURL *url) {
    return [NSString stringWithFormat:@"ModifiedSinceCache_content_%@", url.absoluteString];
}
static inline NSString *DDURLCheckerLastModificationDate(NSURL *url) {
    return [NSString stringWithFormat:@"ModifiedSinceCache_modDate_%@", url.absoluteString];
}

///loads url and caches is - it uses a modifiedSince http request
///@param url the url to request
///@param cb the completion handler to asynchronously call back
+ (void)doModifiedSinceRequestForURL:(NSURL*)url
                    completionHandler:(void (^)(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error))cb {
    if ([url isFileURL]) {
        [self perfromLocalFileRequestForURL:url completionHandler:^(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error) {
            cb(url, contentData, modificationDate, fromCache, error);
        }];
    } else {
        [self performNetworkRequestForURL:url async:YES completionHandler:cb];
    }
}

///finds the latest cached data available
///@param url the url requested earlier
///@param pModificationDate a pointer to a date object to fill with the file's modification date
+ (NSData*)cachedDataForModifiedSinceRequest:(NSURL*)url modificationDate:(NSDate**)pModificationDate {
    NSData *data = [self lastContentDataForURL:url];
    if(data) {
        if(pModificationDate) {
            *pModificationDate = [self lastModificationDateForURL:url];
        }
    }
    return data;
}

///clears any cached data
///@param url the url requested earlier
+ (void)removeCachedDataForModifiedSinceRequest:(NSURL*)url {
    [self setLastContentData:nil forURL:url];
    [self setLastModificationDate:nil forURL:url];
}

//---

///SYNCHRONOUSLY loads url and caches is - it uses a modifiedSince http request
///@param url the url to request
///@param pModificationDate a pointer to a date object to fill with the file's modification date
///@param pError a pointer to an error object to fill with the request error that happened date
+ (NSData*)doSynchronousModifiedSinceRequestForURL:(NSURL*)url modificationDate:(NSDate **)pModificationDate fromCache:(BOOL *)pFromCache error:(NSError *__autoreleasing *)pError {
    __block NSData *d;
    __block NSDate *m;
    __block BOOL c;
    __block NSError *e;
    
    if ([url isFileURL]) {
        [self perfromLocalFileRequestForURL:url completionHandler:^(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error) {
            d = contentData;
            m = modificationDate;
            c = fromCache;
            e = error;
        }];
    } else {
        [self performNetworkRequestForURL:url async:NO completionHandler:^(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error) {
            d = contentData;
            m = modificationDate;
            c = fromCache;
            e = error;
        }];
    }
    
    if(pModificationDate)
        *pModificationDate = m;
    if(pFromCache)
        *pFromCache = c;
    if(pError)
        *pError = e;
    
    return d;
}

#pragma mark -

///the file content last received
+ (NSData *)lastContentDataForURL:(NSURL*)url {
    return [[NSUserDefaults standardUserDefaults] dataForKey:DDURLCheckerLastContentData(url)];
}

+ (void)setLastContentData:(NSData *)lastContentData forURL:(NSURL*)url {
    if(lastContentData.length) {
        [[NSUserDefaults standardUserDefaults] setObject:lastContentData forKey:DDURLCheckerLastContentData(url)];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DDURLCheckerLastContentData(url)];
    }
}

+ (NSDate *)lastModificationDateForURL:(NSURL*)url {
    NSNumber *seconds = [[NSUserDefaults standardUserDefaults] objectForKey:DDURLCheckerLastModificationDate(url)];
    if(seconds) {
        return [NSDate dateWithTimeIntervalSince1970:seconds.doubleValue];
    } else {
        return nil;
    }
}

+ (void)setLastModificationDate:(NSDate *)lastModificationDate forURL:(NSURL*)url {
    if(lastModificationDate) {
        NSNumber *seconds = @(lastModificationDate.timeIntervalSince1970);
        [[NSUserDefaults standardUserDefaults] setObject:seconds forKey:DDURLCheckerLastModificationDate(url)];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DDURLCheckerLastModificationDate(url)];
    }
}

#pragma mark checking

+ (void)perfromLocalFileRequestForURL:(NSURL*)url
                     completionHandler:(void (^)(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error))cb {
    NSError *error = nil;
    id modDate = nil;
    id data = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = url.path;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        
        if (attributes) {
            modDate = [attributes fileModificationDate];
            data = [NSData dataWithContentsOfFile:filePath];
        } else {
            if(!error) {
                error = [NSError errorWithDomain:@"DDURLChecker" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Unknown error"}];
            }
        }
        
    } else {
        error = [NSError errorWithDomain:@"DDURLChecker" code:1 userInfo:@{NSLocalizedDescriptionKey: @"file not found error"}];
    }
    
    id lastModDate = [self lastModificationDateForURL:url];
    cb(url, data, modDate, [modDate earlierDate:lastModDate] != lastModDate, error);
}

#pragma mark - 

//in 10.9+ and ios7+ this is thread safe
+ (NSDateFormatter*)isoDateFormatter {
    //dateFormatter
    static dispatch_once_t onceToken;
    static NSDateFormatter *RFC1123DateFormatter = nil;
    dispatch_once(&onceToken, ^{
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        // Convert the RFC 1123 date time string to an NSDate.
        // Date: Tue, 15 Nov 1994 08:12:31 GMT
        RFC1123DateFormatter = [[NSDateFormatter alloc] init];
        [RFC1123DateFormatter setLocale:enUSPOSIXLocale];
        [RFC1123DateFormatter setDateFormat:@"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"];
        [RFC1123DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    return RFC1123DateFormatter;
}

+ (void)performNetworkRequestForURL:(NSURL*)url
                              async:(BOOL)async
                   completionHandler:(void (^)(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error))cb {
    //prepare request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60.0];
    
    id lastMod = [self lastModificationDateForURL:url];
    if(lastMod) {
        NSString *dateValue = [[self isoDateFormatter] stringFromDate:lastMod];
        [request addValue:dateValue forHTTPHeaderField:@"If-Modified-Since"];
    }
    
    //perform request
    if(async) {
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   [self networkRequestFinished:request response:response data:data error:error completionHandler:cb];
                               }];
    }
    else {
        if([NSThread isMainThread])
            NSLog(@"Should not do a synchronous network request on the main thread");
        
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        [self networkRequestFinished:request response:response data:data error:error completionHandler:cb];
    }
}

+ (void)networkRequestFinished:(NSURLRequest*)request
                      response:(NSURLResponse *)response
                          data:(NSData *)data
                         error:(NSError *)error
              completionHandler:(void (^)(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error))cb {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSURL *url = request.URL;
    
    if (httpResponse.statusCode != 304) {
        if (httpResponse.statusCode == 200 && data) {
            id date;
            NSString *dateStr = httpResponse.allHeaderFields[@"Last-Modified"];
            if (dateStr) {
                date = [[self isoDateFormatter] dateFromString:dateStr];
            }
            assert(date);
            
            [self setLastContentData:data forURL:url];
            [self setLastModificationDate:date forURL:url];

            cb(url, data, date, NO, nil );
        }
        else {
            if(!error) {
                error = [NSError errorWithDomain:@"DDURLChecker" code:0 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"HTTP error %li", (long)httpResponse.statusCode]}];
            }

            id d = [self lastContentDataForURL:url];
            cb(url, d, d?[self lastModificationDateForURL:url]:nil, d?YES:NO , error );
        }
    }
    else {
        //304 --> nothing new
        cb(url, [self lastContentDataForURL:url], [self lastModificationDateForURL:url], YES, error );
    }
}

@end
