//
//  NSOperation+UserInfo.h
//  NSOperationTimingTest
//
//  Created by Dominik Pich on 26.04.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation (UserInfo)

@property(copy) NSDictionary *userInfo;

@end
