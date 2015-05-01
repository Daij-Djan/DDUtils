    //
//  M42TabBarController.m
//  Project
//
//  Created by Dominik Pich on 11.06.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import "M42TabBarController.h"

#define TABBAR_HEIGHT 48

@implementation M42TabBarController {
    UILabel *overlay;
}

@synthesize disable;

- (void)__setupOverlay {
	if (disable) {
		if (!overlay) {
			overlay = [[UILabel alloc] init];
			overlay.opaque = NO;
			overlay.alpha = 0.5;
			overlay.backgroundColor = [UIColor blackColor];
		}
	
		CGRect f = self.view.bounds;
        f.origin.y += (f.size.height - TABBAR_HEIGHT);
        f.size.height = TABBAR_HEIGHT;

		overlay.frame = f;
		overlay.userInteractionEnabled = YES;
		[self.view addSubview:overlay];
	} else {

		if (overlay) {
			[overlay removeFromSuperview];
//			[overlay release];
			overlay = nil;
		}
	}
}

- (BOOL)disable {
	return disable;
}
- (void)setDisable:(BOOL)flag {
	disable = flag;
	[self __setupOverlay];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self __setupOverlay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	overlay = nil;
}

//#define Fixed
#ifdef DEBUG
#ifdef Fixed
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
#endif
#endif

//- (void)dealloc {
//	[overlay release];
//    [super dealloc];
//}


@end
