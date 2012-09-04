//
//  DDBonjourServicesBrowser.h
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#ifdef OSX
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

/** @file DDBonjourServicesBrowser.h */

/**
 * name of notification sent by the browser when it finds new services / discards some
 */
extern NSString *DDBonjourServicesBrowserDidChangeServices;

/**
 * Class that can monitor the network and search/listen for bonjour services of a specific type
 */
@interface DDBonjourServicesBrowser : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
	NSString *type;
	NSMutableArray *services;
	NSNetServiceBrowser *browser;	
	
	NSNetService *stopAfterResoleOf;
}
/**
 * the shared browser instance to use. Normally only one instance is needed because only one service type is interesting.
 * @return the share browser
 */
+ (id)defaultBrowser;

/**
 * starts the monitor for a certain type. stopping any the old search, discarding old array
 * @param type the type of the services to search for
 */
- (void)beginSearchForType:(NSString*)aName;

/**
 * starts the monitor for a certain type. stopping any the old search, discarding old array
 * @warning The Type is taken from the type property of the class.
 */
- (void)beginSearch;

/**
 * stops any search that's currently in progress BUT does not release the services array.
 */
- (void)stopSearch;

/**
 * the type of service this listener is interested in.
 * @warning setting it while browser is started has no effect.
 */
@property(copy) NSString *type;

/**
 * Instances of NSNetService for every service that gets found.
 */
@property(readonly) NSMutableArray *services;
@end
