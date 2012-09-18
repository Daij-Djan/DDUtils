//
//  main.m
//  DDDChecksum
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DDDump.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSLog(@"%@", [[NSFileManager defaultManager] dump]);
    }
    return 0;
}

