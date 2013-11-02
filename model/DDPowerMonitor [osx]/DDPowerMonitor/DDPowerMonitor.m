//
//  DDPowerMonitor.h
//
//  Created by Dominik Pich on 19/10/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
/*
 *	Derived from FanControl by Hendrik Holtmann
 */

#import "DDPowerMonitor.h"

NSString *NSStringFromDDPowerMode(DDPowerMode mode) {
    switch (mode) {
        case DDPowerModeACLoading:
            return @"AC Power (Charging)";
        case DDPowerModeAC:
            return @"AC Power";
        case DDPowerModeBattery:
            return @"Battery Power";
    }
}
DDPowerMode DDPowerModeFromNSString(NSString *modeString) {
    if ([modeString isEqualToString:@"AC Power (Charging)"]) {
        return DDPowerModeACLoading;
    }
    else if ([modeString isEqualToString:@"AC Power"]) {
        return DDPowerModeAC;
    }
    else { //if ([modeString isEqualToString:@"Battery Power"]) {
        return DDPowerModeBattery;
    }
    
}

//prototypes
void SleepWatcher( void * refCon, io_service_t service, natural_t messageType, void * messageArgument );
static void powerSourceChanged(void * refCon);

@implementation DDPowerMonitor {
    io_connect_t root_port;
	io_object_t notifier;
	IONotificationPortRef notificationPort;
    CFRunLoopSourceRef powerNotifierRunLoopSource;

    DDPowerMode _currentPowerMode;
}

- (void)setMonitorPowerMode:(BOOL)monitorPowerMode {
    if(monitorPowerMode && !_monitorPowerMode) {
        [self registerForPowerChange];
    }
    else if(!monitorPowerMode && _monitorPowerMode) {
        [self deregisterForPowerChange];
    }
    _monitorPowerMode = monitorPowerMode;
}

- (void)setMonitorSleepWake:(BOOL)monitorSleepWake {
    if(monitorSleepWake && !_monitorSleepWake) {
        [self registerForSleepWakeNotification];
    }
    else if(!monitorSleepWake && _monitorSleepWake) {
        [self deregisterForSleepWakeNotification];
    }
    _monitorSleepWake = monitorSleepWake;
}

#pragma mark register/deregister

- (void)registerForSleepWakeNotification
{
	root_port = IORegisterForSystemPower((__bridge void *)(self), &notificationPort, SleepWatcher, &notifier);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notificationPort), kCFRunLoopDefaultMode);
}


- (void)registerForPowerChange
{
	powerNotifierRunLoopSource = IOPSNotificationCreateRunLoopSource(powerSourceChanged,(__bridge void *)(self));
	if (powerNotifierRunLoopSource) {
		CFRunLoopAddSource(CFRunLoopGetCurrent(), powerNotifierRunLoopSource, kCFRunLoopDefaultMode);
	}
}


- (void)deregisterForSleepWakeNotification
{
	CFRunLoopRemoveSource( CFRunLoopGetCurrent(),
                         IONotificationPortGetRunLoopSource(notificationPort),
                         kCFRunLoopCommonModes );
	IODeregisterForSystemPower(&notifier);
	IOServiceClose(root_port);
	IONotificationPortDestroy(notificationPort);
}

- (void)deregisterForPowerChange{
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), powerNotifierRunLoopSource, kCFRunLoopDefaultMode);
	CFRelease(powerNotifierRunLoopSource);
}

#pragma mark notifications

- (void)powerMessageReceived:(natural_t)messageType withArgument:(void *) messageArgument
{
    BOOL br = YES;
    
	switch (messageType)
	{
		case kIOMessageSystemWillSleep:
            if ([self.delegate respondsToSelector:@selector(powerMonitorRegisteredSystemWillGoToSleep:)]) {
                [self.delegate powerMonitorRegisteredSystemWillGoToSleep:self];
            }
			IOAllowPowerChange(root_port, (long)messageArgument);
            break;
            
		case kIOMessageCanSystemSleep:
            if ([self.delegate respondsToSelector:@selector(powerMonitorAllowSystemToSleep:)]) {
                br = [self.delegate powerMonitorAllowSystemToSleep:self];
            }
            if (br) {
                IOAllowPowerChange(root_port, (long)messageArgument);
            }
            else {
                IOCancelPowerChange(root_port, (long)messageArgument);
            }
            break;
            
		case kIOMessageSystemHasPoweredOn:
            if ([self.delegate respondsToSelector:@selector(powerMonitorRegisteredSystemDidWakeFromSleep:)]) {
                [self.delegate powerMonitorRegisteredSystemDidWakeFromSleep:self];
            }
            break;
	}
}

- (void)powerSourceMesssageReceived:(NSDictionary *)n_description{
    DDPowerMode newMode;
    
    if ([[n_description objectForKey:@"Power Source State"] isEqualToString:@"AC Power"] &&
         [[n_description objectForKey:@"Is Charging"] intValue]==1) {
        newMode = DDPowerModeACLoading;
    }
    else if ([[n_description objectForKey:@"Power Source State"] isEqualToString:@"AC Power"] &&
         [[n_description objectForKey:@"Is Charging"] intValue]==0) {
        newMode = DDPowerModeAC;
    }
    else { //if ([[n_description objectForKey:@"Power Source State"] isEqualToString:@"Battery Power"]) {
        newMode = DDPowerModeBattery;
    }
    
    if(_currentPowerMode != newMode) {
        if ([self.delegate respondsToSelector:@selector(powerMonitor:powerModeChanged:)]) {
            [self.delegate powerMonitor:self powerModeChanged:newMode];
        }
    }
    
    _currentPowerMode = newMode;
}

#pragma mark C-Callbacks

void SleepWatcher( void * refCon, io_service_t service, natural_t messageType, void * messageArgument ) {
    DDPowerMonitor *monitor = (__bridge DDPowerMonitor*)refCon;
    [monitor powerMessageReceived: messageType withArgument: messageArgument];
}

static void powerSourceChanged(void * refCon) {
	CFTypeRef	powerBlob = IOPSCopyPowerSourcesInfo();
	CFArrayRef	powerSourcesList = IOPSCopyPowerSourcesList(powerBlob);
	NSUInteger	count = CFArrayGetCount(powerSourcesList);
    DDPowerMonitor *monitor = (__bridge DDPowerMonitor*)refCon;

	NSUInteger i;
	for (i = 0U; i < count; ++i) {  //in case we have several powersources
		CFTypeRef		powerSource = CFArrayGetValueAtIndex(powerSourcesList, i);
		CFDictionaryRef description = IOPSGetPowerSourceDescription(powerBlob, powerSource);

		NSDictionary *n_description = (__bridge NSDictionary *)description;
		[monitor powerSourceMesssageReceived:n_description];
	}
	CFRelease(powerBlob);
	CFRelease(powerSourcesList);
}

@end
