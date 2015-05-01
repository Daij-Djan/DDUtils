//
//  DDAnimatingView.h
//  animatingView
//
//  Created by Dominik Pich on 28/04/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDSlidingDirection) {
    DDSlidingDirectionTop = 2,
    DDSlidingDirectionBottom = 4,
    DDSlidingDirectionLeft = 1,
    DDSlidingDirectionRight = 3
};

IB_DESIGNABLE
@interface DDSlidingImageView : UIView

@property(strong, nonatomic) IBInspectable UIImage *image; //honours contentMode

@property(strong, nonatomic) IBInspectable UIColor *sliderColor;
@property(assign, nonatomic) IBInspectable CGFloat sliderValue; //0 - 1
@property(assign, nonatomic) IBInspectable CGFloat sliderDuration; //s
@property(assign, nonatomic) IBInspectable NSUInteger sliderDirection; //for IB, I cant use an enum
@end
