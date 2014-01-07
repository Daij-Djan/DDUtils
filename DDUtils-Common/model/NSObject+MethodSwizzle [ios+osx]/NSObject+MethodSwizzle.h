//
//  NSObject+MethodSwizzle.h
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzle)

+ (void)swizzleInstanceMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

+ (void *)swizzleInstanceMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f;

//---

+ (void)swizzleClassMethodWithSelector:(SEL)original_selector withSelector:(SEL)alternative_selector;

+ (void *)swizzleClassMethodWithSelector:(SEL)originalSelector ofClass:(Class)trgt withFunction:(IMP)f;

@end

///THE PARAMETER withFunction:(IMP)f can take a block or a c-function
///e.g.     IMP myIMP = imp_implementationWithBlock(^(id _self, NSString *string) {...});