    //
//  RLLoadingScreenViewController.m
//  Project
//
//  Created by Dominik Pich on 02.06.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import "M42LoadingScreenViewController.h"

@implementation M42LoadingScreenViewController

@synthesize label;
@synthesize activityView;
@synthesize progressView;

@synthesize child;

- (void)loadView {
	CGRect f = [[UIScreen mainScreen] bounds];
	UIView *mainView = [[UIView alloc] initWithFrame:f];
	mainView.backgroundColor = [UIColor blackColor];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	//show loading screen
	label = [[UILabel alloc] init];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:18.0f];
	label.backgroundColor = [UIColor blackColor];
//	loadingScreen.text = ;
	label.numberOfLines = 0;
	CGRect f1;
	f1.origin.x = 0;
	f1.origin.y =  0;
	f1.size = f.size;
	f1.size.height /= 2;
	label.frame = f1; 
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[mainView addSubview:label];

	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGRect f2 = activityView.frame;
	f1.origin.x = f1.size.width/2 - f2.size.width/2;
	f1.origin.y =  f1.size.width/2 + 30;
	f1.size = f2.size;
	activityView.frame = f1; 
	[mainView addSubview:activityView];
	[activityView startAnimating];
	activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	CGRect f3 = activityView.frame;
	f3.origin.x -= 20;
	f3.origin.y += 70;
	f3.size.width += 40;
	f3.size.height += 10;
	progressView.frame = f3; 
	progressView.autoresizingMask = activityView.autoresizingMask;
	[mainView addSubview:progressView];

	self.view = mainView;
//	[mainView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end
