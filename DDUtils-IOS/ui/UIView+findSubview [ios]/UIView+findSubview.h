//
//  NSView+findSubview.h
//
//  Created by Dominik Pich on 8/18/12.
//  Copyright (c) 2012 Dominik Pich. Some rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (findSubview)

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag recursive:(BOOL)recurse;
- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag; // recursive by default

- (NSArray *)subviewsOfKind:(Class)kind recursive:(BOOL)recurse;
- (NSArray *)subviewsOfKind:(Class)kind; // recursive by default

- (UIView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag recursive:(BOOL)recurse;
- (UIView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag; // recursive by default

- (UIView *)firstSubviewOfKind:(Class)kind recursive:(BOOL)recurse;
- (UIView *)firstSubviewOfKind:(Class)kind; // recursive by default

@end
