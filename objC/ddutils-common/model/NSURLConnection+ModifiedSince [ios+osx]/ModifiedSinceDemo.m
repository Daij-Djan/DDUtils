//
//  main.m
//  ModifiedSinceDemo
//
//  Created by Dominik Pich on 12/07/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

#import "NSURLConnection+ModifiedSince.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //note that modified-since requests are a http extension. *MOST* servers can do that right now, but there are some (likely running old software that cannot.)
        
        
        id urlString = @"http://www.pich.info/testfile.txt";
        id url = [NSURL URLWithString:urlString];
        
        id modDate;
        if([NSURLConnection cachedDataForModifiedSinceRequest:url modificationDate:&modDate]) {
            NSLog(@"have cached data for %@ url, cache is from %@", url, modDate);
        }
        else {
            NSLog(@"nothing cached locally");
        }
        

        id newModDate;
        id error;
        BOOL fromCache;
        NSLog(@"Starting modified since request with modDate: %@", modDate);
        if([NSURLConnection doSynchronousModifiedSinceRequestForURL:url modificationDate:&newModDate fromCache:&fromCache error:&error]) {
            if(fromCache) {
                if(error) {
                    NSLog(@"Got cached data, request finished error though: %@", error);
                }
                else {
                    NSLog(@"Got cached data");
                }
            }
            else {
                NSLog(@"Got new data from server, last modified at %@", newModDate);
            }
        }
        else {
            NSLog(@"Got no data. Request failed: %@", error);
        }
        
        //now go and try again to see all cached or modify the server to get fresh data
    }
    return 0;
}
