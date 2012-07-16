//
//  main.m
//  DDEmbeddedDataReader
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEmbeddedDataReader.h"

#include <mach-o/dyld.h>	/* _NSGetExecutablePath */

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        //plist 1
        id plist = [DDEmbeddedDataReader defaultEmbeddedPlist:nil];
        NSLog(@"plist: %@", plist);
        
        //text data
        NSData *data = [DDEmbeddedDataReader embeddedDataFromSection:@"__testData" error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"text: %@", string);

        //image data
        data = [DDEmbeddedDataReader embeddedDataFromSegment:@"__IMG" inSection:@"__testImg" error:nil];
        NSLog(@"image data no of bytes: %lu", data.length);

        //plist 1 again - (this time passing the segment,section and executable)
        uint32_t size = MAXPATHLEN*2;
        char ch[size];
        _NSGetExecutablePath(ch, &size);
        data = [DDEmbeddedDataReader dataFromSegment:@"__TEXT" inSection:@"__info_plist" ofExecutableAtPath:[NSString stringWithUTF8String:ch] error:nil];
        plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
        NSLog(@"plist again: %@", plist);
}
    return 0;
}

