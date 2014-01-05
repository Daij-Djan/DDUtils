//
//  DBPrefsWindowController.m
//

#import "DBPrefsWindowController.h"

@implementation DBPrefsWindowController {
	NSMutableArray *_toolbarIdentifiers;
	NSMutableDictionary *_toolbarViewControllers;
	NSMutableDictionary *_toolbarItems;
	
	NSView *_contentSubview;
	NSViewAnimation *_viewAnimation;
}

+ (id)sharedController
{
    static id _sharedPrefsWindowController = nil;
    
	if (!_sharedPrefsWindowController) {
        _sharedPrefsWindowController = [[self alloc] initWithWindow:nil];
	}
	return _sharedPrefsWindowController;
}

#pragma mark -
#pragma mark Setup & Teardown

- (id)initWithWindow:(NSWindow *)window {
    if(!window) {
        window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,1000,1000)
                                             styleMask:(NSTitledWindowMask |
                                                        NSClosableWindowMask |
                                                        NSMiniaturizableWindowMask)
                                               backing:NSBackingStoreBuffered
                                                 defer:YES];
#if __has_feature(objc_arc)
#else
        [window autorelease];
#endif
    }
    
	self = [super initWithWindow:window];
	if (self != nil) {
        _contentSubview = [[NSView alloc] initWithFrame:[[[self window] contentView] frame]];
        [_contentSubview setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
        [[[self window] contentView] addSubview:_contentSubview];
        [[self window] setShowsToolbarButton:NO];
        
		// Set up an array and some dictionaries to keep track
		// of the views we'll be displaying.
		_toolbarIdentifiers = [[NSMutableArray alloc] init];
		_toolbarViewControllers = [[NSMutableDictionary alloc] init];
		_toolbarItems = [[NSMutableDictionary alloc] init];
		
		// Set up an NSViewAnimation to animate the transitions.
		_viewAnimation = [[NSViewAnimation alloc] init];
		[_viewAnimation setAnimationBlockingMode:NSAnimationNonblocking];
		[_viewAnimation setAnimationCurve:NSAnimationEaseInOut];
		[_viewAnimation setDelegate:(id<NSAnimationDelegate>)self];
		
		[self setCrossFade:YES]; 
		[self setShiftSlowsAnimation:YES];
	}
	return self;
}

#if __has_feature(objc_arc)
#else
- (void) dealloc {
	[_toolbarIdentifiers release];
	[_toolbarViews release];
	[_toolbarItems release];
	[_viewAnimation release];
    [_contentSubview release];
	[super dealloc];
}
#endif

#pragma mark -
#pragma mark Configuration

- (void)setupToolbar {
    @throw [NSException exceptionWithName:@"AbstractMethod" reason:@"subclasses must override" userInfo:nil];

	// Subclasses must override this method to add items to the
	// toolbar by calling -addViewController:label:image: or -addViewController:item:.
}

- (void)addViewController:(NSViewController *)view label:(NSString *)label image:(NSImage *)image {
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:label];
	[item setLabel:label];
    [item setImage:image];

    [self addViewController:view item:item];
    
#if __has_feature(objc_arc)
#else
    [item release];
#endif
}

- (void)addViewController:(NSViewController *)view item:(NSToolbarItem *)item {
	NSAssert (view != nil, @"Attempted to add a nil view when calling -addView:label:image:.");
	
	[item setTarget:self];
	[item setAction:@selector(toggleActivePreferenceView:)];
    [[item menuFormRepresentation] setTarget:self];
    [[item menuFormRepresentation] setAction:@selector(toggleActivePreferenceView:)];
    [[item menuFormRepresentation] setRepresentedObject:item.itemIdentifier];

	[_toolbarIdentifiers addObject:item.itemIdentifier];
	[_toolbarViewControllers setObject:view forKey:item.itemIdentifier];
	[_toolbarItems setObject:item forKey:item.itemIdentifier];
}

#pragma mark -
#pragma mark Toolbar handling

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
	return _toolbarIdentifiers;
	
	(void)toolbar;
}




- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
	return _toolbarIdentifiers;
	
	(void)toolbar;
}




- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return _toolbarIdentifiers;
	(void)toolbar;
}




- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted {
	return [_toolbarItems objectForKey:identifier];
	(void)toolbar;
	(void)willBeInserted;
}




- (void)toggleActivePreferenceView:(id)sender {
    NSString * identifier = nil;
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        identifier = [sender representedObject];
    } else {
        identifier = [sender identifier];
    }
	[self displayViewForIdentifier:identifier animate:YES];
    NSToolbarItem *item = [_toolbarItems objectForKey:identifier];
    [[item toolbar] setSelectedItemIdentifier:identifier];
}

#pragma mark -
#pragma mark showing the right view

