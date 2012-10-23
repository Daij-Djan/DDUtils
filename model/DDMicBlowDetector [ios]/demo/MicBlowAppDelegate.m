//
//  MicBlowAppDelegate.m
//  MicBlow
//
//  Created by Dan Grigsby on 8/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MicBlowAppDelegate.h"
#import "MicBlowViewController.h"

@implementation MicBlowAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    id window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window = window;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

#if __has_feature(objc_arc)
#else
    [window release];
#endif
}

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [_viewController release];
    [_window release];
    [super dealloc];
}
#endif

@end
