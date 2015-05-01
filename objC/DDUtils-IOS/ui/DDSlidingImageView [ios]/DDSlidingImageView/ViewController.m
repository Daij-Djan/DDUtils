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
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider2;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider3;
@property (weak, nonatomic) IBOutlet DDSlidingImageView *slider4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider1.sliderValue = 0.7;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider2.sliderValue = 0.4;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider3.sliderValue = 1;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.slider4.sliderValue = 0.6;
    });
}

@end
