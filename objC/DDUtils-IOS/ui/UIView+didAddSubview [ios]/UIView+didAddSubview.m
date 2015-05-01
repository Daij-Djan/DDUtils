//
//  UIView+didAddSubview.m
//  myAudi
//
//  Created by Dominik Pich on 02/07/14.
//  Copyright (c) 2014 Sapient GmbH. All rights reserved.
//

#import "UIView+didAddSubview.h"
#import "NSObject+MethodSwizzle.h"
#import <objc/runtime.h>

static void * const kSNAssociatedStorageKeyDelegate = (void*)&kSNAssociatedStorageKeyDelegate;

@implementation UIView (didAddSubview)

- (void)setAddSubviewDelegate:(id<DDAddSubviewDelegate>)viewDelegate {
    objc_setAssociatedObject(self, kSNAssociatedStorageKeyDelegate, viewDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<DDAddSubviewDelegate>)addSubviewDelegate {
    return objc_getAssociatedObject(self, kSNAssociatedStorageKeyDelegate);
}

#pragma mark - 

+ (void)load {
    SEL originalSelector = @selector(didAddSubview:);
    SEL overrideSelector = @selector(didAddSubview_xchg:);
    [self swizzleInstanceMethodWithSelector:originalSelector withSelector:overrideSelector];
}

- (void)didAddSubview_xchg:(UIView *)subview {
    @try {
        [self didAddSubview_xchg:subview]; //swizzled original
        [self.addSubviewDelegate view:self didAddSubview:subview];
    }
    @catch (NSException *exception) {
    }
}

@end
