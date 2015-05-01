//
//  MasterViewController.m
//  M42WebviewTableViewCellDemo
//
//  Created by Dominik Pich on 30/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "MasterViewController.h"
#import "M42WebviewTableViewCell.h"

@interface MasterViewController () <M42WebviewTableViewCellDelegate>
@end

@implementation MasterViewController {
    NSMutableArray *_objects;
    NSMutableDictionary *_loadedCells;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    [self insertNewObject];
    [self insertNewObject];
    [self insertNewObject];
    [self insertNewObject];
    [self insertNewObject];
}

- (void)insertNewObject {
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    //can be ANY html a webview can render ... dynamic client side content will make problems (JS -> ajax)
    NSString *colorStr = _objects.count%2==0 ? @"#FF0000" : @"#00FF00";
    NSMutableString *str = [NSMutableString stringWithFormat:@"<html><body bgcolor=%@><h1>HTML CELL! :)</h1><h3>%@</h3>", colorStr, [NSDate date]];
    for (int i = 0; i < _objects.count; i++) {
        [str appendString:@"<p>extra row</p>"];
    }
    [_objects addObject:str];
    
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView  *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView  *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell  *)tableView:(UITableView  *)tableView cellForRowAtIndexPath:(NSIndexPath  *)indexPath {
    M42WebviewTableViewCell *cell = _loadedCells[@(indexPath.row)];
    if (!cell) {
        cell = [[M42WebviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        NSString *object = _objects[indexPath.row];
        cell.tag = indexPath.row;
        cell.delegate = self;
        [cell setHtml:object AndBaseURL:nil];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView  *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath {
    //if a cell isnt ready, it wont be there and the method will return 0
    M42WebviewTableViewCell *cell = _loadedCells[@(indexPath.row)];
    return cell.height;
}

#pragma mark - M42WebviewTableViewCellDelegate

- (void)tableCellDidLoadContent:(M42WebviewTableViewCell *)cell {
    if (!_loadedCells) {
        _loadedCells = [[NSMutableDictionary alloc] init];
    }
    [_loadedCells setObject:cell forKey:@(cell.tag)];
    
    //only refresh sizes of rows
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
