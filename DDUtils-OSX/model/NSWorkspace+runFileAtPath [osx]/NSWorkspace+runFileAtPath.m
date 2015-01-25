//
//  NSWorkspace+runFileAtPath.m
//  Proximity
//
//  Created by Dominik Pich on 7/25/12.
//
//

#import "NSWorkspace+runFileAtPath.h"
#import "DDRunTask.h"

@implementation NSWorkspace (runFileAtPath)

- (BOOL)runFileAtPath:(NSString *)path arguments:(NSArray *)args error:(NSError **)pError {
    BOOL isDir = NO;
    BOOL br = NO;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        br = NO;
        [NSError errorWithDomain:@"NSWorkspace" code:1000 userInfo:@{NSLocalizedDescriptionKey:@"file doesnt exist"}];
    }
    
    if (isDir) {
        if ([[NSWorkspace sharedWorkspace] isFilePackageAtPath:path]) {
            NSRunningApplication *app = [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:path]
                                                          options:NSWorkspaceLaunchWithoutAddingToRecents
                                                                                configuration:@{ NSWorkspaceLaunchConfigurationArguments : args }
                                                            error:pError];
            br = (app!=nil);
        }
        else {
            br = [[NSWorkspace sharedWorkspace] openFile:path];
        
            if (!br && pError) {
                *pError = [NSError errorWithDomain:@"NSWorkspace" code:1 userInfo:@{ NSLocalizedDescriptionKey : @"Failed to open directory" }];
            }
        }
    }
    else if ([path.pathExtension isEqualToString:@"scpt"]) {
        NSMutableArray *args2 = [NSMutableArray arrayWithObject:path];
        if (args.count)
            [args2 addObjectsFromArray:args];
        
        br = (DDRunTask(@"osascript", args2) == 0);
        if (!br && pError) {
            *pError = [NSError errorWithDomain:@"NSWorkspace" code:2 userInfo:@{ NSLocalizedDescriptionKey : @"Failed to run applescript via osascript tool" }];
        }
    }
    else {
        br = (DDRunTask(path, args.mutableCopy) == 0);
        if (!br && pError) {
            *pError = [NSError errorWithDomain:@"NSWorkspace" code:3 userInfo:@{ NSLocalizedDescriptionKey : @"Failed to run shellscript or executable" }];
        }
    }
    
    return br;
}

@end