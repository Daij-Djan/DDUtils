//
//  NSObject+MethodSwizzle.m
//
#import "NSObject+MethodSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzle)

- (void)swizzleSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;
{
    [NSObject swizzleInstanceMethodWithSelector:original_selector withSelector:alternative_selector];
}

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
@end
