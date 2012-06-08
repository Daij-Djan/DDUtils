//
//  MedikamenteWebview.m
//  Medikamente
//
//  Created by Dominik Pich on 1/28/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "M42PinchableWebView.h"

@implementation M42PinchableWebView

- (void)magnifyWithEvent:(NSEvent *)event {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old+[event magnification]*0.8];
}

-(IBAction)zoomIn:(id)sender {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old+0.4];
}

-(IBAction)zoomOut:(id)sender {
	CGFloat old = [self textSizeMultiplier];
	[self setTextSizeMultiplier:old-0.4];
}

@end
