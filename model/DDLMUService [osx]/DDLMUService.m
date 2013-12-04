//
//  DDLMUService.m
//
//  Created by Dominik Pich 11/2013
/**
 * based loosly on code:
 * Created by Nicholas Jitkoff on 5/14/07.
 * Copyright 2007 Blacktree. All rights reserved.
*/
#import "DDLMUService.h"

#include <math.h>
#include <mach/mach.h>
#include <IOKit/IOKitLib.h>

#pragma mark DDLMUServiceCall

enum {
    DDLMUServiceCallGetSensorReadingID   = 0,  // getSensorReading(int *, int *)
    DDLMUServiceCallGetLEDBrightnessID   = 1,  // getLEDBrightness(int, int *)
    DDLMUServiceCallSetLEDBrightnessID   = 2,  // setLEDBrightness(int, int, int *)
    DDLMUServiceCallFadeLEDBrightnessID  = 3,  // setLEDFade(int, int, int, int *)
} DDLMUServiceCall;

@implementation DDLMUService {
    io_connect_t dataPort;
}

+ (BOOL)isAvailable {
    io_service_t serviceObject = [self copySensorService];
    if (serviceObject) {
        IOObjectRelease(serviceObject);
        return YES;
    }
    return NO;
}

+ (io_service_t)copySensorService {
    // Look up a registered IOService object whose class is AppleLMUController
    io_service_t serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                             IOServiceMatching("AppleLMUController"));
    if (!serviceObject) {
        serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                    IOServiceMatching("IOI2CDeviceLMU"));
    }
    
    return serviceObject;
}

#pragma mark -

- (id) init {
    self = [super init];
    if (self != nil) {
        //get service
        io_service_t serviceObject = [self.class copySensorService];
        if (!serviceObject) {
            fprintf(stderr, "failed to find ambient light sensor\n");
            return nil;
        }
        
        // Create a connection to the IOService object
        kern_return_t kr = IOServiceOpen(serviceObject, mach_task_self(), 0, &dataPort);
        IOObjectRelease(serviceObject);
        if (kr != KERN_SUCCESS) {
            mach_error("IOServiceOpen:", kr);
            return nil;
        }
    }
    return self;
}



- (void) dealloc {
    if(dataPort) {
        IOServiceClose(dataPort);
    }
}

#pragma mark -

#define kGetSensorMaxValue 12 //dont know if this is ok .. dont even know if LMU is linear or logarithmic or whatever. I apply a logarithmus and accept values till 13

- (CGFloat)sensorPercentageValue {
    CGFloat percentage = -1;
    
    //Get the ALS reading
    uint32_t scalarOutputCount = 2;
    uint64_t values[scalarOutputCount];
    
    kern_return_t kr = IOConnectCallMethod(dataPort,
                                           DDLMUServiceCallGetSensorReadingID,
                                           nil,
                                           0,
                                           nil,
                                           0,
                                           values,
                                           &scalarOutputCount,
                                           nil,
                                           0);
    
    if (kr == KERN_SUCCESS && scalarOutputCount >= 2) {
        double newLeft = log2(values[0]);
        double newRight = log2(values[1]);
        
        double newAvg = (newLeft + newRight) / 2;
        percentage = 100.0 * (CGFloat)(newAvg-kGetSensorMaxValue) / kGetSensorMaxValue;
    }
    else if(kr == kIOReturnBusy) {
        NSLog(@"kIOReturnBusy");
    }
    else {
        mach_error("I/O Kit error:", kr);
    }
    
    return percentage;
}

#define kLEDBrightnessMaxValue 4091

- (CGFloat)keyboardLightPercentageValue {
    CGFloat percentage = -1;
    
    //Get the ALS reading
    IOItemCount   scalarInputCount  = 1;
    IOItemCount   scalarOutputCount = 1;
    UInt64        in_unknown = 0, out_brightness;
    
    kern_return_t kr = IOConnectCallMethod(dataPort,
                                           DDLMUServiceCallGetLEDBrightnessID,
                                           &in_unknown,
                                           scalarInputCount,
                                           nil,
                                           0,
                                           &out_brightness,
                                           &scalarOutputCount,
                                           nil,
                                           0);
    
    if (kr == KERN_SUCCESS && scalarOutputCount >= 1) {
        double newVal = out_brightness;

        percentage = 100.0 * (CGFloat)newVal / kLEDBrightnessMaxValue;

    }
    else if(kr == kIOReturnBusy) {
        NSLog(@"kIOReturnBusy");
    }
    else {
        mach_error("I/O Kit error:", kr);
    }

    return percentage;
}

- (void)setKeyboardLightPercentageValue:(CGFloat)keyboardLightPercentageValue {
    UInt64 value = keyboardLightPercentageValue/100 * kLEDBrightnessMaxValue;

    //Set the ALS
    IOItemCount   scalarInputCount  = 2;
    IOItemCount   scalarOutputCount = 1;
    UInt64        out_brightness;
    uint64_t      ins[scalarInputCount];
    
    ins[1] = value;
    
    kern_return_t kr = IOConnectCallMethod(dataPort,
                                           DDLMUServiceCallSetLEDBrightnessID,
                                           (const uint64_t*)&ins,
                                           scalarInputCount,
                                           nil,
                                           0,
                                           &out_brightness,
                                           &scalarOutputCount,
                                           nil,
                                           0);
    
//    if (kr == KERN_SUCCESS && scalarOutputCount >= 1) {
//        double newVal = out_brightness;
//        double percentage = 100.0 * (CGFloat)newVal / kLEDBrightnessMaxValue;
//    }
//    else
    if(kr == kIOReturnBusy) {
        NSLog(@"kIOReturnBusy");
    }
    else if(kr != KERN_SUCCESS) {
        mach_error("I/O Kit error:", kr);
    }
}

- (void)fadeKeyboardLightTo:(CGFloat)keyboardLightPercentageValue
                   duration:(NSUInteger)duration
          completionHandler:(void (^)())handler {
    UInt64 value = keyboardLightPercentageValue/100 * kLEDBrightnessMaxValue;
    
    //Set the ALS
    IOItemCount   scalarInputCount  = 3;
    IOItemCount   scalarOutputCount = 1;
    UInt64        out_brightness;
    uint64_t      ins[scalarInputCount];
    
    ins[1] = value;
    ins[2] = duration;
    
    kern_return_t kr = IOConnectCallMethod(dataPort,
                                           DDLMUServiceCallFadeLEDBrightnessID,
                                           (const uint64_t*)&ins,
                                           scalarInputCount,
                                           nil,
                                           0,
                                           &out_brightness,
                                           &scalarOutputCount,
                                           nil,
                                           0);
    
    if (kr == KERN_SUCCESS && scalarOutputCount >= 1) {
        double delayInSeconds = (double)duration/1000.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            handler();
        });
    }
    else if(kr == kIOReturnBusy) {
        NSLog(@"kIOReturnBusy");
    }
    else {
        mach_error("I/O Kit error:", kr);
    }
}

@end
