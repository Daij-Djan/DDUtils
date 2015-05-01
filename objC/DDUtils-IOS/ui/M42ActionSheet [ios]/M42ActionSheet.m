//
//  M42ActionSheet.m
//  Mediscript
//
//  Created by Dominik Pich on 11/17/10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import "M42ActionSheet.h"
#import "M42ClickableImageView.h"

@implementation M42ActionSheet {
	NSString *defaultButtonColorName;

	M42ClickableImageView *imageView;
	UIImageView *imageView2;
	UIImageView *imageView3;
	UIView *backgroundView;
	UIView *blackView;
}

#pragma mark animation

- (void)blendInInView:(UIView  *)parentView {
	CGRect frame = parentView.bounds;
    BOOL isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
	if (!isIPad) {
		//set initial location at bottom of view
		frame.origin = CGPointMake(0.0, frame.size.height);
	}
	self.frame = frame;
	self.alpha = 0;
	[parentView addSubview:self];

    //animate to new location, determined by height of the view in the NIB
    [UIView beginAnimations:@"presentWithSuperview" context:nil];

	// Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

	if (!isIPad) {
		frame.origin = CGPointMake(0.0, 0.0);
		self.frame = frame;
	} else {

		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2]; // for testing only
	}

	self.alpha = 1;
    [UIView commitAnimations];

//	[self layoutSubviews];
}

- (void) blendOutWithButtonIndex:(NSInteger)buttonIndex {
    BOOL isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

	if (!isIPad) {
		self.backgroundColor = [UIColor clearColor];
	}

	[UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];

    // Set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

	if (!isIPad) {
		// Move this view to bottom of superview
		CGRect frame = self.frame;
		frame.origin = CGPointMake(0.0, self.frame.size.height);
		self.frame = frame;
	}
	self.alpha = 0;
    [UIView commitAnimations]; 
}

// Method called when removeFromSuperviewWithAnimation's animation completes
- (void)animationDidStop:(NSString  *)animationID finished:(NSNumber  *)finished context:(void  *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self destroy];
	
		NSUInteger buttonIndex = [(__bridge NSNumber *)context integerValue];
		if ([(NSObject *)delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
			[delegate actionSheet:(id)self didDismissWithButtonIndex:buttonIndex];
    } else {

		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2]; // for testing only
	}
}
#pragma mark main

- (id)initWithTitle:(NSString  *)title delegate:(id<UIActionSheetDelegate>)d cancelButtonTitle:(NSString  *)cancelButtonTitle destructiveButtonTitle:(NSString  *)destructiveButtonTitle otherButtonTitles:(NSString  *)otherButtonTitles, ... {
	self = [super init];

	delegate = d;

	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];

	self.destructiveButtonColorName = @"red";
	self.cancelButtonColorName = @"darkGray";//black?!
//	defaultButtonColorName = isIPad ? @"white" : @"lightGray";
	defaultButtonColorName = @"lightGray";

	titleLabel = [[UILabel alloc] init];
	titleLabel.text = title;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.numberOfLines = 0;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];

	UIImage *image = [UIImage imageNamed:@"sheet_header.png"];
	imageView = [[M42ClickableImageView alloc] initWithImage:image];
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.opaque = NO;
	imageView.backgroundColor = [UIColor clearColor];
	imageView.userInteractionEnabled = YES;
	imageView.action = @selector(confirm);
	imageView.target = self;
	image = [UIImage imageNamed:@"sheet_footer.png"];
	if (image) {
		imageView2 = [[UIImageView alloc] initWithImage:image];
		imageView2.contentMode = UIViewContentModeScaleToFill;
		imageView2.opaque = NO;
		imageView2.backgroundColor = [UIColor clearColor];
	}

	backgroundView = [[UIView alloc] init];

    BOOL isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

    if (!isIPad) {
		backgroundView.backgroundColor = [UIColor colorWithRed:0.333333333333333 green:0.36078431372549 blue:0.4 alpha:1.0];
    } else {

		backgroundView.backgroundColor = [UIColor clearColor];
    }

	if (isIPad) {
		blackView = [[UIView alloc] init];
		blackView.opaque = YES;
		blackView.backgroundColor = [UIColor blackColor];
	}

	if (destructiveButtonTitle) {
		destructiveButtonIndex = [self addButtonWithTitle:destructiveButtonTitle colorName:destructiveButtonColorName];
	}

	if (otherButtonTitles) {
		[self addButtonWithTitle:otherButtonTitles];

		va_list args;
		va_start(args, otherButtonTitles);
		
		title = va_arg(args, NSString *);
		while (title != nil) {
			[self addButtonWithTitle:title];
			title = va_arg(args, NSString *);
		
		}
		va_end(args);
	}

	if (cancelButtonTitle) {
		cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle colorName:cancelButtonColorName];
	}

	return self;
}

