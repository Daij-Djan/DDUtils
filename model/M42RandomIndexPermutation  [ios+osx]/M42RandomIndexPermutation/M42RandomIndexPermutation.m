//
//  M42RandomIndexPermutation.m
//  mediscript
//
//  Created by Dominik Pich on 17.08.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import "M42RandomIndexPermutation.h"

@implementation M42RandomIndexPermutation

- (id)initWithCount:(NSUInteger)cnt usingSeed:(NSTimeInterval)seed {
	self = [super init];
	if (self) {
		indices = malloc(cnt * sizeof(NSInteger));
		count = cnt;
		[self remixUsingSeed:seed];
	} 
	return self;
}

- (void)remixUsingSeed:(NSTimeInterval)seed {
    for (index = 0; index < count; index++) indices[index] = index;

	srand(seed);
	for (index = 0; index < count; index++) {
		NSInteger swap = indices[index];
		NSInteger destinationIndex = rand() % (count - index) + index;
		indices[index] = indices[destinationIndex];
		indices[destinationIndex] = swap;
	} 
	index = 0;
}

- (NSUInteger)count {return count;}

- (NSInteger *)indices {return indices;}

- (NSInteger)next {
	if (index < count) return indices[index++];
	return NSNotFound;
}

- (BOOL)isValid {
	NSInteger i;
	NSMutableSet *set = [NSMutableSet set];
	for (i = 0; i < count; i++) [set addObject:[NSNumber numberWithInteger:indices[i]]];
	return ([set count] == count) ? YES : NO;
}

- (void)dealloc {
	free(indices);
	//[super dealloc];
}

- (NSString *)description {
    NSMutableString *buf = [NSMutableString stringWithFormat:@"permutation (%lu) :: ", count];
    
    for(int i=0;i<count;i++) {
        if(i==0)
            [buf appendFormat:@"%ld", indices[i]];
        else
            [buf appendFormat:@", %ld", indices[i]];
    }
    
    return buf;
}

- (BOOL)isEqual:(id)object {
    return [self isEqualTo:object];
}

- (BOOL)isEqualTo:(id)object {
    if(![object isKindOfClass:[self class]])
        return NO;
    
    M42RandomIndexPermutation *perm = object;
    if(count != perm.count)
        return NO;
    
    for(int i=0;i<count;i++) {
        if(indices[i] != perm.indices[i])
            return NO;
    }

    return YES;
}

@end