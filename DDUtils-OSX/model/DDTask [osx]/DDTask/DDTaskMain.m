//
//  main.m
//  DDTask
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTask.h"

int main(int argc, const char *argv[])
{

    @autoreleasepool {
        NSString *exe = @"/sbin/md5";
        NSArray *args = [NSArray arrayWithObjects:@"-s", @"hiho", nil];
        
        id res = [DDTask runTaskWithToolPath:exe andArguments:args andErrorHandler:^BOOL(DDTask *p, NSTask *t, NSUInteger try) {
            NSLog(@"Failed, %lu try", try);
            return YES; 
        }];
        NSLog(@"got %@", res);

        //---
        
        exe = @"/sbin/md5";
        args = [NSArray arrayWithObjects:@"-s", @"hiho", nil];

        DDTask *task = [[DDTask alloc] init];
        task.launchPath = exe;
        task.arguments = args;
        task.numberOfTries = 1;

        [task run];

        res = [[NSString alloc] initWithData:task.resultData encoding:NSUTF8StringEncoding];
        NSLog(@"got %@, took %f", res, task.durationSpent);        

        //---
        
        task.terminationHandler = ^(DDTask *t) {
            if (t.terminationStatus==0) {
                id result = [[NSString alloc] initWithData:t.resultData encoding:NSUTF8StringEncoding];
                NSLog(@"dispatched got %@, took %f", result, t.durationSpent);        
            }
        };

        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            [task run];
        });

        //--- SHOULD FAIL
         
        args = [NSArray arrayWithObjects:@"-s", nil];

        task = [[DDTask alloc] init];
        task.launchPath = exe;
        task.arguments = args;
        task.numberOfTries = 3;
        
        task.errorHandler = ^(DDTask *t, NSTask *child, NSUInteger i) {
            NSLog(@"dispatched try %lu failed", i);        
            return YES; ///go on
        };
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            [task run];
        });        
    }
    return 0;
}

