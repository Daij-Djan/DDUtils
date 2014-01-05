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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //DOESNT WORK when sandboxed, works if not
    //also if identifier == own process or just using facility_key
    
    id identifier = @"daijdjan"; //TODO real sender name

    NSLog(@"str: %@", [DDASLQuery stringSince:24*60*60 withIdentifier:identifier andMinLevel:NSNotFound]);
    [NSApp terminate:nil];
}

@end
