//
//  main.m
//  DDDChecksum
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSObject+isValidPlist.h"

int main(int argc, const char *argv[])
{

    @autoreleasepool {
        //1
        id obj = @"lala";
        NSLog(@"valid: %d", [obj isValidPlist]);

        //0
        obj = [NSTimeZone systemTimeZone];
        NSLog(@"valid: %d", [obj isValidPlist]);

        //1
        obj = @{@"lala": @"xx"};
        NSLog(@"valid: %d", [obj isValidPlist]);
        
        //0
        obj = @{@"lala": [NSTimeZone systemTimeZone]};
        NSLog(@"valid: %d", [obj isValidPlist]);
        
        //0
        obj = @[@"lala", [NSTimeZone systemTimeZone]];
        NSLog(@"valid: %d", [obj isValidPlist]);

        //1
        obj = @[@"lala", @{@"W23":@"22"}];
        NSLog(@"valid: %d", [obj isValidPlist]);
}
    return 0;
}

