/**
@file      NSObject+MethodSwizzle.h
@author    Sapient GmbH
@date      2013-05-31
@copyright AUDI AG, 2014. All Rights Reserved
*/
#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzle)

+ (void)swizzleInstanceMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

+ (void*)swizzleInstanceMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f;

//---

+ (void)swizzleClassMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

@end
