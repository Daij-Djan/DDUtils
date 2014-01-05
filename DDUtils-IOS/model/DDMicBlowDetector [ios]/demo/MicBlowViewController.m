#import "DDMicBlowDetector.h"
#import "MicBlowViewController.h"

@implementation MicBlowViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.minDuration.text = @([DDMicBlowDetector sharedDetector].minDuration).stringValue;
    self.maxDuration.text = @([DDMicBlowDetector sharedDetector].maxDuration).stringValue;
    self.requiredConfidence.text = @([DDMicBlowDetector sharedDetector].requiredConfidence).stringValue;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(micBlowStarted:)
                                                 name:DDMicBlowDetectorDidDetectStart
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(micBlowContinued:)
                                                 name:DDMicBlowDetectorDidDetectContinue
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(micBlowStopped:)
                                                 name:DDMicBlowDetectorDidDetectStop
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(micBlowWasTooShort:)
                                                 name:DDMicBlowDetectorDidDetectTooShort
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(micBlowIsTooLong:)
                                                 name:DDMicBlowDetectorDidDetectTooLong
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if([DDMicBlowDetector sharedDetector].monitoring)
        [self toggleMonitor:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDMicBlowDetectorDidDetectStart object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDMicBlowDetectorDidDetectContinue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDMicBlowDetectorDidDetectStop object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDMicBlowDetectorDidDetectTooShort object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DDMicBlowDetectorDidDetectTooLong object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [DDMicBlowDetector sharedDetector].monitoring = NO;
#if __has_feature(objc_arc)
#else
    [_minDuration release];
    [_maxDuration release];
    [_dectedState release];
    [_detectedDuration release];
    [_toggleMonitor release];
    [super dealloc];
#endif
}

- (IBAction)toggleMonitor:(id)sender {
    if(![DDMicBlowDetector sharedDetector].monitoring) {
        [DDMicBlowDetector sharedDetector].minDuration = self.minDuration.text.doubleValue;
        [DDMicBlowDetector sharedDetector].maxDuration = self.maxDuration.text.doubleValue;
        [DDMicBlowDetector sharedDetector].monitoring = YES;
        
        self.toggleMonitor.selected = YES;
        self.minDuration.superview.hidden = YES;
        self.dectedState.superview.hidden = NO;
    }
    else {
        [DDMicBlowDetector sharedDetector].monitoring = NO;
        
        self.toggleMonitor.selected = NO;
        self.minDuration.superview.hidden = NO;
        self.dectedState.superview.hidden = YES;
    }
}

#pragma mark -

-(void)micBlowStarted:(NSNotification*)note {
    self.dectedState.text = @"Started";
    self.detectedDuration.text = [NSString stringWithFormat:@"%.2f", [note.userInfo[DDMicBlowDetectorDuration] doubleValue]];
}

-(void)micBlowContinued:(NSNotification*)note {
    self.detectedDuration.text = [NSString stringWithFormat:@"%.2f", [note.userInfo[DDMicBlowDetectorDuration] doubleValue]];
}

-(void)micBlowStopped:(NSNotification*)note {
    self.dectedState.text = @"Stopped";
    self.detectedDuration.text = [NSString stringWithFormat:@"%.2f", [note.userInfo[DDMicBlowDetectorDuration] doubleValue]];
}

-(void)micBlowWasTooShort:(NSNotification*)note {
    self.dectedState.text = @"Too Short";
    self.detectedDuration.text = [NSString stringWithFormat:@"%.2f", [note.userInfo[DDMicBlowDetectorDuration] doubleValue]];
}

-(void)micBlowIsTooLong:(NSNotification*)note {
    self.dectedState.text = @"Too Long";
    self.detectedDuration.text = [NSString stringWithFormat:@"%.2f", [note.userInfo[DDMicBlowDetectorDuration] doubleValue]];
}

@end
