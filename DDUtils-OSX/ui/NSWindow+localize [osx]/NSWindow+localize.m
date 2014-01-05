//
//  NSWindow+localize.m
//  Autorunner
//
//  Created by Dominik Pich on 3/10/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import "NSWindow+localize.h"


@implementation NSWindow (localize)

- (void)localizeView:(id)view recursively:(BOOL)flag {
	if(flag) {
		if([view respondsToSelector:@selector(subviews)]) {
			for (NSView *v in [view subviews]) {
				[self localizeView:v recursively:YES];
			}
		}
//		if([view respondsToSelector:@selector(documentView)])
//			[self localizeView:[view documentView] recursively:YES];
	}
	
	//localize view itself
	if([view respondsToSelector:@selector(stringValue)] && [view respondsToSelector:@selector(setStringValue:)]) {
		[view setStringValue:NSLocalizedString([view stringValue], @"view stringValue")];
	}
	if([view respondsToSelector:@selector(title)] && [view respondsToSelector:@selector(setTitle:)]) {
		[view setTitle:NSLocalizedString([view title], @"view title")];
	}
	if([view respondsToSelector:@selector(tableColumns)]) {
		for (NSTableColumn *c in [view tableColumns]) {
			[[c headerCell] setStringValue:NSLocalizedString([[c headerCell] stringValue], @"tableColumn")];
		}
	}
	if([view respondsToSelector:@selector(tabViewItems)]) {
		for (NSTabViewItem *c in [view tabViewItems]) {
			[c setLabel:NSLocalizedString([c label], @"view title")];
			[self localizeView:[c view] recursively:YES];
		}
	}
}

- (void)localize {
	[self setTitle:NSLocalizedString([self title], @"window title")];
	[self localizeView:[self contentView] recursively:YES];
}
@end
