//
//  main.m
//  DDDChecksum
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDChecksum.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        id str = @"Hello World";
        id d = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        id s = [DDChecksum checksum:DDChecksumTypeMD5 forData:d];
        id s2 = [DDChecksum checksum:DDChecksumTypeSha512 forData:d];
        
        NSLog(@"%@:\nmd5 %@\nsha 512: %@", str, s, s2);
    }
    return 0;
}

