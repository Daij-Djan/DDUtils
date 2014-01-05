//
//  NSView+findSubview.h
//  DDSigner
//
//  Created by Dominik Pich on 8/18/12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (findSubview)

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag;
- (NSArray *)subviewsOfKind:(Class)kind;

- (NSView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag;
- (NSView *)firstSubviewOfKind:(Class)kind;

@end
