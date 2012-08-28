//
//  DDAddressPicker.m
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDAddressPicker.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPeoplePickerView.h>
#import "NSView+findSubview.h"

#define APPSTORE_CONFORM 0

@interface DDAddressPicker () {
	BOOL selectMeOnLoad;
}
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)selectMe:(id)sender;
@end

@implementation DDAddressPicker

- (id)init {
    return [super initWithWindowNibName:@"AddressPicker"];
}

- (void)windowDidLoad {
	if(selectMeOnLoad) {
		[self selectMe:nil];
		selectMeOnLoad = NO;
	}
}
#pragma mark actions

- (IBAction)cancel:(id)sender {
    [_peoplePickerView deselectAll:nil];
    
    if([_delegate respondsToSelector:@selector(addressPicker:canEndWithReturnCode:)]) {
        BOOL br = [_delegate addressPicker:self canEndWithReturnCode:NSCancelButton];
        if(br)
            [NSApp stopModalWithCode:NSCancelButton];
    }
}

- (IBAction)ok:(id)sender {
    if(self.needsSelection && !self.persons.count) {
        return ;
    }
    
    if([_delegate respondsToSelector:@selector(addressPicker:canEndWithReturnCode:)]) {
        BOOL br = [_delegate addressPicker:self canEndWithReturnCode:NSOKButton];
        if(br)
            [NSApp stopModalWithCode:NSOKButton];
    }
}

-(IBAction)selectMe:(id)sender {
    if(_peoplePickerView) {
        ABPerson *person = [[ABAddressBook sharedAddressBook] me];
        if(person) {
            [_peoplePickerView selectIdentifier:kABEmailProperty forPerson:person byExtendingSelection:NO];
            //=-> bug: tableView isnt scrolled!
            
#if APPSTORE_CONFORM
            NSLog(@"due to a bug in the view, focusing (making visible) the new selection isnt possible");
#else
            //
            //working hack
            //
            
            //get table
            id view = [_peoplePickerView firstSubviewOfKind:NSClassFromString(@"ABPeoplePickerTableView")];
            
            //scroll
            if([view respondsToSelector:@selector(scrollRowToVisible:)]
               && [view respondsToSelector:@selector(selectedRow)]) {
                
                [view scrollRowToVisible:[view selectedRow]];
            }
            
            //focus
            [[view window] makeFirstResponder:view];
#endif
        }
    }
}

#pragma mark -

- (NSArray *)persons {
    return _peoplePickerView.selectedValues.count ? _peoplePickerView.selectedValues : nil;
}

- (NSInteger)runModal {
    return [NSApp runModalForWindow:self.window];
}

- (void)selectMe {
	if(_peoplePickerView)
		[self selectMe:nil];
	else
		selectMeOnLoad = YES;
}
@end
