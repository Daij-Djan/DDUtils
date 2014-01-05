//
//  DDAppDelegate.h
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DDAddressPicker.h"

@interface DDAppDelegate : NSObject <NSApplicationDelegate, DDAddressPickerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSButton *selectMe;
@property (weak) IBOutlet NSButton *runModal;
@property (weak) IBOutlet NSButton *needsSelection;
- (IBAction)show:(id)sender;

@end