- (void)setButtonAtIndex:(NSUInteger)i colorName:(NSString *)colorName {
	UIButton *button = [buttons objectAtIndex:i];
					
	//font hack!
	BOOL dark = ([colorName isEqualToString:@"white"] || [colorName rangeOfString:@"light"].location != NSNotFound) ? NO : YES;
	if (dark)
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	else {
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

	UIImage *buttonBackground = [UIImage imageNamed:[NSString stringWithFormat:@"button_%@.png", colorName]];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"button_blue.png"];
	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
}

@synthesize delegate;
@synthesize titleLabel;
@synthesize buttons;
@synthesize destructiveButtonIndex;
- (void)setDestructiveButtonIndex:(NSUInteger)i {
	if (i >= self.buttons.count) return;

	[self setButtonAtIndex:0 colorName:defaultButtonColorName];
	[self setButtonAtIndex:i colorName:destructiveButtonColorName];

	id old = [buttons objectAtIndex:0];
	id new = [buttons objectAtIndex:i];
	[(NSMutableArray *)self.buttons replaceObjectAtIndex:0 withObject:new];
	[(NSMutableArray *)self.buttons replaceObjectAtIndex:i withObject:old];

	destructiveButtonIndex = i;
					
}
@synthesize cancelButtonIndex;
- (void)setCancelButtonIndex:(NSUInteger)i {
	if (i >= self.buttons.count) return;

	[self setButtonAtIndex:0 colorName:defaultButtonColorName];
	[self setButtonAtIndex:i colorName:cancelButtonColorName];

	id old = [buttons objectAtIndex:0];
	id new = [buttons objectAtIndex:i];
	[(NSMutableArray *)self.buttons replaceObjectAtIndex:0 withObject:new];
	[(NSMutableArray *)self.buttons replaceObjectAtIndex:i withObject:old];

	cancelButtonIndex = i;
}
@synthesize destructiveButtonColorName;
- (void)setDestructiveButtonColorName:(NSString *)colorName {
	if (destructiveButtonColorName != colorName) {
        destructiveButtonColorName = [colorName copy];
		[self setButtonAtIndex:destructiveButtonIndex colorName:colorName];
	}
}

@synthesize cancelButtonColorName;
- (void)setCancelButtonColorName:(NSString *)colorName {
	if (cancelButtonColorName != colorName) {
		cancelButtonColorName = [colorName copy];
		[self setButtonAtIndex:cancelButtonIndex colorName:colorName];
	}
}

- (NSInteger)addButtonWithTitle:(NSString  *)title {
	return [self addButtonWithTitle:title colorName:defaultButtonColorName];
}

