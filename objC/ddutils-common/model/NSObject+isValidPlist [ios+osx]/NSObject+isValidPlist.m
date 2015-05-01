//
//  NSObject+isValidPlist.m
//  myAudi
//
//  Created by Dominik Pich on 22/01/14.
//  Copyright (c) 2014 Sapient GmbH. All rights reserved.
//

#import "NSObject+isValidPlist.h"

@implementation NSObject (isValidPlist)

- (BOOL)isValidPlist {
    return [self analyseObject:self];
}

- (BOOL)analyseObject: (NSObject *) object {
    if ([object isKindOfClass:[NSArray class]]){
        for (NSObject *arrayObject in (NSArray *)object){
            if(![self analyseObject:arrayObject]) {
                return NO;
            }
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]){
        for (NSObject *dictObject in [(NSDictionary *) object allValues]){
            if(![self analyseObject:dictObject]) {
                return NO;
            }
        }
        
        for (NSObject *key in [(NSDictionary *) object allKeys]){
            if (![key isKindOfClass:[NSString class]]) {
                NSLog(@"bad key found: %@", [key description]);
                return NO;
            }
        }
    }
    else if (![object isKindOfClass:[NSString class]] &&
             ![object isKindOfClass:[NSDate class]]&&
             ![object isKindOfClass:[NSData class]]&&
             ![object isKindOfClass:[NSNumber class]]) {
        NSLog(@"noncompliant object found with class: %@", [[object class] description]);
        return NO;
    }
    return YES;
}

@end
