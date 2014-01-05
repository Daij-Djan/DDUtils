//
//  NSView+findSubview.m
//
//  Created by Dominik Pich on 8/18/12.
//  Copyright (c) 2012 Dominik Pich. Some rights reserved.
//

#import "UIView+findSubview.h"

@implementation UIView (findSubview)

- (NSArray *)findSubviewsOfKind:(Class)kind withTag:(NSInteger)tag inView:(UIView*)v level:(NSUInteger)level recursive:(BOOL)recurse {
    NSMutableArray *array = [NSMutableArray array];

    if(kind==nil || [v isKindOfClass:kind]) {
        if(tag==NSNotFound || v.tag==tag) {
            [array addObject:v];
        }
    }
    if(level==1 || recurse) {
        for (id subview in v.subviews) {
            NSArray *vChild = [self findSubviewsOfKind:kind withTag:tag inView:subview level:++level recursive:recurse];
            [array addObjectsFromArray:vChild];
        }
    }
    
    return array;
}

#pragma mark - 

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag recursive:(BOOL)recurse {
    return [self findSubviewsOfKind:kind withTag:tag inView:self level:1 recursive:recurse];
}

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag {
    return [self subviewsOfKind:kind withTag:tag recursive:YES];
}

- (NSArray *)subviewsOfKind:(Class)kind recursive:(BOOL)recurse {
    return [self subviewsOfKind:kind withTag:NSNotFound recursive:recurse];
}

- (NSArray *)subviewsOfKind:(Class)kind {
    return [self subviewsOfKind:kind withTag:NSNotFound recursive:YES];
}

#pragma mark -

- (UIView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag recursive:(BOOL)recurse {
    NSArray *subviews = [self findSubviewsOfKind:kind withTag:tag inView:self level:1 recursive:recurse];
    return subviews.count ? subviews[0] : nil;
}

- (UIView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag {
    return [self firstSubviewOfKind:kind withTag:tag recursive:YES];
}

- (UIView *)firstSubviewOfKind:(Class)kind recursive:(BOOL)recurse {
    return [self firstSubviewOfKind:kind withTag:NSNotFound recursive:recurse];
}

- (UIView *)firstSubviewOfKind:(Class)kind {
    return [self firstSubviewOfKind:kind withTag:NSNotFound recursive:YES];
}

@end
