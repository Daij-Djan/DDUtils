//
//  NSWindow+Fade.m
//  GoDark
//
//  Created by Dominik Pich on 09.12.12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import "NSWindow+Fade.h"

#define kWindowAnimationDuration 0.1f

@implementation NSWindow (Fade)

- (void)fadeInWithDuration:(NSNumber*)d
{
    [self setAlphaValue:0.f];
    [self makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:d.floatValue];
    [[self animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (IBAction)fadeIn:(id)sender
{
    [self fadeInWithDuration:@(kWindowAnimationDuration)];
}

- (void)fadeOutWithDuration:(NSNumber*)d
{
    [NSAnimationContext beginGrouping];
    __block NSWindow *bself = self;
    [[NSAnimationContext currentContext] setDuration:d.floatValue];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [bself orderOut:nil];
        [bself setAlphaValue:1.f];
    }];
    [[self animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

- (IBAction)fadeOut:(id)sender
{
    [self fadeOutWithDuration:@(kWindowAnimationDuration)];
}

@end