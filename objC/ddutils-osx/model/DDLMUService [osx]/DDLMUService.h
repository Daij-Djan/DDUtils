//
//  DDLMUService.h
//
//  Created by Dominik Pich 11/2013
/**
 * based loosly on code:
 * Created by Nicholas Jitkoff on 5/14/07.
 * Copyright 2007 Blacktree. All rights reserved.
 */
#include <Foundation/Foundation.h>

//does not send notifications right now
@interface DDLMUService : NSObject

+ (BOOL)isAvailable;

/**
 read the averaged values from the left+right ambient light sensor
 NOTE: I expirement with the values here... they seem good to me but I need to test it on different machines 
 values 0 - 100%
 **/
@property(nonatomic, readonly) CGFloat sensorPercentageValue;

/**
 get or set the backlight of your LED keyboard
 values 0 - 100%
 **/
@property(nonatomic, assign) CGFloat keyboardLightPercentageValue;

/**
 fades the keyboard backlight from the current value to the specified value 
 @param keyboardLightPercentageValue the target value
 @param duration the duration for the fade in milliseconds
 @param handler the block to call after the fade
 **/
- (void)fadeKeyboardLightTo:(CGFloat)keyboardLightPercentageValue
                   duration:(NSUInteger)duration
          completionHandler:(void (^)())handler;

@end