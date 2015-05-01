//
//  UIView+Border.h
//  Created by Dominik Pich
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

- (void)setBorderColor:(UIColor *)color;
- (void)setBorderColor:(UIColor *)color withWidth:(CGFloat)width;
- (UIColor *)borderColor;

@end
