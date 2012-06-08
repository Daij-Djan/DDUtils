//
//  MSTableViewCell.m
//  Project
//
//  Created by Dominik Pich on 6/17/09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "M42WebviewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation M42WebviewTableViewCell

- (CGRect)frameForEmptyWebviewAssumingBounds:(CGRect)f {
	f.size.height = 5;
	return f;
}

- (CGRect)frameForEmptyWebview {
	CGRect f = self.contentView.bounds;
	return [self frameForEmptyWebviewAssumingBounds:f];
}

@synthesize delegate;

- (void)setHtml:(NSString *)newHtml {
	[self setHtml:newHtml AndBaseURL:nil];
}
- (void)setHtml:(NSString *)newHtml AndBaseURL:(NSURL*)newBaseURL {
	webView.frame = [self frameForEmptyWebview];
	[webView stopLoading];
	[webView loadHTMLString:newHtml baseURL:newBaseURL];
	[html release];
	html = [newHtml copy];
	[baseURL release];
	baseURL = [newBaseURL copy];
	ready = NO;
}

@synthesize webView;
@synthesize tag;
@synthesize html;
@synthesize baseURL;

@synthesize ready;

- (CGFloat)height {
	return !ready ? 5 : [webView sizeThatFits:CGSizeZero].height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		while(self.contentView.subviews.count) {
			[[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
		}
		webView = [[UIWebView alloc] initWithFrame:[self frameForEmptyWebview]];
		webView.delegate = self;
		webView.userInteractionEnabled = NO;
		webView.autoresizingMask = 0;
		webView.backgroundColor = [UIColor clearColor];
		webView.opaque = NO;
		
		[self.contentView addSubview:webView];
	}
	
	return self;
}

- (void)dealloc {
	[webView release];
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect f = self.contentView.bounds;
	if(!ready)
		f.size.height = 5;
	
	webView.frame = f;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	if([error code] != 102 && [error code] != -999)
		PGLog(ERROR, @"webView failed to load %@. Error message: %@", aWebView.request.URL, error);
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
#ifdef DEBUG
	neededHeight = [aWebView sizeThatFits:CGSizeZero].height;
	if([self isMemberOfClass:[M42WebviewTableViewCell class]]) {
	   NSLog(@"%@ did finish1,  still going %d",aWebView.request.URL, aWebView.loading);
	   NSLog(@"1; %f", neededHeight);
//		NSString *js = [aWebView stringByEvaluatingJavaScriptFromString:@"document.get"];

		if(webView != aWebView) {
			NSLog(@"Doh!");
		}
	}
#endif
	[self performSelector:@selector(loadedData) withObject:nil afterDelay:0.5];
}
						
- (void)loadedData {
#ifdef DEBUG
	neededHeight = [webView sizeThatFits:CGSizeZero].height;
	if([self isMemberOfClass:[M42WebviewTableViewCell class]]) {
		NSLog(@"%@ did finish3,  still going %d",webView.request.URL, webView.loading);
		NSLog(@"3: %f", neededHeight);
	}
#endif
	ready = YES;
	[delegate tableCellDidLoadContent:self];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	//NSLog(@"also load %@", request.URL);
	return !delegate ? YES : [delegate tableCell:self shouldStartLoadWithRequest:request navigationType:navigationType];
}
@end