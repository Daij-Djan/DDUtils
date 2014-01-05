//
//  NSOperation+Duration.m
//  NSOperationTimingTest
//
//  Created by Dominik Pich on 16.03.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "NSOperation+UserInfo.h"
#import <objc/runtime.h>

static void * const kDDAssociatedStorageUserInfo = (void*)&kDDAssociatedStorageUserInfo;

@implementation NSOperation (UserInfo)

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self, kDDAssociatedStorageUserInfo, [userInfo copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, kDDAssociatedStorageUserInfo);
}

@end
