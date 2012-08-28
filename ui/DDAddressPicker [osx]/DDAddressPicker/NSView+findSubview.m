//
//  NSView+findSubview.m
//  DDSigner
//
//  Created by Dominik Pich on 8/18/12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import "NSView+findSubview.h"

@implementation NSView (findSubview)

- (NSArray *)findSubviewsOfKind:(Class)kind withTag:(NSInteger)tag inView:(NSView*)v {
    NSMutableArray *array = [NSMutableArray array];

    if(kind==nil || [v isKindOfClass:kind]) {
        if(tag==NSNotFound || v.tag==tag) {
            [array addObject:v];
        }
    }
    
    for (id subview in v.subviews) {
        NSArray *vChild = [self findSubviewsOfKind:kind withTag:tag inView:subview];
        [array addObjectsFromArray:vChild];
    }
    
    return array;
}

#pragma mark - 

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag {
    return [self findSubviewsOfKind:kind withTag:tag inView:self];
}

- (NSArray *)subviewsOfKind:(Class)kind {
    return [self findSubviewsOfKind:kind withTag:NSNotFound inView:self];
}

- (NSView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag {
    return [[self findSubviewsOfKind:kind withTag:tag inView:self] objectAtIndex:0];
}

- (NSView *)firstSubviewOfKind:(Class)kind {
    return [self firstSubviewOfKind:kind withTag:NSNotFound];
}

@end
