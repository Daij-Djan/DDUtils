//
//  DDAddressPicker.h
//  DDSigner
//
//  Created by Dominik Pich on 12.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ABPeoplePickerView;
@class DDAddressPicker;

/**
 * the picker's delegate
 */
@protocol DDAddressPickerDelegate <NSObject, NSWindowDelegate>

@optional
- (BOOL)addressPicker:(DDAddressPicker  *)picker canEndWithReturnCode:(NSInteger)returnCode;

@end

/**
 * a window that allows selecting people
 */
@interface DDAddressPicker : NSWindowController

/**
 * the delegate
 */
@property(weak) IBOutlet id<DDAddressPickerDelegate> delegate;

/**
 * a NSInteger tag that can be assigned - works like NSView's tags
 */
@property(assign) NSInteger tag;

/** 
 * the list of selected persons
 */
@property(readonly) NSArray *persons;

/**
 * if true,  at least one person needs to be able to close the panel
 */
@property(assign) BOOL needsSelection;

/**
 * run as an application modal panel
 */
- (NSInteger)runModal;

/**
 * make the picker select the ABPerson that corresponds to 'me'
 */
- (void)selectMe;

/**
 * the picker view
 * @warn for more options, configure it directly
 */
@property(weak) IBOutlet ABPeoplePickerView *peoplePickerView;

@end
