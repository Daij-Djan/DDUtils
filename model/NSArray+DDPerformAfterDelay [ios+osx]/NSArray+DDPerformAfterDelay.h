//
//  NSArray+DDPerformAfterDelay.h
//  GoDark
//
//  Created by Dominik Pich on 24.12.12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DDPerformAfterDelay)

- (void)makeObjectsPerformSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument afterDelay:(NSTimeInterval)delay;

@end
