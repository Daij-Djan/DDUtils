//
//  DDSocialMessenger.h
//
//  Created by Dominik Pich on 17.08.11.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/ACAccountType.h>

typedef void (^DDSocialMessengerCompletionBlock)(NSArray *accountsNotified);
#define DDFacebookAppIdKey @"DDFacebookAppIdKey"

@interface DDSocialMessenger : NSObject

+ (NSString *)facebookAppID; //read from info.plist

+ (void)postToTwitter:(NSString  *)text completion:(DDSocialMessengerCompletionBlock)completion;
+ (void)postToFacebook:(NSString  *)text completion:(DDSocialMessengerCompletionBlock)completion;

+ (void)broadcast:(NSString *)text to:(NSArray *)accounts completion:(DDSocialMessengerCompletionBlock)completion;

@end
