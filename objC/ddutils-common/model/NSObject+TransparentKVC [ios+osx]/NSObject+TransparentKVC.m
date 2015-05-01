//
//  NSObject+TransparentKVC.m
//  test
//
//  Created by Dominik Pich on 09/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "NSObject+TransparentKVC.h"
#import <objc/runtime.h>

@implementation NSObject (TransparentKVC)

// Determine if we can handle the unknown selector sel
- (NSMethodSignature  *)methodSignatureForSelector_xchg:(SEL)sel {
 	NSMethodSignature *signature = [self methodSignatureForSelector_xchg:sel];

	if (!signature) {
		id	stringSelector = NSStringFromSelector(sel);
		NSUInteger parameterCount =  [[stringSelector componentsSeparatedByString:@":"] count]-1;
	
		// Zero argument, forward to valueForKey:
		if (parameterCount == 0) {
			signature = [self methodSignatureForSelector_xchg:@selector(valueForKey:)];
            // One argument starting with set, forward to setValue:forKey:
		} else if (parameterCount == 1 && [stringSelector hasPrefix:@"set"])  {
			signature = [self methodSignatureForSelector_xchg:@selector(setValue:forKey:)];
		}
	}
	return signature;
}

//forward unknown calls
- (void)forwardInvocation_xchg:(NSInvocation  *)invocation {
    id	stringSelector = NSStringFromSelector(invocation.selector);
    NSUInteger parameterCount =  [[stringSelector componentsSeparatedByString:@":"] count]-1;
    
    //get KVC
	if (parameterCount == 0) {
		__unsafe_unretained id value = [self valueForKey:NSStringFromSelector([invocation selector])];
		[invocation setReturnValue:&value];
	
	}
    //set KVC
    else if (parameterCount == 1) {
		// The first parameter to an ObjC method is the third argument
		// ObjC methods are C functions taking instance and selector as their first two arguments
		__unsafe_unretained id value;
		[invocation getArgument:&value atIndex:2];
	
		// Get key name by converting setMyValue: to myValue
		id key = [NSString stringWithFormat:@"%@%@",
				  [[stringSelector substringWithRange:NSMakeRange(3, 1)] lowercaseString],
				  [stringSelector substringWithRange:NSMakeRange(4, [stringSelector length]-5)]];
		// Set
		[self setValue:value forKey:key];
	}
    else {
        [self forwardInvocation_xchg:invocation];
    }
}

//swizzle
+ (void)load {
    //methodSignatureForSelector
    SEL originalSelector = @selector(methodSignatureForSelector:);
    SEL overrideSelector = @selector(methodSignatureForSelector_xchg:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
    //forwardInvocation
    originalSelector = @selector(forwardInvocation:);
    overrideSelector = @selector(forwardInvocation_xchg:);
    originalMethod = class_getInstanceMethod(self, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

@end
