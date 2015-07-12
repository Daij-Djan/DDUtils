//
//  NSURLConnection (ModifiedSince).h
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (ModifiedSince)

///loads url and caches is - it uses a modifiedSince http request
///@param url the url to request
///@param cb the completion handler to asynchronously call back
+ (void)doModifiedSinceRequestForURL:(NSURL*)url
                    completionHandler:(void (^)(NSURL *url, NSData *contentData, NSDate *modificationDate, BOOL fromCache, NSError *error))cb;

///finds the latest cached data available
///@param url the url requested earlier
///@param pModificationDate a pointer to a date object to fill with the file's modification date
+ (NSData*)cachedDataForModifiedSinceRequest:(NSURL*)url modificationDate:(NSDate**)pModificationDate;

///clears any cached data
///@param url the url requested earlier
+ (void)removeCachedDataForModifiedSinceRequest:(NSURL*)url;

//---

///SYNCHRONOUSLY loads url and caches is - it uses a modifiedSince http request
///@param url the url to request
///@param pModificationDate a pointer to a date object to fill with the file's modification date
///@param pError a pointer to an error object to fill with the request error that happened date
+ (NSData*)doSynchronousModifiedSinceRequestForURL:(NSURL*)url modificationDate:(NSDate **)pModificationDate fromCache:(BOOL*)pFromCache error:(NSError **)pError;

@end
