//
//  DDAppStoreInfo.h
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAppStoreInfo : NSArray

//samples extracted from the json... just a demo
@property(readonly) NSURL *appstoreID;
@property(readonly) NSString *name;
@property(readonly) NSString *description;
@property(readonly) UIImage *smallArtwork;
@property(readonly) NSURL *storeURL;

@property(readonly) NSDictionary *json;

+ (void)appStoreInfoForID:(NSString*)appstoreID completion:(void (^)(DDAppStoreInfo *appstoreInfo))completion;
@end
