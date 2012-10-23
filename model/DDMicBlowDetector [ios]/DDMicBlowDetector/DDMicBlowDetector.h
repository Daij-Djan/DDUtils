//
//  DDMicBlowDetector.h
//
//  Created by Dominik Pich on 10/19/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//  Based on a tutorial from Mobile Orchad by Dan Grigsby
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface DDMicBlowDetector : NSObject

+ (DDMicBlowDetector*)sharedDetector;
+ (BOOL)microphoneAvailable;

@property(nonatomic, assign) BOOL monitoring;
@property(nonatomic, assign) NSTimeInterval minDuration;
@property(nonatomic, assign) NSTimeInterval maxDuration;
@property(nonatomic, assign) double requiredConfidence;

@end

//notifications for blowing into microphone
extern NSString *DDMicBlowDetectorDidDetectStart;
extern NSString *DDMicBlowDetectorDidDetectContinue;
extern NSString *DDMicBlowDetectorDidDetectStop;
extern NSString *DDMicBlowDetectorDidDetectTooShort;
extern NSString *DDMicBlowDetectorDidDetectTooLong;

extern NSString *DDMicBlowDetectorDuration;