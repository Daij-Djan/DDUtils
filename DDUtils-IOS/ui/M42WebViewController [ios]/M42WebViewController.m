//
//  M42WebViewController.m
//  Roche
//
//  Created by Dominik Pich on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "M42WebViewController.h"


@implementation M42WebViewController

@synthesize webView;

//diss nibs ;)
- (void)viewDidUnload {
	webView.delegate = nil;
	webView = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 	
}

- (void)loadView {
	CGRect f = [[UIScreen mainScreen] applicationFrame];
	
	UIView *mainView = [[UIView alloc] initWithFrame:f];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;	

	webView = [[UIWebView alloc] initWithFrame:mainView.bounds];
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;	
	webView.delegate = self;
	webView.scalesPageToFit = YES;	
	[mainView addSubview:webView];
	
	self.view = mainView;
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
	request = nil;
	
	if([self isViewLoaded]) {
		[webView loadHTMLString:string baseURL:baseURL];
		string = nil;
		baseURL = nil;
	}
	htmlString = string;
	htmlBaseURL = baseURL;
}

- (void)loadRequest:(NSURLRequest*)aRequest {
	htmlString = nil;
	htmlBaseURL = nil;

	if([self isViewLoaded]) {		
		[webView loadRequest:aRequest];
		aRequest = nil;
	}
	request = aRequest;
}

- (UIBarButtonItem*)newBackButton {
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:webView action:@selector(goBack)];
}

- (void)dealloc {
	webView.delegate = nil;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	if(request) {
		[self loadRequest:request];
	}
	else if(htmlString) {
		[self loadHTMLString:htmlString baseURL:htmlBaseURL];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)invalidate {
	[webView removeFromSuperview];
	
	webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;	
	webView.delegate = self;
	webView.scalesPageToFit = YES;	
	[self.view addSubview:webView];	
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType {
	NSURL *url = [aRequest URL];
	if(![url isFileURL]) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	}

	if(!statusLabel) {
		statusLabel = [[UILabel alloc] initWithFrame:webView.bounds];
		statusLabel.opaque = NO;
		statusLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
		statusLabel.textAlignment = UITextAlignmentCenter;
		statusLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
		statusLabel.text = @"Lade...";
		[webView addSubview:statusLabel];
	}
	
	NSLog( @"INFO: Load request: %@", url);
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	NSLog( @"INFO: Did load: %@", [webView.request URL]);
	[statusLabel removeFromSuperview];
	statusLabel = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 

	if([webView canGoBack]) {
		if(!backButton) {
			backButton = [self newBackButton];
		}
		self.navigationItem.hidesBackButton = YES;
		[self.navigationItem setLeftBarButtonItem:backButton animated:YES];
	}
	else {
		[self.navigationItem setLeftBarButtonItem:nil animated:YES];
		self.navigationItem.hidesBackButton = NO;
	}

}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	NSLog(@"ERROR: Failed to load requested page: %@", [error description]);
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Seite nicht vorhanden" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	
	[self webViewDidFinishLoad:aWebView];
}
@end
