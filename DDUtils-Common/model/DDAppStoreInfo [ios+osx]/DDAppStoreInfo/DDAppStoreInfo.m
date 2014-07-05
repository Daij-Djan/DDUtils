//
//  DDAppStoreInfo.m
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDAppStoreInfo.h"

@implementation DDAppStoreInfo {
    NSDictionary *_info;
    UIImage *_smallArtwork;
}

- (NSString *)name {
    return _info[@"trackName"];
}

- (NSString *)description {
    return _info[@"description"];
}

- (UIImage *)smallArtwork {
    return _smallArtwork;
}

- (NSURL *)storeURL {
    return [NSURL URLWithString:_info[@"trackViewUrl"]];
}

- (NSDictionary *)json {
    return _info;
}
#pragma mark -

+ (void)appStoreInfoForID:(NSString*)idString completion:(void (^)(DDAppStoreInfo *appstoreInfo))completion {
    NSParameterAssert([idString hasPrefix:@"id"]);

    NSString *numericIDStr = [idString substringFromIndex:2];
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", numericIDStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *results = [dict objectForKey:@"results"];
        NSDictionary *result = [results objectAtIndex:0];
        
        //small icon
        NSString *imageUrlStr = [result objectForKey:@"artworkUrl60"];
        NSURL *artworkURL = [NSURL URLWithString:imageUrlStr];
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:artworkURL]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            UIImage *artworkImage = [UIImage imageWithData:data];

            DDAppStoreInfo *storeInfo = [[DDAppStoreInfo alloc] init];
            storeInfo->_info = result;
            storeInfo->_smallArtwork = artworkImage;
            
            completion(storeInfo);
        }];
    }];
}

@end
