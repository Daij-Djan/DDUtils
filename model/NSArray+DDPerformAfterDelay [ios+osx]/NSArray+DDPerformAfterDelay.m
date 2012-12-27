//
//  NSArray+DDPerformAfterDelay.m
//  GoDark
//
//  Created by Dominik Pich on 24.12.12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "NSArray+DDPerformAfterDelay.h"

@implementation NSArray (DDPerformAfterDelay)

- (void)_delayedCall:(NSString*)method {
    [self makeObjectsPerformSelector:NSSelectorFromString(method)];
}

- (void)_delayedCallWithParam:(NSDictionary*)call {
    [self makeObjectsPerformSelector:NSSelectorFromString(call[@"SEL"]) withObject:call[@"PARAM"]];
}

//---

- (void)makeObjectsPerformSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(_delayedCall:) withObject:NSStringFromSelector(aSelector) afterDelay:delay];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(_delayedCallWithParam:) withObject:@{@"SEL":NSStringFromSelector(aSelector),@"PARAM":argument} afterDelay:delay];
}

@end
