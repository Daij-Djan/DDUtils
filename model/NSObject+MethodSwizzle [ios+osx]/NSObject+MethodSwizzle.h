//
//  NSObject+MethodSwizzle.h
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzle)

- (void)swizzleSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

//---

+ (void)swizzleInstanceMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

+ (void*)swizzleInstanceMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f;

@end
