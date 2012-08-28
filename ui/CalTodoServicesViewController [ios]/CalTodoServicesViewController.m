//
//  ServicesViewController.m
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CalTodoServicesViewController.h"
#import "BonjourServicesBrowser.h"
#import "Reachability.h"

@implementation CalTodoServicesViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return  browser.services.count;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Configure the cell
	NSNetService *aService = (NSNetService*)[browser.services objectAtIndex:[indexPath row]];
	NSString *name = [aService name];
//	NSString *host = nil;
////	UInt16 port = 0;
//	
//	if([[aService addresses] count] > 0)
//	{
//		CFDataRef address = (CFDataRef)[[aService addresses] objectAtIndex:0];		
//		host = [AsyncSocket addressHost:address];
////		port = [AsyncSocket addressPort:address];
//	}
//		
////	NSMutableString *text = [NSMutableString string];
////	if(name) [text appendString:name];
////	if(host) [text appendFormat:@" on %@", host];
////	if(port) [text appendFormat:@":%d", host];
//	if([cell respondsToSelector:@selector(textLabel)]) 
//		[[(id)cell textLabel] setText:name];
//	else
		cell.textLabel.text = name;
	
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNetService *aService = (NSNetService*)[browser.services objectAtIndex:[indexPath row]];
	[self stopSearch];

	//DONE 
    //>fire a block, call a delegate, whatever :D
    
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

//BUG
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return YES;
//}

- (void)dealloc {
	[browser release];
    [super dealloc];
}

- (void)setBrowser:(BonjourServicesBrowser*)aBrowser {
	if(aBrowser != browser) {
		[browser release];
		browser = [aBrowser retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(servicesChanged:) name: BonjourServicesBrowserDidChangeServices object:browser];
	}
}

- (BonjourServicesBrowser*)browser {
	return [[browser retain] autorelease];
}

- (void)servicesChanged:(NSNotification*)note {
	[tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	BOOL WLAN = ([[Reachability sharedReachability] internetConnectionStatus] == ReachableViaWiFiNetwork || 
	[[Reachability sharedReachability] localWiFiConnectionStatus]);
	if(WLAN) {
		disabledImage.hidden = YES;
		activityLabelView.hidden = NO;
		activityLabelView.text = NSLocalizedString(@"Searching for Services via Bonjour...", @"CalTodoServices");
		activityIndicatorView.hidden = NO;
		[activityIndicatorView startAnimating];
		[browser beginSearch];
		
		[self performSelector:@selector(stopSearch) withObject:nil afterDelay:15];
	}
	else {
		disabledImage.hidden = NO;
		activityLabelView.hidden = NO;
		activityLabelView.text = NSLocalizedString(@"Needs WLAN for Sync", @"CalTodoServices");
		activityIndicatorView.hidden = NO;
		[activityIndicatorView stopAnimating];
	}
}

- (void)stopSearch {
	[browser stopSearch];
	[activityIndicatorView stopAnimating];
	activityIndicatorView.hidden = YES;
	activityLabelView.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	[self stopSearch];
}

- (void)viewDidLoad {
	//localize
	self.navigationItem.title = NSLocalizedString(@"Services", @"titles");
}

@end

