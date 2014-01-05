//
//  DDAppDelegate.m
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import "DDAppDelegate.h"

@implementation DDAppDelegate {
    NSMutableArray *pickers;
}

- (BOOL)addressPicker:(DDAddressPicker *)picker canEndWithReturnCode:(NSInteger)returnCode {
    NSLog(@"Delegate called: %@", picker.persons);
    return YES;
}

- (IBAction)show:(id)sender {
    DDAddressPicker *picker = [[DDAddressPicker alloc] init];
    picker.delegate = self;
    picker.needsSelection = self.needsSelection.state == NSOnState;
    
    if(self.selectMe.state == NSOnState) {
        [picker selectMe];
    }
    
    if(self.runModal.state == NSOnState) {
        [picker runModal];
    }
    else {
        [picker showWindow:sender];
        if(!pickers)
            pickers = [NSMutableArray arrayWithCapacity:5];
        [pickers addObject:picker];
    }
}
@end
