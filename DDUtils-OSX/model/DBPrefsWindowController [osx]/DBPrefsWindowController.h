//
//  DBPrefsWindowController.h
//
//  Created by Dominik Pich based on class by Dave Batton
//
//  Copyright 2012. Some rights reserved.
//  This work is licensed under a Creative Commons license:
//  http://creativecommons.org/licenses/by/3.0/
//
#import <Cocoa/Cocoa.h>

@interface DBPrefsWindowController : NSWindowController

+ (id)sharedController;

- (void)setupToolbar;
- (void)addViewController:(NSViewController  *)view label:(NSString  *)label image:(NSImage  *)image;
- (void)addViewController:(NSViewController  *)view item:(NSToolbarItem *)item;

@property(assign) BOOL crossFade;
@property(assign) BOOL shiftSlowsAnimation;

- (void)toggleActivePreferenceView:(NSToolbarItem  *)toolbarItem;
- (void)displayViewForIdentifier:(NSString  *)identifier animate:(BOOL)animate;
- (void)crossFadeView:(NSView  *)oldView withView:(NSView  *)newView;
- (NSRect)frameForView:(NSView  *)view;


@end