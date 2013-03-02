//
//  DDAppDelegate.h
//  DDEmbeddDataReaderIOS
//
//  Created by Dominik Pich on 02.03.13.
//  Copyright (c) 2013 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDViewController;

@interface DDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DDViewController *viewController;

@end
