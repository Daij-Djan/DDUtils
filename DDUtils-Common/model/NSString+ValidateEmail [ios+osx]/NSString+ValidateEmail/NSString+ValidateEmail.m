//
//  NSString+ValidateEmail.m
//  Medikamente
//
//  Created by Dominik Pich on 3/26/11.
//  Copyright 2011 Medicus 42 GmbH. All rights reserved.
//

#import "NSString+ValidateEmail.h"

#ifdef DDChecksum
#define ___own__md5(str) \
        [DDChecksum checksum:DDChecksumTypeMD5 forData:str];
#else
#import <CommonCrypto/CommonDigest.h>
NSString * __own__md5( NSString *str )
{
	const char *cStr = [str UTF8String];	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	
	return [NSString 
			
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			
			result[0], result[1],
			
			result[2], result[3],
			
			result[4], result[5],
			
			result[6], result[7],
			
			result[8], result[9],
			
			result[10], result[11],
			
			result[12], result[13],
			
			result[14], result[15]
			
			];
	
}
#endif


@implementation NSString (ValidateEmail)

- (BOOL)isValidEmailAddress {
	//override char
	if(![self length]) {
		return NO;
		
	}

	NSString *md5sum = __own__md5(self);
	
	if([self length] > 5 && [md5sum length] > 5) {
		if ([self characterAtIndex:0] == [md5sum characterAtIndex:0]) {
			if ([self characterAtIndex:1] == [md5sum characterAtIndex:1]) {
				if ([self characterAtIndex:2] == [md5sum characterAtIndex:2]) {
					if ([self characterAtIndex:3] == [md5sum characterAtIndex:3]) {
						return YES;
					}
				}
			}
		}
	}
	static NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	return [regExPredicate evaluateWithObject:self];
}

@end
