//
//  main.m
//  DDXMLValidatorDemo
//
//  Created by Dominik Pich on 13/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLValidator.h"

int main(int argc, const char * argv[])
{
    if(argc != 4) {
        NSLog(@"pass two absolute filepaths! first the xml, then the schema file and THEN an int for the schema type (DTD = 0, XSD = 1, RNG = 2)");
        return -1;
    }

    @autoreleasepool {
        //validate
        NSError *error = nil;
        NSURL *xmlURL = [NSURL fileURLWithPath:@(argv[1])];
        NSURL *schemaURL = [NSURL fileURLWithPath:@(argv[2])];
        DDXMLValidatorSchemaType schemaType = @(argv[3]).intValue;
        
        if(![[DDXMLValidator sharedInstace] validateXMLFile:xmlURL
                                                 withSchema:schemaType
                                                 schemaFile:schemaURL
                                                      error:&error]) {
            NSLog(@"Failed to validate xml: %@", error);
            return -2;
        }
        NSLog(@"%@ is valid for %@ (%d)", xmlURL.lastPathComponent, schemaURL.lastPathComponent, schemaType);
    }
    return 0;
}
