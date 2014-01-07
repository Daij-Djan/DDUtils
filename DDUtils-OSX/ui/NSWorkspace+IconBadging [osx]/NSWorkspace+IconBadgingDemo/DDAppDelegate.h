//
//  DDAppDelegate.h
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//

#import <Cocoa/Cocoa.h>
#import "NSWorkspace+IconBadging.h"

@interface DDAppDelegate : NSObject <NSApplicationDelegate>

@property(assign) IBOutlet NSWindow *window;

@property(weak) IBOutlet NSTextField *demoPathField;
- (IBAction)apply:(id)sender;
- (IBAction)show:(id)sender;

@end
