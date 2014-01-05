//
//  DDBonjourServicesBrowser.m
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DDBonjourServicesBrowser.h"

NSString *DDBonjourServicesBrowserDidChangeServices = @"DDBonjourServicesBrowserDidChangeServices";

static DDBonjourServicesBrowser *defaultBrowser;

@implementation DDBonjourServicesBrowser

@synthesize type;
@synthesize services;

+ (id)defaultBrowser {
	if(!defaultBrowser) {
		defaultBrowser = [[[self class] alloc] init];
	}
	return defaultBrowser;
}

-(void)dealloc {
	[self stopSearch];
}

- (void)beginSearchForType:(NSString*)aName {
	[self stopSearch];
	browser = [[NSNetServiceBrowser alloc] init];
	browser.delegate = self;

	services = [[NSMutableArray alloc] init];
	[[NSNotificationCenter defaultCenter] postNotificationName:DDBonjourServicesBrowserDidChangeServices object:self];
	
	[browser searchForServicesOfType:aName inDomain:@""];
}

- (void)beginSearch {
	[self beginSearchForType:self.type];
}

- (void)stopSearch {
	[browser stop];
	browser = nil;
}
#pragma mark Net Service Browser Delegate Methods

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
	//you can resolve in delegate
	if(!more) {
		stopAfterResoleOf = aService;
	}
	[self performSelector:@selector(resolveService:) withObject:aService afterDelay:0.5];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
	[services removeObject:aNetService];
	[[NSNotificationCenter defaultCenter] postNotificationName:DDBonjourServicesBrowserDidChangeServices object:self];
}

#pragma mark Net Service Delegate Methods

- (void)resolveService:(NSNetService *)aService {
	[aService setDelegate:self];
	[aService resolveWithTimeout:120];
}

-(void)netServiceDidResolveAddress:(NSNetService *)aService {
	[services addObject:aService];
	[[NSNotificationCenter defaultCenter] postNotificationName:DDBonjourServicesBrowserDidChangeServices object:self];
	if(stopAfterResoleOf == aService) {
		stopAfterResoleOf = nil;
		[self stopSearch];
	}
}

-(void)netService:(NSNetService *)aService didNotResolve:(NSDictionary *)errorDict {
	if(stopAfterResoleOf == aService) {
		stopAfterResoleOf = nil;
		[self stopSearch];
	}
}

@end
