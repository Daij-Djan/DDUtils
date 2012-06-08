//
//  RLLoadingScreenViewController.h
//  Project
//
//  Created by Dominik Pich on 02.06.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M42LoadingScreenViewController : UIViewController

@property(readonly) UILabel *label;
@property(readonly) UIActivityIndicatorView *activityView;
@property(readonly) UIProgressView *progressView;

@property(retain) UIViewController *child;
@end
