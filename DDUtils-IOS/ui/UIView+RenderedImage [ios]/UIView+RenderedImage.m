//
//  UIView+RenderedImage.m
//  myAudi
//
//  Created by Michael Zapf on 06.12.12.
//  Copyright (c) 2012 Sapient GmbH. All rights reserved.
//

#import "UIView+RenderedImage.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (RenderedImage)

- (UIImage*)renderedImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
