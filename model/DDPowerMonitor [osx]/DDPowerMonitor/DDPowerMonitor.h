//
//  DDPowerMonitor.h
//
//  Created by Dominik Pich on 19/10/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
/*
 *	Derived from FanControl by Hendrik Holtmann
 */

#import <Foundation/Foundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/ps/IOPSKeys.h>
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>

typedef NS_ENUM(NSUInteger, DDPowerMode) {
    DDPowerModeAC,
    DDPowerModeBattery,
    DDPowerModeACLoading
};
NSString *NSStringFromDDPowerMode(DDPowerMode mode);
DDPowerMode DDPowerModeFromNSString(NSString *modeString);

@class DDPowerMonitor;

@protocol DDPowerMonitorDelegate <NSObject>

@optional
- (void)powerMonitorRegisteredSystemWillGoToSleep:(DDPowerMonitor*)monitor;
- (BOOL)powerMonitorAllowSystemToSleep:(DDPowerMonitor*)monitor;
- (void)powerMonitorRegisteredSystemDidWakeFromSleep:(DDPowerMonitor*)monitor;

- (void)powerMonitor:(DDPowerMonitor*)monitor powerModeChanged:(DDPowerMode)powerMode;

@end

@interface DDPowerMonitor : NSObject
@property(nonatomic, weak) id<DDPowerMonitorDelegate> delegate;

@property(nonatomic, assign) BOOL monitorSleepWake;
@property(nonatomic, assign) BOOL monitorPowerMode;

@end


