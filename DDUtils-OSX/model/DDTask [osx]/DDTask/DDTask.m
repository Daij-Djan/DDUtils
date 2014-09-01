//
//  DDTask.m
//
//  Created by Dominik Pich on 09.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDTask.h"

@interface DDTask ()

@property(readwrite) int terminationStatus;
@property(readwrite) NSTaskTerminationReason terminationReason;
@property(readwrite) NSTimeInterval durationSpent;
@property(readwrite) NSTimeInterval triesMade;
@property(readwrite) NSData *resultData;

@end

@implementation DDTask

@synthesize launchPath; //the tool's path
@synthesize arguments; //array of String to be passed as file args
@synthesize environment; // if not set, use current
@synthesize currentDirectoryPath; // if not set, use current
@synthesize numberOfTries; //defines how many times a task is run

@synthesize terminationStatus;//the final result after all tries
@synthesize terminationReason;//the final result after all tries
@synthesize durationSpent; //after runing the task (via our run method) this returns the time the task took -- including retries
@synthesize triesMade; //after runing the task (via our run method) this returns the number of tries it took
@synthesize resultData; //the data as read from the pipe or nil if all tries failed or the tool wasnt run

@synthesize terminationHandler;
@synthesize errorHandler;

- (void)run {
    NSUInteger tries = 0;
    int aTerminationStatus = 0;
    NSTaskTerminationReason aTerminationReason = 0;
    NSString *name = [self.launchPath lastPathComponent];
    NSMutableData *readData = [[NSMutableData alloc] init];
    NSTimeInterval aDuration = 0;

    do {
//        NSLog(@"%lu. try tu run %@", tries + 1, name);

        @autoreleasepool {
            //prepare pipe
            NSPipe *pipe = [NSPipe pipe];
            NSFileHandle *fileHandle = [pipe fileHandleForReading];
            NSData *data = nil;
            
            //setup tool (cant run same task twice
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:self.launchPath];
            if (self.arguments.count)
                [task setArguments:self.arguments];
            [task setStandardOutput:pipe];

            if(currentDirectoryPath)
                [task setCurrentDirectoryPath:currentDirectoryPath];
            
            NSDate *before = [NSDate date];
            
            //launch & read stdout
            [readData setLength:0];
            [task launch];
            while ((task != nil) && ([task isRunning]))	{                
                data = [fileHandle availableData];
                [readData appendData:data];
            }            

            NSDate *after = [NSDate date];
            aDuration += [after timeIntervalSinceDate:before];

            aTerminationStatus = [task terminationStatus];
            aTerminationReason = [task terminationReason];
            
            //call error block if try failed
            if (aTerminationStatus!=0) {
                if (self.errorHandler) {
                    if (!self.errorHandler(self, task, tries + 1)) {
                        NSLog(@"Cancel running of %@ after %lu tries.", name, tries + 1);
                        break;
                    }
                }
            }
            
            [fileHandle closeFile];
            
            task = nil;//! so no notification comes after we are done
            tries++;
        }
    } while( aTerminationStatus!=0 && tries < self.numberOfTries);

    //set result
    self.terminationStatus = aTerminationStatus;
    self.terminationReason = aTerminationReason;
    self.durationSpent = aDuration;
    self.triesMade = tries;
    self.resultData = readData;
    
    //call completion block
    if (self.terminationHandler) {
        self.terminationHandler(self);
    }
}

#pragma mark convenience

+ (NSString *)runTaskWithToolPath:(NSString *)toolpath andArguments:(NSArray *)args andErrorHandler:(DDTaskErrorHandler)errorHandler {
    return [self runTaskWithToolPath:toolpath andArguments:args currentDirectoryPath:nil andErrorHandler:errorHandler];
}

+ (NSString *)runTaskWithToolPath:(NSString *)toolpath andArguments:(NSArray *)args currentDirectoryPath:(NSString*)currentDirectoryPath andErrorHandler:(DDTaskErrorHandler)errorHandler {
    DDTask *task = [[DDTask alloc] init];
    task.launchPath = toolpath;
    task.arguments = args;
    task.errorHandler = errorHandler;
    task.currentDirectoryPath = currentDirectoryPath;
    [task run];
    
    if (task.terminationStatus==0) {
        return [[NSString alloc] initWithData:task.resultData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
