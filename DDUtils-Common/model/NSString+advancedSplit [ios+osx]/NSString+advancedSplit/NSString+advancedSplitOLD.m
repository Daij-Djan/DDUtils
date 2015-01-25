//
//  NSString+advancedSplit.m
//  Project
//
//  Created by Dominik Pich on 10.07.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "NSString+advancedSplit.h"


@implementation NSString (advancedSplit)

//this method is not really 'complete'. It only suits my needs!
//it also uses a dummy char to do the real spliting which may not be part of the string

#define MOD_CHAR '∆'
#define MOD_STRING @"∆"

- (NSArray*)componentsSeparatedByStringIgnoringAnythingInParanthesesOrAnyingStartingWithDigit:(NSString*)string {
	NSMutableString *copy = [self mutableCopy];
	
	NSUInteger i, c=[copy length], lengthOfString=[string length];
	char ch, firstCharOfString = [string characterAtIndex:0];
	BOOL ignore = NO;
	NSRange searchRange = NSMakeRange(0, lengthOfString);

	NSMutableString *modifiedString = [string mutableCopy];
	for(i=0;i<lengthOfString;i++) {
		[modifiedString appendString:MOD_STRING];
	}
		
	for(i=0;i<c;i++) {
		ch = [copy characterAtIndex:i];

		if(!ignore) {
			if(ch == firstCharOfString) {
				searchRange.location = i;
				if([[copy substringWithRange:searchRange] isEqualToString:string]) {
					//even if the string matches, if the next one is a digit, we dont separate the string
					ch = [copy characterAtIndex:i+lengthOfString];
					if(ch < '0' || ch > '9') {
						[copy replaceCharactersInRange:searchRange withString:modifiedString];
					}
				}
				
			}
			else if(ch == '(') {
				ignore = YES;
			}
		}
		else {
			if(ch == ')') {
				ignore = NO;
			}
		}
	}
			
	NSArray *array = [copy componentsSeparatedByString:modifiedString];
	return array;
}

@end
