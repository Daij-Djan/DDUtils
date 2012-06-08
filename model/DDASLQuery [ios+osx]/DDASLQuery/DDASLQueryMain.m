//
//  main.m
//  M42ASLQuery
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDASLQuery.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        id identifier = @"com.apple.kextd";
        
        //AS STRING
        NSLog(@"%@", [DDASLQuery stringSince:0 withIdentifier:identifier andMinLevel:NSNotFound]);
        //OR DICTS :)
        NSLog(@"%@", [DDASLQuery entriesSince:0 withIdentifier:identifier andMinLevel:NSNotFound]);
    }
    return 0;
}

