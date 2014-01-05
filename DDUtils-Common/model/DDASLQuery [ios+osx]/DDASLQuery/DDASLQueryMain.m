//
//  main.m
//  M42ASLQuery
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDASLQuery.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        id identifier = @"daijdjan"; //TODO real sender name
        
        //AS STRING
        NSLog(@"str: %@", [DDASLQuery stringSince:24*60*60 withIdentifier:identifier andMinLevel:NSNotFound]);
//        //OR DICTS :)
        NSLog(@"dict %@", [DDASLQuery entriesSince:0 withIdentifier:identifier andMinLevel:NSNotFound]);
    }
    return 0;
}

