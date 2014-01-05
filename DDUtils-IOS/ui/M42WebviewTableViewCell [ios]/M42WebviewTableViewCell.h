//
//  MSTableViewCell.h
//  mediscript
//
//  Created by Dominik Pich on 09.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//
//  modernized 12/2013
//

#import <UIKit/UIKit.h>

@class M42WebviewTableViewCell;

@protocol M42WebviewTableViewCellDelegate <NSObject>
- (void)tableCellDidLoadContent:(M42WebviewTableViewCell*)cell;
@optional
- (BOOL)tableCell:(M42WebviewTableViewCell*)cell shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end

#pragma mark -

@interface M42WebviewTableViewCell : UITableViewCell<UIWebViewDelegate>
#if !__has_feature(objc_arc)
@property(assign) id<M42WebviewTableViewCellDelegate> delegate;
#else
@property(weak) id<M42WebviewTableViewCellDelegate> delegate;
#endif

- (void)setHtmlFromURL:(NSURL *)newHtmlURL;
@property(nonatomic, copy, readonly) NSURL *htmlURL;

- (void)setHtml:(NSString *)newHtml AndBaseURL:(NSURL*)baseURL;
@property(nonatomic, copy, readonly) NSString *html;
@property(nonatomic, copy, readonly) NSURL *baseURL;

@property(nonatomic, assign) int tag;

@property(nonatomic, readonly) UIWebView *webView;
@property(nonatomic, readonly) CGFloat height;
@property(nonatomic, readonly) BOOL ready;
@end
