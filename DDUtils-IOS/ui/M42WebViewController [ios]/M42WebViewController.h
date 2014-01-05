//
//  M42WebViewController.h
//  Roche
//
//  Created by Dominik Pich on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M42WebViewController : UIViewController<UIWebViewDelegate> {
@protected
	NSString *htmlString;
	NSURL *htmlBaseURL;
	UIWebView *webView;
	NSURLRequest *request;
	UIBarButtonItem *backButton;
	UILabel *statusLabel;
}
@property(readonly) UIWebView *webView;

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadRequest:(NSURLRequest*)aRequest;
- (void)invalidate;
@end
