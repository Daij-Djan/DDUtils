//
//  DDAppDelegate.h
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DDRecentItemsManager.h"

@interface DDAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSTableViewDataSource>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textView;
@property (weak) IBOutlet NSTableView *historyTable;

- (IBAction)updateHistory:(id)sender;
- (IBAction)applyEntry:(id)sender;

@end
