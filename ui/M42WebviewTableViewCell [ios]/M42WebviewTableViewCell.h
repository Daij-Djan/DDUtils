//
//  MSTableViewCell.h
//  mediscript
//
//  Created by Dominik Pich on 09.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M42WebviewTableViewCell;

@protocol M42WebviewTableViewCellDelegate

@optional
- (void)tableCellDidLoadContent:(M42WebviewTableViewCell*)cell;
- (void)tableCellWasClicked:(M42WebviewTableViewCell*)cell;
- (BOOL)tableCell:(M42WebviewTableViewCell*)cell shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end

@interface M42WebviewTableViewCell : UITableViewCell<UIWebViewDelegate> {
	id<M42WebviewTableViewCellDelegate> delegate;
	UIWebView *webView;
	NSString *html;
	NSURL *baseURL;	
	int tag;
	CGFloat neededHeight;
	BOOL ready;
}
@property(assign) id<M42WebviewTableViewCellDelegate> delegate;

- (void)setHtml:(NSString *)newHtml AndBaseURL:(NSURL*)baseURL;
@property(readonly) NSString *html;
@property(readonly) NSURL *baseURL;

@property(readonly) UIWebView *webView;
@property(assign) int tag;
@property(readonly) CGFloat height;
@property(readonly) BOOL ready;

- (CGRect)frameForEmptyWebviewAssumingBounds:(CGRect)f;
- (CGRect)frameForEmptyWebview;
@end
