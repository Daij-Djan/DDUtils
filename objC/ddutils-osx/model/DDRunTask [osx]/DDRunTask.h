//
//  DDRunTask.c
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/15/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//
#import <Foundation/Foundation.h>

//the ARGUMENTS can be:
// - NSString objects
// - Anything that responds to the method 'path' (e.g. urls)
// - anything else that translates to string ;)
// - NSArray objects that contain args
NSString *DDRunTask(NSString *command, ...);

//if you really care about the working dir and the exit status.
//The arguments work the same as with runTask
int DDRunTaskExt(NSString *cwd, NSString **output, NSString *command, ...);