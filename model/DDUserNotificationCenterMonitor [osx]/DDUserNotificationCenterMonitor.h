//
//  DDUserNotificationCenterMonitor.h
//  DiscoNotifier
//
//  Created by Dominik Pich on 02/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUserNotificationCenterMonitor : NSObject

/**
 returns the number of notifications that are currently presented in the NC (of any app -- in the visible sidebar)
 NOTE: Supports KVO
 NOTE: Only works while started
 **/
@property(nonatomic, readonly) NSUInteger numberOfPresentedNotifications;

- (BOOL)start:(NSError**)pError;
- (void)stop;

@end
