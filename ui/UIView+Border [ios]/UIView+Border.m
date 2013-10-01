//
//  UIView+Border.m
//  Created by Dominik Pich
//

#import "UIView+Border.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Border)

- (void)setBorderColor:(UIColor*)color {
    [self setBorderColor:color withWidth:1.0f];
}

- (void)setBorderColor:(UIColor*)color withWidth:(CGFloat)width {
    if (color) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = width;
    }
    else {
        self.layer.borderColor = NULL;
    }
}

- (UIColor*)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
