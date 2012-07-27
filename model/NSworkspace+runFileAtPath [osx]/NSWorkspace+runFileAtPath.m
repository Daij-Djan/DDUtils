//
//  NSWorkspace+runFileAtPath.m
//  Proximity
//
//  Created by Dominik Pich on 7/25/12.
//
//

#import "NSWorkspace+runFileAtPath.h"

NSString *DDRunTask(NSString *command, NSMutableArray *args) {
    //add env if needed
    if(![command hasPrefix:@"./"] && ![command hasPrefix:@"/"]) {
        [args insertObject:command atIndex:0];
        command = @"/usr/bin/env";
    }
    
    //setup task and run it - reading its stdout
    @autoreleasepool {
        NSMutableData *readData = [[NSMutableData alloc] init];
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *fileHandle = [pipe fileHandleForReading];
        NSData *data = nil;
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:command];
        if(args.count) {
            [task setArguments:args];
        }
        [task setStandardOutput: pipe];
        [readData setLength:0];
        [task launch];
        while ((task != nil) && ([task isRunning]))	{
            data = [fileHandle availableData];
            [readData appendData:data];
        }
        return [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@implementation NSWorkspace (runFileAtPath)

- (BOOL)runFileAtPath:(NSString*)path arguments:(NSArray*)args error:(NSError**)pError {
    BOOL isDir = NO;
    BOOL br = NO;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir])
        @throw [NSException exceptionWithName:@"runFileAtPath" reason:@"file doesnt exist" userInfo:nil];
    
    if(isDir) {
        if([[NSWorkspace sharedWorkspace] isFilePackageAtPath:path]) {
            NSRunningApplication *app = [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:path]
                                                          options:NSWorkspaceLaunchWithoutAddingToRecents
                                                                                configuration:@{ NSWorkspaceLaunchConfigurationArguments : args }
                                                            error:pError];
            br = (app!=nil);
        }
        else {
            br = [[NSWorkspace sharedWorkspace] openFile:path];
        
            if(!br && pError) {
                *pError = [NSError errorWithDomain:@"NSWorkspace" code:1 userInfo:@{ NSLocalizedDescriptionKey : @"Failed to open directory" }];
            }
        }
    }
    else if([path.pathExtension isEqualToString:@"scpt"]) {
        NSMutableArray *args2 = [NSMutableArray arrayWithObject:path];
        if(args.count)
            [args2 addObjectsFromArray:args];
        DDRunTask(@"osascript", args2);
    }
    else {
        DDRunTask(path, args.mutableCopy);
    }
    
    return br;
}

@end