//
//  ViewController.m
//  animatingView
//
//  Created by Dominik Pich on 28/04/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import "ViewController.h"
#import "DDSlidingImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider1;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider1a;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider2;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider2a;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider3;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider3a;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider4;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider4a;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat height = self.slider1.frame.size.height;
        CGFloat howManyPercentMin = 100/height * 8;
        
        self.slider1.sliderValue = MAX(howManyPercentMin/100.0f, 0.1);
        self.slider1a.sliderValue = MAX(howManyPercentMin/100.0f, 0.89);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider2.sliderValue = 0.1;
        self.slider2a.sliderValue = 0.1;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider3.sliderValue = 0.5;
        self.slider3a.sliderValue = 0.5;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider4.sliderValue = 0.99;
        self.slider4a.sliderValue = 0.99;
    });
}

@end
