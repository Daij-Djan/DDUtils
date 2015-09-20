//
//  UIImage+AssertNamed.m
//  SharedFramework
//
//  Created by Dominik Pich on 18/09/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

#import "UIImage+AssertNamed.h"
#import <objc/runtime.h>

@implementation UIImage (AssertNamed)

+ (void)load {
    [self swizzleClassMethodWithSelector:@selector(imageNamed:) withSelector:@selector(xchg_imageNamed:)];
}

+ (UIImage *)xchg_imageNamed:(NSString *)imageName {
    UIImage *img = [self xchg_imageNamed:imageName];
    NSAssert(img, @"NAMED IMAGE MISSING: %@", imageName);
    return img;
}

#pragma mark -

+ (void)swizzleClassMethodWithSelector:(SEL)originalSelector withSelector:(SEL)overrideSelector {
    Method origMethod = class_getClassMethod(self, originalSelector);
    Method newMethod = class_getClassMethod(self, overrideSelector);
    method_exchangeImplementations(origMethod, newMethod);
}

@end
