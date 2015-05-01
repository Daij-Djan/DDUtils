//
//  DDAppDelegate.m
//  SandboxedDemo
//
//  Created by Dominik Pich on 9/13/12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import "DDAppDelegate.h"
#import "DDASLQuery.h"

@implementation DDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification  *)aNotification {
    //DOESNT WORK when sandboxed, works if not
    //also if identifier == own process or just using facility_key
    
    id identifier = @"daijdjan"; //TODO real sender name

    NSTimeInterval t = 60 * 60 * 24;    
    NSLog(@"str: %@", [DDASLQuery stringSince:t withIdentifier:identifier andMinLevel:NSNotFound]);
    [NSApp terminate:nil];
}

@end
