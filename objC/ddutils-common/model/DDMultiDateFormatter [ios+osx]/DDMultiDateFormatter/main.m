//
//  main.m
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/2/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMultiDateFormatter.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //as a note... the more dates the longer ;)
        
        DDMultiDateFormatter *df = [[DDMultiDateFormatter alloc] init];
        
        NSLog(@"df = %@", df);
        
        NSLog(@"1. test = %@", [df dateFromString:@"2015-01-25T09:37:07Z"]);
        NSLog(@"2. test = %@", [df dateFromString:@"2015-01-25T09:37:07.001Z"]);
        NSLog(@"3. test = %@", [df dateFromString:@"2015-01-25T09:37:07+01:00"]);
        NSLog(@"4. test = %@", [df dateFromString:@"2015-01-25T09:37:07.0012+01:30"]);
        NSLog(@"5a. test = %@", [df dateFromString:@"201501250937Z"]); //should fail as we havent added a formatter
        NSLog(@"6a. test = %@", [df dateFromString:@"201501250937+01"]); //should fail as we havent added a formatter
        
        [df addNewFormatter:^(NSDateFormatter * _Nonnull newFormatter) {
            newFormatter.dateFormat = @"yyyyMMddHHmmXXXXX";
        }];

        NSLog(@"5b. test = %@", [df dateFromString:@"201501250937Z"]);
        NSLog(@"6b. test = %@", [df dateFromString:@"201501250937+2"]);
        NSLog(@"7a test = %@", [df dateFromString:@"20150125"]); //should fail as we havent added a formatter

        [df addNewFormatter:^(NSDateFormatter * _Nonnull newFormatter) {
            newFormatter.dateFormat = @"yyyyMMdd";
        }];
    
        NSLog(@"7b test = %@", [df dateFromString:@"20150125"]);
    }
    return 0;
}
