//
//  DDAnimatingView.m
//  animatingView
//
//  Created by Dominik Pich on 28/04/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import "DDSlidingImageView.h"
#import "DDRectUtilities.h"

@implementation DDSlidingImageView {
    CGFloat _sourceValue;
    CGFloat _targetValue;
    NSDate *_startDate;
    NSDate *_endDate;
    CADisplayLink *_displayLink;

    CGFloat _currentValue; //shown
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
    
}
- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    [self setNeedsDisplay];
}

- (void)setSliderValue:(CGFloat)sliderValue {
    if(sliderValue < 0) sliderValue = 0;
    
    _sliderValue = sliderValue;
    if(_currentValue != _sliderValue) {
        [self moveSlider];
    }
}

- (void)setSliderDuration:(CGFloat)sliderDuration {
    if(sliderDuration < 0) sliderDuration = 0;
    _sliderDuration = sliderDuration;
    
    if(_currentValue != self.sliderValue) {
        [self moveSlider];
    }
}

- (void)setSliderDirection:(NSUInteger)sliderDirection {
    _sliderDirection = sliderDirection;
    [self setNeedsDisplay];
}

#pragma mark - animating

- (void)moveSlider {
    if(!self.sliderDuration) {
        _currentValue = self.sliderValue;
        [self setNeedsDisplay];
    }
    else {
        [self reflectSliderValueAnimated];
    }
}

- (void)reflectSliderValueAnimated {
    _sourceValue = _currentValue; // set start to current color
    _targetValue = self.sliderValue; // destination color
    _startDate = [NSDate date]; // begins currently, you could add some delay if you wish
    _endDate = [_startDate dateByAddingTimeInterval:self.sliderDuration]; // will define animation duration
    
    [_displayLink invalidate]; // if one already exists
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onFrame)]; // create the display link
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (CGFloat)interpolatedValue:(CGFloat)sourceValue withValue:(CGFloat)targetValue forScale:(CGFloat)scale {
    // this will interpolate between two values
    CGFloat between = targetValue - sourceValue;
    return sourceValue+between*scale;
}

- (void)onFrame {
    // scale is valid between 0 and 1
    CGFloat scale = [[NSDate date] timeIntervalSinceDate:_startDate] / [_endDate timeIntervalSinceDate:_startDate];
    if(scale < .0f) {
        // this can happen if delay is used
        scale = .0f;
    }
    else if(scale > 1.0f)
    {
        // end animation
        scale = 1.0f;
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    //draw the current value
    _currentValue = [self interpolatedValue:_sourceValue withValue:_targetValue forScale:scale];
    [self setNeedsDisplay];
}

#pragma mark - drawing

- (void)drawRect:(CGRect)rect {
    CGRect imageRect = [DDRectUtilities adjustRectOfSize:_image.size forContentOfView:self];
    [_image drawInRect:imageRect];
    
    //figure out the bounds based frame for the _currentValue
    CGRect valueFrame = imageRect;
    if(self.sliderDirection % 2 == 0) {
        valueFrame.size.height *= _currentValue;

        if(self.sliderDirection == DDSlidingDirectionBottom) {
            valueFrame.origin.y = imageRect.origin.y + imageRect.size.height - valueFrame.size.height;
        }
    }
    else {
        valueFrame.size.width *= _currentValue;
        
        if(self.sliderDirection == DDSlidingDirectionRight) {
            valueFrame.origin.x = imageRect.origin.x + imageRect.size.width - valueFrame.size.width;
        }
    }
    
    [self.sliderColor setFill];
    UIRectFillUsingBlendMode(valueFrame, kCGBlendModeColorBurn);
}


@end