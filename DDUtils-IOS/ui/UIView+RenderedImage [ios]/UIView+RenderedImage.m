//
//  UIView+RenderedImage.m
//
//  Created by Dominik Pich on 09.03.13.
//
#import "UIView+RenderedImage.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (RenderedImage)

- (UIImage *)renderedImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
