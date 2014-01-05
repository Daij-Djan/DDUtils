//
//  DDMicBlowDetector.m
//
//  Created by Dominik Pich on 10/19/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//  Based on a tutorial from Mobile Orchad by Dan Grigsby
//
#import "DDMicBlowDetector.h"

#define DDMicBlowDetectorTimerSpeed 0.03
#define DDMicBlowDetectorLowPassFilterAlpha 0.05
#define DDMicBlowDetectorDefaultRequiredConfidence 0.95

@implementation DDMicBlowDetector {
	AVAudioRecorder *recorder;
	NSTimer *levelTimer;
	double lowPassResults;
    NSTimeInterval latestDuration;
    BOOL waitForStop;
}

+ (DDMicBlowDetector*)sharedDetector {
    static DDMicBlowDetector *_sharedDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDetector = [[[self class] alloc] init];
    });
    return _sharedDetector;
}

+ (BOOL)microphoneAvailable {
    return [[AVAudioSession sharedInstance] isInputAvailable];
}

- (id)init {
    self = [super init];
    if(self) {
        self.minDuration = 0;
        self.maxDuration = 0;
        self.requiredConfidence = DDMicBlowDetectorDefaultRequiredConfidence;
    }
    return self;
}

- (void)dealloc {
    [self stop];
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}

#pragma mark -
             
- (void)setMonitoring:(BOOL)flag {
    if(flag && !_monitoring) {
        [self start];
    }
    else if(!flag && _monitoring){
        [self stop];
    }
    _monitoring = flag;
}

#pragma mark -

- (void)start {
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = @{AVSampleRateKey: @44100.0f,
                              AVFormatIDKey: @(kAudioFormatAppleLossless),
                              AVNumberOfChannelsKey: @1,
                              AVEncoderAudioQualityKey: @(AVAudioQualityMax)};
    
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (recorder) {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval:DDMicBlowDetectorTimerSpeed target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
#if __has_feature(objc_arc)
#else
        [levelTimer retain];
#endif
    } else
        @throw [NSException exceptionWithName:@"DDMicBlowDetector cant start" reason:@"Cant init AVAudioRecorder with output to /dev/null" userInfo:nil];
}

- (void)stop {
#if __has_feature(objc_arc)
#else
	[levelTimer release];
	[recorder release];
#endif
    levelTimer = nil;
    recorder = nil;
    
    latestDuration = 0;
    lowPassResults = 0;
    waitForStop = NO;
}


#pragma mark -

- (void)levelTimerCallback:(NSTimer *)timer {
    NSString *noteName = nil;
    double noteDuration;
    
    //check mic levels
	[recorder updateMeters];
    
    //apply filter and check for mic blow
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = DDMicBlowDetectorLowPassFilterAlpha * peakPowerForChannel + (1.0 - DDMicBlowDetectorLowPassFilterAlpha) * lowPassResults;
	BOOL micBlowDetected = lowPassResults > self.requiredConfidence;
    
    //decide on what notification to send (if any)
	if (micBlowDetected) {
        BOOL startedBefore = latestDuration >= self.minDuration;

        latestDuration += DDMicBlowDetectorTimerSpeed;
        noteDuration = latestDuration;

        if(latestDuration >= self.minDuration) {
            if(!startedBefore)
                noteName = DDMicBlowDetectorDidDetectStart;
            else {
                if(!waitForStop &&
                   self.maxDuration > self.minDuration &&
                   latestDuration > self.maxDuration) {
                    noteName = DDMicBlowDetectorDidDetectTooLong;
                    waitForStop = YES;
                }
                else
                    noteName = DDMicBlowDetectorDidDetectContinue;
            }
        }
    }
    else {
        if(!waitForStop && latestDuration) {
            if(latestDuration < self.minDuration) {
                noteName = DDMicBlowDetectorDidDetectTooShort;
            }
            else {
                noteName = DDMicBlowDetectorDidDetectStop;
            }
        }
        
        noteDuration = latestDuration;
        latestDuration=0;
        waitForStop = NO;
    }
    
    //send notification
    if(noteName) {
#ifdef DEBUG
        NSLog(@"Sending: %@ %f", noteName, noteDuration);
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:noteName object:self userInfo:@{DDMicBlowDetectorDuration : @(noteDuration)}];
    }
}

@end

//notifications for blowing into microphone
NSString *DDMicBlowDetectorDidDetectStart = @"DDMicBlowDetectorDidDetectStart";
NSString *DDMicBlowDetectorDidDetectContinue = @"DDMicBlowDetectorDidDetectContinue";
NSString *DDMicBlowDetectorDidDetectStop = @"DDMicBlowDetectorDidDetectStop";
NSString *DDMicBlowDetectorDidDetectTooShort = @"DDMicBlowDetectorDidDetectTooShort";
NSString *DDMicBlowDetectorDidDetectTooLong = @"DDMicBlowDetectorDidDetectTooLong";

NSString *DDMicBlowDetectorDuration = @"DDMicBlowDetectorDuration";