//
//  main.m
//  NSString+ValidateEmail
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ValidateEmail.h"

int main(int argc, const char *argv[])
{

    @autoreleasepool {
        id e = @"dominik@pich.info";
        BOOL v = [e isValidEmailAddress];
        NSLog(@"%@ is %@ email.", e, v?@"a valid":@"an invalid");

        e = @"dominik.pich@info";
        v = [e isValidEmailAddress];
        NSLog(@"%@ is %@ email.", e, v?@"a valid":@"an invalid");

        e = @"d@ominik.pich.info";
        v = [e isValidEmailAddress];
        NSLog(@"%@ is %@ email.", e, v?@"a valid":@"an invalid");

        e = @"dß@ominik.pich.info";
        v = [e isValidEmailAddress];
        NSLog(@"%@ is %@ email.", e, v?@"a valid":@"an invalid");

    }
    return 0;
}

