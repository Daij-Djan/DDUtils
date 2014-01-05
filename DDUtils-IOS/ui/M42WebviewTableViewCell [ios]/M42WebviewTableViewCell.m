//
//  MSTableViewCell.m
//  Project
//
//  Created by Dominik Pich on 6/17/09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//
//  modernized 12/2013
//

#import "M42WebviewTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface M42WebviewTableViewCell ()
@property(nonatomic, copy) NSURL *htmlURL;
@property(nonatomic, copy) NSString *html;
@property(nonatomic, copy) NSURL *baseURL;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, assign) BOOL ready;
@end

@implementation M42WebviewTableViewCell

- (void)setHtmlFromURL:(NSURL *)newHtmlURL {
    if(self.webView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.webView stopLoading];
    }
    else {
        [self prepare];
    }
    
    self.htmlURL = newHtmlURL;
	self.html = nil;
	self.baseURL = nil;
	self.ready = NO;
    
	self.webView.frame = [self frameForEmptyWebview];
	[self.webView loadRequest:[NSURLRequest requestWithURL:newHtmlURL]];
}

- (void)setHtml:(NSString *)newHtml AndBaseURL:(NSURL*)newBaseURL {
    if(self.webView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self.webView stopLoading];
    }
    else {
        [self prepare];
    }

    self.htmlURL = nil;
	self.html = newHtml;
	self.baseURL = newBaseURL;
	self.ready = NO;

	self.webView.frame = [self frameForEmptyWebview];
	[self.webView loadHTMLString:newHtml baseURL:newBaseURL];
}

- (CGFloat)height {
	return !self.ready ? 5 : [self.webView sizeThatFits:CGSizeZero].height;
}

- (void)layoutSubviews {
	[super layoutSubviews];

    for (UIView *v in self.contentView.subviews) {
        v.alpha = (v==_webView);
    }
	CGRect f = self.contentView.bounds;
	if(!self.ready) {
		f.size.height = 5;
    }
	
	self.webView.frame = f;
}

- (void)didLoadData {
	_ready = YES;
	[self.delegate tableCellDidLoadContent:self];
}


#pragma mark - lifecycle 

- (void)prepare {
    while(self.contentView.subviews.count) {
        [[self.contentView.subviews objectAtIndex:0] removeFromSuperview];
    }
    self.webView = [[UIWebView alloc] initWithFrame:[self frameForEmptyWebview]];
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    self.webView.autoresizingMask = 0;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    
    [self.contentView addSubview:self.webView];
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
#if !__has_feature(objc_arc)
	self.webView = nil;
    self.htmlURL = nil;
    self.html = nil;
    self.baseURL = nil;
    self.delegate = nil;
	[super dealloc];
#endif
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	if([error code] != 102 && [error code] != -999) {
		NSLog(@"webView failed to load %@. Error message: %@", aWebView.request.URL, error);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[self performSelector:@selector(didLoadData) withObject:nil afterDelay:0.0];
}
						
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if([self.delegate respondsToSelector:@selector(tableCell:shouldStartLoadWithRequest:navigationType:)]) {
       return [self.delegate tableCell:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

#pragma mark - default empty frame

- (CGRect)frameForEmptyWebview {
	CGRect f = self.contentView.bounds;
	return [self.class frameForEmptyWebviewAssumingBounds:f];
}

+ (CGRect)frameForEmptyWebviewAssumingBounds:(CGRect)f {
	f.size.height = 5;
	return f;
}

@end