//
//  M42ClickableImageView.m
//  Mediscript
//
//  Created by Dominik Pich on 11/23/10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import "M42ClickableImageView.h"


@implementation M42ClickableImageView

@synthesize action;
@synthesize target;

- (void)setTarget:(id)t andAction:(SEL)a {
	self.target = t;
	self.action = a;
}

- (void)touchesEnded:(NSSet  *)touches withEvent:(UIEvent  *)event {
	[[UIApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self
                                         forEvent:event];
}

@end
