//
//  RandomIndexPermutation.h
//  mediscript
//
//  Created by Dominik Pich on 17.08.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M42RandomIndexPermutation : NSObject {
	NSInteger *indices;
	NSUInteger count;
	NSInteger index;
}

- (id)initWithCount:(NSUInteger)cnt usingSeed:(NSTimeInterval)seed;
- (void)remixUsingSeed:(NSTimeInterval)seed;
- (NSInteger *)indices;
- (NSInteger)next;
- (NSUInteger)count;
- (BOOL)isValid;

@end