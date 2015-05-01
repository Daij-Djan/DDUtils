//
//  DDXMLValidator.h
//
//  Created by Dominik Pich on 11.09.13.
// based mainly on code by Todd Ditchendorfer
//

#import <Foundation/Foundation.h>

static NSString *const KeySchemaType = @"schemaType";

typedef enum {
	DDXMLValidatorSchemaTypeDTD = 0,
	DDXMLValidatorSchemaTypeXSD,
	DDXMLValidatorSchemaTypeRNG
} DDXMLValidatorSchemaType;

@interface DDXMLValidator : NSObject

+ (instancetype)sharedInstace;

- (BOOL)validateXMLData:(NSData *)data
             withSchema:(DDXMLValidatorSchemaType)schema
             schemaFile:(NSURL *)schemaURL
                  error:(NSError **)error;

- (BOOL)validateXMLFile:(NSURL *)xmlURL
             withSchema:(DDXMLValidatorSchemaType)schema
             schemaFile:(NSURL *)schemaURL
                  error:(NSError **)error;

@end
