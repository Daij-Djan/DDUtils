//
//  BonjourServicesBrowser.m
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BonjourServicesBrowser.h"

NSString *BonjourServicesBrowserDidChangeServices = @"BonjourServicesBrowserDidChangeServices";

static BonjourServicesBrowser *defaultBrowser;

@implementation BonjourServicesBrowser

@synthesize type;
@synthesize services;

+ (id)defaultBrowser {
	if(!defaultBrowser) {
		defaultBrowser = [[[self class] alloc] init];
	}
	return defaultBrowser;
}

-(void)dealloc {
	[type release];
	[services release];
	[browser release];
	[super dealloc];
}

- (void)beginSearchForType:(NSString*)aName {
	[browser release];	
	browser = [[NSNetServiceBrowser alloc] init];
	browser.delegate = self;

	[services release];
	services = [[NSMutableArray alloc] init];
	[[NSNotificationCenter defaultCenter] postNotificationName:BonjourServicesBrowserDidChangeServices object:self];
	
	[browser searchForServicesOfType:aName inDomain:@""];
}

- (void)beginSearch {
	[self beginSearchForType:self.type];
}

- (void)stopSearch {
	[browser stop];
	[browser release];	
	browser = nil;
}
#pragma mark Net Service Browser Delegate Methods

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
	//you can resolve in delegate
	if(!more) {
		stopAfterResoleOf = aService;
	}
	[self performSelector:@selector(resolveService:) withObject:[aService retain] afterDelay:0.5];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
	[services removeObject:aNetService];
	[[NSNotificationCenter defaultCenter] postNotificationName:BonjourServicesBrowserDidChangeServices object:self];
}

#pragma mark Net Service Delegate Methods

- (void)resolveService:(NSNetService *)aService {
	[aService setDelegate:self];
	[aService resolveWithTimeout:120];
}

-(void)netServiceDidResolveAddress:(NSNetService *)aService {
	[services addObject:aService];
	[[NSNotificationCenter defaultCenter] postNotificationName:BonjourServicesBrowserDidChangeServices object:self];
	if(stopAfterResoleOf == aService) {
		stopAfterResoleOf = nil;
		[self stopSearch];
	}
//	[aService autorelease]; //retained when found
}

-(void)netService:(NSNetService *)aService didNotResolve:(NSDictionary *)errorDict {
//	NSLog(@"Error resolving %@ due to %@ 
	if(stopAfterResoleOf == aService) {
		stopAfterResoleOf = nil;
		[self stopSearch];
	}
//	[aService autorelease]; //retained when found
}

@end
