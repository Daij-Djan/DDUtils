//
//  main.m
//  filterableArrayDemo
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFilterableArray.h"

void sample1() {
    NSLog(@"*** Simple sample with strings in array");

    DDFilterableArray *array = [@[@"brown", @"yellow", @"green", @"blue", @"foo", @"bar"]filterableCopy];
    
    for (NSString *colorName in array) {
        NSLog(@"%@", colorName);
    }
    
    NSLog(@"---");
    
    for (NSString *colorName in array[@"SELF BEGINSWITH 'b'"]) {
        NSLog(@"%@", colorName);
    }
    
    NSLog(@"---");
    
    for (NSString *colorName in array[[NSPredicate predicateWithFormat:@"SELF BEGINSWITH 'b'"]]) {
        NSLog(@"%@", colorName);
    }
    
    DDMutableFilterableArray *marray = [array mutableCopy];
    [marray addObject:@"beige"];
    [marray addObject:@"black"];
    [marray removeObject:@"blue"];
    
    NSLog(@"---");
    
    for (NSString *colorName in marray[@"SELF BEGINSWITH 'b'"]) {
        NSLog(@"%@", colorName);
    }
}

void sample2() {
    NSLog(@"*** Simple sample with dicts and keyPaths in array");
    
    DDFilterableArray *array = [@[@{@"color":@{@"name":@"brown"}}, @{@"color":@{@"name":@"yellow"}}, @{@"color":@{@"name":@"green"}}, @{@"color":@{@"name":@"blue"}}, @{@"color":@{@"name":@"foo"}}, @{@"color":@{@"name":@"bar"}}] filterableCopy];
    
    for (NSDictionary *color in array) {
        NSLog(@"%@", color);
    }
    
    NSLog(@"---");
    
    for (NSDictionary *color in array[@"color.name BEGINSWITH 'b'"]) {
        NSLog(@"%@", color);
    }
    
    NSLog(@"---");
    
    for (NSDictionary *color in array[[NSPredicate predicateWithFormat:@"color.name BEGINSWITH 'b'"]]) {
        NSLog(@"%@", color);
    }
    
    DDMutableFilterableArray *marray = [array mutableCopy];
    [marray addObject:@{@"color":@{@"name":@"beige"}}];
    [marray addObject:@{@"color":@{@"name":@"black"}}];
    [marray removeObject:@{@"color":@{@"name":@"blue"}}];
    
    NSLog(@"---");
    
    for (NSDictionary *color in marray[@"color.name BEGINSWITH 'b'"]) {
        NSLog(@"%@", color);
    }
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        sample1();//simple strings in an array
        sample2();//nested dictionaries in array. Use KeyPath to filter
    }
    return 0;
}

