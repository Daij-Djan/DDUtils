//
//  UIAlertView (UserInfo)
//  DecisionMaker
//
//  Created by Dominik Pich on 01.04.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "UIAlertView+UserInfo.h"
#import <objc/runtime.h>

@implementation UIAlertView (UserInfo)

#define kUserInfoKey     @"DDUserInfo"

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self, kUserInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, kUserInfoKey);
}

@end
