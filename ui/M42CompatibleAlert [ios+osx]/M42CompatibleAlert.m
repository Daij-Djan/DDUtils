//
//  M42CompatibleAlert.m
//  Medikamente
//
//  Created by Dominik on 12/30/10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import "M42CompatibleAlert.h"


@implementation M42CompatibleAlert

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherTitle, ... {
	self = [super init];
#if TARGET_OS_IPHONE
	alertView = [[M42CompatibleAlert alloc] initWithTitle:title
												  message:message
										 		 delegate:delegate
										cancelButtonTitle:cancelButtonTitle
										otherButtonTitles:nil];
#else
	alertView = [[NSAlert alertWithMessageText:title
								 defaultButton:cancelButtonTitle
							   alternateButton:nil 
								   otherButton:nil 
					 informativeTextWithFormat:message] retain];	
	[alertView setDelegate:delegate];
#endif
	//add others BUGBUG
	
	return self;
}

- (void)addButtonWithTitle:(NSString*)title {
	[alertView addButtonWithTitle:title];
}

- (void)show {
#if TARGET_OS_IPHONE
	[alertView show];
#else
	[alertView runModal]; //HACK
#endif
}

- (void)dealloc {
	[alertView release];
	[super dealloc];
}

//BUGBUG
- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	//call delegate
}

@end
