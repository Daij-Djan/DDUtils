//
//  main.m
//  PowerMonitor
//
//  Created by Dominik Pich on 02/11/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDPowerMonitor.h"

@interface Test : NSObject <DDPowerMonitorDelegate>
- (void)run;
@end

@implementation Test {
    DDPowerMonitor *_power;
}

- (void)run {
    _power = [[DDPowerMonitor alloc] init];
    _power.monitorPowerMode = YES;
    _power.monitorSleepWake = YES;
    _power.delegate = self;
    
    //run
    [[NSRunLoop currentRunLoop] run];
}

- (void)powerMonitor:(DDPowerMonitor  *)monitor powerModeChanged:(DDPowerMode)powerMode {
    NSLog(@"Power mode changed to %@", NSStringFromDDPowerMode(powerMode));
}

- (BOOL)powerMonitorAllowSystemToSleep:(DDPowerMonitor  *)monitor {
    NSLog(@"allow sleep");
    return YES;
}

- (void)powerMonitorRegisteredSystemDidWakeFromSleep:(DDPowerMonitor  *)monitor {
    NSLog(@"did wake");
}

- (void)powerMonitorRegisteredSystemWillGoToSleep:(DDPowerMonitor  *)monitor {
    NSLog(@"will sleep");
}

@end

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Test *test = [[Test alloc] init];
        [test run];
    }
    return 0;
}

