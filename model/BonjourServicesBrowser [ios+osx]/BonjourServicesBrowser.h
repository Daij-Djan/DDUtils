//
//  BonjourServicesBrowser.h
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

extern NSString *BonjourServicesBrowserDidChangeServices;

@interface BonjourServicesBrowser : NSObject<NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
	NSString *type;
	NSMutableArray *services;
	NSNetServiceBrowser *browser;	
	
	NSNetService *stopAfterResoleOf;
}
+ (id)defaultBrowser;

- (void)beginSearchForType:(NSString*)aName;
- (void)beginSearch;
- (void)stopSearch;

@property(copy) NSString *type;
@property(readonly) NSMutableArray *services;
@end
