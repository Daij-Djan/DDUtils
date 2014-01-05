//
//  NSObject+MethodSwizzle.m
//
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

//---

+ (void)swizzleClassMethodWithSelector:(SEL)original_selector withSelector:(SEL)override_selector {
    const char *name = class_getName(self.class);
    Class meta = objc_getMetaClass(name);
    
    Method originalMethod = class_getClassMethod(self, original_selector);
    Method overrideMethod = class_getClassMethod(self, override_selector);
    if (class_addMethod(meta, original_selector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(meta, override_selector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

+ (void*)swizzleClassMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f {
    const char *name = class_getName(trgt);
    Class meta = objc_getMetaClass(name);

    Method origMethod = class_getClassMethod(trgt, originalSelector);
    void *origImp = (void *)method_getImplementation(origMethod);
    
    if(!class_addMethod(meta, originalSelector, f, method_getTypeEncoding(origMethod)))
        method_setImplementation(origMethod, f);
    
    return origImp;
}


@end
