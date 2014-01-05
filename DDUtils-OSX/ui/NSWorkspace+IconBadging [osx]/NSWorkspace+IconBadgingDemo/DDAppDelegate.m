//
//  DDAppDelegate.m
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//

#import "DDAppDelegate.h"

@implementation DDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    id path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IconsToBeBadged"];
    [self.demoPathField setStringValue:path];
}

- (IBAction)apply:(id)sender {
    id path = nil;
    NSInteger index = [sender selectedSegment];
    
    switch (index) {
        case 0:
            path = [[NSBundle mainBundle] pathForResource:@"folderbadge_error" ofType:@"icns"];
            break;
            
        case 1:
            path = [[NSBundle mainBundle] pathForResource:@"folderbadge_sync" ofType:@"icns"];
            break;

        case 2:
            path = [[NSBundle mainBundle] pathForResource:@"folderbadge_update" ofType:@"icns"];
            break;
    }
    
    //apply badge
    id root = self.demoPathField.stringValue;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:root error:nil];
    for(id file in files) {
        id child = [root stringByAppendingPathComponent:file];
        [[NSWorkspace sharedWorkspace] setIconBadge:path atFilePath:child];
    }
}

- (IBAction)show:(id)sender {
    id root = self.demoPathField.stringValue;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:root error:nil];
    id firstFile = [files objectAtIndex:0];
    firstFile = [root stringByAppendingPathComponent:firstFile];
    
    [[NSWorkspace sharedWorkspace] selectFile:firstFile inFileViewerRootedAtPath:root];
}

@end
