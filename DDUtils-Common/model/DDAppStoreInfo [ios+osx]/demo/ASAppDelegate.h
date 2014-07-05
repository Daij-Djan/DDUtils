//
//  ASAppDelegate.h
//  AS
//
//  Created by Dan Grigsby on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASViewController;

@interface ASAppDelegate : NSObject <UIApplicationDelegate>
@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, retain) IBOutlet ASViewController *viewController;
@end

