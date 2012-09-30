//
//  M42ActionSheet.h
//  Mediscript
//
//  Created by Dominik Pich on 11/17/10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//
#import "M42ClickableLabel.h"

@class M42ClickableImageView;

@interface M42ActionSheet : M42ClickableLabel {
@private
    id <UIActionSheetDelegate> delegate;
	UILabel *titleLabel;
	NSArray *buttons;
	
	NSUInteger destructiveButtonIndex;
	NSUInteger cancelButtonIndex;
	NSString *destructiveButtonColorName;
	NSString *cancelButtonColorName;
	NSString *defaultButtonColorName;
	
	M42ClickableImageView *imageView;
	UIImageView *imageView2;
	UIImageView *imageView3;
	UIView *backgroundView;
	UIView *blackView;	
}

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property(nonatomic,assign) id<UIActionSheetDelegate> delegate;    // weak reference
@property(nonatomic,copy) UILabel *titleLabel;
@property(nonatomic,copy) NSArray *buttons;

@property(nonatomic,assign) NSUInteger destructiveButtonIndex;
@property(nonatomic,assign) NSUInteger cancelButtonIndex;
@property(nonatomic,copy) NSString *destructiveButtonColorName;
@property(nonatomic,copy) NSString *cancelButtonColorName;

// adds a button with the title. returns the index (0 based) of where it was added. 
- (NSInteger)addButtonWithTitle:(NSString *)title;
//colorname of button 
//colorname can be anything you want IF you have the right image files in your project
// images used: button_%%COLORNAM%%.png || loads image using imageNamed
- (NSInteger)addButtonWithTitle:(NSString *)title colorName:(NSString*)colorName;

// show a sheet animated. you can specify either a toolbar, a tab bar, a bar butto item or a plain view. We do a special animation if the sheet rises from
// a toolbar, tab bar or bar button item and we will automatically select the correct style based on the bar style. if not from a bar, we use
// UIActionSheetStyleDefault if automatic style set
//- (void)showFromToolbar:(UIToolbar *)view;
//- (void)showFromTabBar:(UITabBar *)view;
//- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);
//- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);
- (void)showInView:(UIView *)view;

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)destroy;

@end