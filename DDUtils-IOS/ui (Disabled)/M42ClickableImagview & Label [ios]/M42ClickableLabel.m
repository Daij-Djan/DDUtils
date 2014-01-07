//
//  RLLabel.m
//  Project
//
//  Created by Dominik Pich on 13.05.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import "M42ClickableLabel.h"


@implementation M42ClickableLabel

@synthesize action;
@synthesize target;

- (void)setTarget:(id)t andAction:(SEL)a {
	self.target = t;
	self.action = a;
}

- (void)touchesEnded:(NSSet  *)touches withEvent:(UIEvent  *)event {
	[[UIApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self forEvent:event];
}

@end
