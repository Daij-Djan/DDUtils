//
//  main.m
//  M42ASLQuery
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXcodeProjectFile.h"

int main(int argc, const char *argv[])
{
    if (argc != 2) {
        NSLog(@"usage: %s %%PATH_TO_XCODEPROJ%%", argv[0]);
        return -1;
    }

    @autoreleasepool {
        NSString *path = @(argv[1]);
        NSError *error = nil;
        
        DDXcodeProjectFile *file = [DDXcodeProjectFile xcodeProjectFileWithPath:path error:&error];
        
        if (!file) {
            NSLog(@"%@", error);
            return -2;
        }
        
        NSLog(@"%@\%@\%@\%@", file.projectRoot, file.name, file.company, file.developmentRegion);
    }
    return 0;
}

