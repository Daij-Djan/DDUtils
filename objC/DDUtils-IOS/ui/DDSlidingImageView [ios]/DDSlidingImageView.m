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

- (void)setSliderCapColor:(UIColor *)sliderCapColor {
    _sliderCapColor = sliderCapColor;
    [self setNeedsDisplay];
}

- (void)setSliderCapThickness:(CGFloat)sliderCapThickness {
    _sliderCapThickness = sliderCapThickness;
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

- (void)setHideCapIfTooThin:(BOOL)hideCapIfTooThin {
    _hideCapIfTooThin = hideCapIfTooThin;
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
    UIImage *filled = [self filledImage];
    [filled drawInRect:self.bounds];
}

- (UIImage*)filledImage {
    UIGraphicsBeginImageContext(self.bounds.size);
    
    //clear
    [[UIColor clearColor] setFill];
    UIRectFill(self.bounds);
    
    //get image
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
    
    //draw the image
    [self.sliderColor setFill];
    UIRectFillUsingBlendMode(valueFrame, kCGBlendModeSourceIn);

    //draw a cap if needed
    if(self.sliderCapThickness > 0) {
        [self.sliderCapColor setFill];
        
//        //check if fully there*2
        BOOL tooThin = NO;
//        if(self.hideCapIfTooThin) {
//            if(self.sliderDirection % 2 == 0) {
//                if(imageRect.size.height - valueFrame.size.height < self.sliderCapThickness*2) {
//                    tooThin = YES;
//                }
//                else if(valueFrame.size.height  < self.sliderCapThickness*2) {
//                    tooThin = YES;
//                }
//            }
//            else {
//                if(imageRect.size.width - valueFrame.size.width < self.sliderCapThickness*2) {
//                    tooThin = YES;
//                }
//                else if(valueFrame.size.width  < self.sliderCapThickness*2) {
//                    tooThin = YES;
//                }
//            }
//        }

        if(!tooThin) {
            //prepare frame
            if(self.sliderDirection % 2 == 0) {
                if(self.sliderDirection == DDSlidingDirectionBottom) {
                    valueFrame.origin.y -= self.sliderCapThickness;
                }
                else {
                    valueFrame.origin.y += valueFrame.size.height - self.sliderCapThickness;
                }
                valueFrame.size.height = self.sliderCapThickness;
            }
            else {
                if(self.sliderDirection == DDSlidingDirectionRight) {
                    valueFrame.origin.x -= self.sliderCapThickness;
                }
                else {
                    valueFrame.origin.x += valueFrame.size.width - self.sliderCapThickness;
                }
                valueFrame.size.width = self.sliderCapThickness;
            }
            UIRectFillUsingBlendMode(valueFrame, kCGBlendModeSourceIn);
        }
    }

    id img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


@end