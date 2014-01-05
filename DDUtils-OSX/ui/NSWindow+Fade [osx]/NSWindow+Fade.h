//
//  NSWindow+Fade.h
//  GoDark
//
//  Created by Dominik Pich on 09.12.12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Fade)

- (void)fadeInWithDuration:(NSNumber*)d;
- (IBAction)fadeIn:(id)sender;

- (void)fadeOutWithDuration:(NSNumber*)d;
- (IBAction)fadeOut:(id)sender;

@end