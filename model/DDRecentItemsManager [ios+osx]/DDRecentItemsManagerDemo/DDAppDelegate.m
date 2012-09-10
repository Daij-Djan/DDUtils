//
//  DDAppDelegate.m
//  DDAddressPickerDemo
//
//  Created by Dominik Pich on 8/28/12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDRecentItemsManager.h"

@implementation DDAppDelegate {
    NSArray *saves;
}

- (void)awakeFromNib {
    saves = [[DDRecentItemsManager sharedManager] savedSearchesforIdentifier:@"DEMO"];
}

- (void)updateHistory:(id)sender {
    id str = self.textView.stringValue;
    if(![str length])
        return;
    
    [[DDRecentItemsManager sharedManager] saveSearch:@{@"Demo-String":str} forIdentifier:@"DEMO" error:nil];
    saves = [[DDRecentItemsManager sharedManager] savedSearchesforIdentifier:@"DEMO"];
    [self.historyTable reloadData];
}

- (void)applyEntry:(id)sender {
    NSUInteger row = self.historyTable.clickedRow;
    self.textView.stringValue = saves[row];
}

#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return saves.count;
}

/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView).
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return saves[row];
}

@end
