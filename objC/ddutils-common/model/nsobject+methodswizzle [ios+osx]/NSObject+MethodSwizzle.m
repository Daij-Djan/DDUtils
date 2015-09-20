/**
@file      NSObject+MethodSwizzle.m
@author    Sapient GmbH
@date      2013-05-01
@copyright AUDI AG, 2014. All Rights Reserved
*/
#import "NSObject+MethodSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzle)

+ (void)swizzleInstanceMethodWithSelector:(SEL)originalSelector withSelector:(SEL)overrideSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

+ (void*)swizzleInstanceMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f {
    Method origMethod = class_getInstanceMethod(trgt, originalSelector);
    void *origImp = (void *)method_getImplementation(origMethod);
    
    if(!class_addMethod(trgt, originalSelector, f, method_getTypeEncoding(origMethod)))
        method_setImplementation(origMethod, f);
    
    return origImp;
}

+ (void)swizzleClassMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector; {
    Method origMethod = class_getClassMethod(self, original_selector);
    Method newMethod = class_getClassMethod(self, alternative_selector);
    method_exchangeImplementations(origMethod, newMethod);
}
@end
