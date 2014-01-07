//
//  DDTask.h
//
//  Created by Dominik Pich on 09.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** @file DDTask.h */

@class DDTask;

typedef void (^DDTaskCompletionHandler)(DDTask  *);
typedef BOOL (^DDTaskErrorHandler)(DDTask *, NSTask *, NSUInteger currentTry);

/**
 * 'Replacement' for NSTask that can be run multiple times in any operation / any thread. 
 * It tries to get a successful result N times and returns the result of stdout or nil.
 * one could also say this is a NSTaskManager as it will spawn individual NSTasks
 */
@interface DDTask : NSObject

@property(copy) NSString *launchPath; //the tool's path
@property(retain) NSArray *arguments; //array of String to be passed as file args
@property(retain) NSDictionary *environment; // if not set, use current
@property(copy) NSString *currentDirectoryPath; // if not set, use current
@property(assign) NSUInteger numberOfTries; //defines how many times a task is run

/**
 * runs the setup task and returns the result
 * @warning will call any blocks in the same thread it was run in
 * @warning synchronous method that will block
 * @return the result the task printed to stdout
 */
- (void)run;

@property(readonly) int terminationStatus;//the final result after all tries
@property(readonly) NSTaskTerminationReason terminationReason;//the final result after all tries
@property(readonly) NSTimeInterval durationSpent; //after runing the task (via our run method) this returns the time the task took -- including retries
@property(readonly) NSTimeInterval triesMade; //after runing the task (via our run method) this returns the number of tries it took
@property(readonly) NSData *resultData; //the data as read from the pipe or nil if all tries failed or the tool wasnt run

//blocks as callbacks 
@property(copy) DDTaskCompletionHandler terminationHandler;
@property(copy) DDTaskErrorHandler errorHandler;//passing us and the child task that failed. The block can return YES pr NO depending on whether he wants to procceed or not

/**
 * convenience method to run task and the return value (if it ran) as UTF8 String
 * @param toolpath
 * @param args
 * @param errorHandler
 * @result the 
 */
+ (NSString *)runTaskWithToolPath:(NSString *)toolpath andArguments:(NSArray *)args andErrorHandler:(DDTaskErrorHandler)errorHandler;

@end