- (IBAction)showWindow:(id)sender
{
	// This forces the resources in the nib to load.
	(void)[self window];
	
    // recreate toolbar items if there is no toolbar, or items count is equal to 0
    if (![[[[self window] toolbar] items] count]) {
        [_toolbarIdentifiers removeAllObjects];
        [_toolbarViewControllers removeAllObjects];
        [_toolbarItems removeAllObjects];
        [self setupToolbar];
    }
	
	NSAssert (([_toolbarIdentifiers count] > 0),
			  @"No items were added to the toolbar in -setupToolbar.");
	
	if ([[self window] toolbar] == nil) {
		NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"DBPreferencesToolbar"];
		[toolbar setAllowsUserCustomization:NO];
		[toolbar setAutosavesConfiguration:NO];
		[toolbar setSizeMode:NSToolbarSizeModeDefault];
		[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
		[toolbar setDelegate:(id<NSToolbarDelegate>)self];
		[[self window] setToolbar:toolbar];
#if __has_feature(objc_arc)
#else
		[toolbar release];
#endif
	}
	
	NSString *firstIdentifier = [_toolbarIdentifiers objectAtIndex:0];
	[[[self window] toolbar] setSelectedItemIdentifier:firstIdentifier];
	[self displayViewForIdentifier:firstIdentifier animate:NO];
	
	[[self window] center];
	
	[super showWindow:sender];
}

- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate {
	// Select the toolbar item if it hasn't happened already. Necessery when calling this method from outside of this class.
    NSToolbarItem *item = [_toolbarItems objectForKey:identifier];
	NSToolbar *toolbar = [item toolbar];
	if ( ![toolbar.selectedItemIdentifier isEqualToString:identifier] )
		[toolbar setSelectedItemIdentifier:identifier];
	
	// Find the view we want to display.
	NSViewController *newViewController = [_toolbarViewControllers objectForKey:identifier];
	NSView *newView = newViewController.view;
    
	// See if there are any visible views.
	NSView *oldView = nil;
	if ([[_contentSubview subviews] count] > 0) {
		// Get a list of all of the views in the window. Usually at this
		// point there is just one visible view. But if the last fade
		// hasn't finished, we need to get rid of it now before we move on.
		NSEnumerator *subviewsEnum = [[_contentSubview subviews] reverseObjectEnumerator];
		
		// The first one (last one added) is our visible view.
		oldView = [subviewsEnum nextObject];
		
		// Remove any others.
		NSView *reallyOldView = nil;
		while ((reallyOldView = [subviewsEnum nextObject]) != nil) {
			[reallyOldView removeFromSuperviewWithoutNeedingDisplay];
		}
	}
	
	if (![newView isEqualTo:oldView]) {
		NSRect frame = [newView bounds];
		frame.origin.y = NSHeight([_contentSubview frame]) - NSHeight([newView bounds]);
		[newView setFrame:frame];
		[_contentSubview addSubview:newView];
		[[self window] setInitialFirstResponder:newView];
		
		if (animate && [self crossFade])
			[self crossFadeView:oldView withView:newView];
		else {
			[oldView removeFromSuperviewWithoutNeedingDisplay];
			[newView setHidden:NO];
			[[self window] setFrame:[self frameForView:newView] display:YES animate:animate];
		}
		
		[[self window] setTitle:[[_toolbarItems objectForKey:identifier] label]];
	}
}

#pragma mark -
#pragma mark Cross-Fading Methods

- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView {
	[_viewAnimation stopAnimation];
	
    if ([self shiftSlowsAnimation] && [[[self window] currentEvent] modifierFlags] & NSShiftKeyMask)
		[_viewAnimation setDuration:1.25];
    else
		[_viewAnimation setDuration:0.25];
	
	NSDictionary *fadeOutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									   oldView, NSViewAnimationTargetKey,
									   NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey,
									   nil];
	
	NSDictionary *fadeInDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									  newView, NSViewAnimationTargetKey,
									  NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
									  nil];
	
	NSDictionary *resizeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									  [self window], NSViewAnimationTargetKey,
									  [NSValue valueWithRect:[[self window] frame]], NSViewAnimationStartFrameKey,
									  [NSValue valueWithRect:[self frameForView:newView]], NSViewAnimationEndFrameKey,
									  nil];
	
	NSArray *animationArray = [NSArray arrayWithObjects:
							   fadeOutDictionary,
							   fadeInDictionary,
							   resizeDictionary,
							   nil];
	
	[_viewAnimation setViewAnimations:animationArray];
	[_viewAnimation startAnimation];
}

- (void)animationDidEnd:(NSAnimation *)animation {
	NSView *subview;
	
    // Get a list of all of the views in the window. Hopefully
    // at this point there are two. One is visible and one is hidden.
	NSEnumerator *subviewsEnum = [[_contentSubview subviews] reverseObjectEnumerator];
	
    // This is our visible view. Just get past it.
	[subviewsEnum nextObject];
	
    // Remove everything else. There should be just one, but
    // if the user does a lot of fast clicking, we might have
    // more than one to remove.
	while ((subview = [subviewsEnum nextObject]) != nil) {
		[subview removeFromSuperviewWithoutNeedingDisplay];
	}
	
	// This is a work-around that prevents the first
	// toolbar icon from becoming highlighted.
	[[self window] makeFirstResponder:nil];
	
	(void)animation;
}

- (NSRect)frameForView:(NSView *)view {
	NSRect windowFrame = [[self window] frame];
	NSRect contentRect = [[self window] contentRectForFrameRect:windowFrame];
	float windowTitleAndToolbarHeight = NSHeight(windowFrame) - NSHeight(contentRect);
	
	windowFrame.size.height = NSHeight([view frame]) + windowTitleAndToolbarHeight;
	windowFrame.size.width = NSWidth([view frame]);
	windowFrame.origin.y = NSMaxY([[self window] frame]) - NSHeight(windowFrame);
	
	return windowFrame;
}

@end