- (NSInteger)addButtonWithTitle:(NSString  *)title colorName:(NSString *)colorName {
	if (!buttons) {
		buttons = [[NSMutableArray alloc] initWithCapacity:3];
	}

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[button setTitle:title forState:UIControlStateNormal];
	button.backgroundColor = [UIColor clearColor];
	button.opaque = NO;
	[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[(NSMutableArray *)buttons addObject:button];

	[self setButtonAtIndex:buttons.count-1 colorName:colorName];
	return buttons.count-1;
}


// show a sheet animated. you can specify either a toolbar, a tab bar, a bar butto item or a plain view. We do a special animation if the sheet rises from
// a toolbar, tab bar or bar button item and we will automatically select the correct style based on the bar style. if not from a bar, we use
// UIActionSheetStyleDefault if automatic style set
//- (void)showFromToolbar:(UIToolbar  *)view;
//- (void)showFromTabBar:(UITabBar  *)view;
//- (void)showFromBarButtonItem:(UIBarButtonItem  *)item animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);
//- (void)showFromRect:(CGRect)rect inView:(UIView  *)view animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA, __IPHONE_3_2);

- (void)destroy {
	 for (UIButton *b in buttons) {
		 [b removeFromSuperview];
	 }
	 buttons = nil;
	 
	 [titleLabel removeFromSuperview];
	 titleLabel = nil;
	 
	[imageView removeFromSuperview];
	imageView  = nil;

	[imageView2 removeFromSuperview];
	imageView2 = nil;

	[backgroundView removeFromSuperview];
	backgroundView = nil;

	[self removeFromSuperview];

	self.destructiveButtonColorName = nil;
	self.cancelButtonColorName = nil;
}


- (void)showInView:(UIView  *)parentView {
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	self.userInteractionEnabled=YES;
	self.target = self;
	self.action = @selector(cancel);

	[self blendInInView:parentView];
}

- (IBAction)buttonClicked:(UIButton *)sender {
	NSInteger buttonIndex = [buttons containsObject:sender] ? [buttons indexOfObject:sender] : -1;

	if ([(NSObject *)delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
		[delegate actionSheet:(id)self clickedButtonAtIndex:buttonIndex];

	[self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

// hides alert sheet or popup. use this method when you need to explicitly dismiss the alert.
// it does not need to be called if the user presses on a button
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	if ([(NSObject *)delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)])
		[delegate actionSheet:(id)self willDismissWithButtonIndex:buttonIndex];

	if (animated) {
		[self blendOutWithButtonIndex:buttonIndex];
	} else {

		[self destroy];

		if ([(NSObject *)delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)])
			[delegate actionSheet:(id)self didDismissWithButtonIndex:buttonIndex];
	}
}

- (void)dealloc {
	[self destroy];
}

#pragma mark layouting

- (void)layoutSubviews {
    CGRect frame = self.superview.bounds;
    self.frame = frame;
    
    BOOL isIPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);

	int BUTTON_HEIGHT = 44;
	int HSPACER = 18;
	int VSPACER = 8;
	if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
		BUTTON_HEIGHT = 40;
		VSPACER = 7;
	}

	frame = self.frame;

	if (isIPad) {
		HSPACER = 4;
		VSPACER = 6;
		frame.size.width = 400;
	}

	frame.origin.y = 0;//frame.size.height- (BUTTON_HEIGHT+HSPACER);
	frame.origin.x = 0;//HSPACER;
	
	//frame.size.width = self.frame.size.width;
	frame.size.height = imageView.image.size.height;
	imageView.frame = frame;
	if (imageView.superview != self) {
		[backgroundView addSubview:imageView];
	}	

	frame.origin.x = HSPACER;
	frame.size.width -= HSPACER*2;
	frame.size.height = BUTTON_HEIGHT;

	titleLabel.frame = frame;
	if (titleLabel.superview != self) {
		[backgroundView addSubview:titleLabel];
	}	
	frame.origin.y += frame.size.height + VSPACER;
//	frame.size.height = BUTTON_HEIGHT;

	BOOL first = YES;
	NSUInteger i, c = buttons.count;

	for(i=0; i < c; i++) {
		UIButton *button = [buttons objectAtIndex:i];
	
		button.frame = frame;
		if (button.superview != self) {
			[backgroundView addSubview:button];
		}	
		frame.origin.y += (BUTTON_HEIGHT + VSPACER);
		if (first) {
			frame.origin.y += VSPACER;		
			first = NO;
		}
	}

	frame.size.width += HSPACER * 2;
	frame.origin.x = 0;

	if (imageView2) {
		frame.size.height = imageView2.image.size.height;
		imageView2.frame = frame;
		if (imageView2.superview != self) {
			[backgroundView addSubview:imageView2];
		}	
		frame.size.height = frame.origin.y + imageView2.image.size.height;
	} else {

		frame.size.height = frame.origin.y + VSPACER;
	}

	if (isIPad) {
		frame.origin.x = self.frame.origin.x + self.frame.size.width/2 - frame.size.width/2;
		frame.origin.y = self.frame.origin.y + self.frame.size.height/2 - frame.size.height/2;
	} else {

		frame.origin.x = 0;
		frame.origin.y = self.frame.origin.y + self.frame.size.height - frame.size.height;
	}

	backgroundView.frame = frame;

	if (isIPad) {
		frame.origin = CGPointMake(0, imageView.image.size.height);
		frame.size.height -= (frame.origin.y + imageView2.image.size.height);
		blackView.frame = frame;
		if (blackView.superview != backgroundView)
			[backgroundView insertSubview:blackView atIndex:0];
	}

	backgroundView.userInteractionEnabled = YES;
	if (backgroundView.superview != self) {
		[self insertSubview:backgroundView atIndex:0];
	}	
}

- (void)cancel {
	[self dismissWithClickedButtonIndex:cancelButtonIndex animated:YES];
}

- (void)confirm {
	[self dismissWithClickedButtonIndex:destructiveButtonIndex animated:YES];
}

@end