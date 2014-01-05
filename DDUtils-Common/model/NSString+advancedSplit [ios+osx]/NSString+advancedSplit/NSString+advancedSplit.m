//
//  NSString+advancedSplit.m
//  Project
//
//  Created by Dominik Pich on 10.07.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "NSString+advancedSplit.h"


@implementation NSString (advancedSplit)

#define MOD_STRING @"∆"
- (NSArray*)componentsSeparatedByString:(NSString*)string options:(DDAdvancedSplitOptions)options
{
    //gather infos for searching
	NSMutableString *copy = self.mutableCopy;
	NSUInteger i=0, c= copy.length;

    //get a copy of the input string and make a 'delimiter' of the same length
    NSUInteger lengthOfInputString=[string length];
	NSMutableString *modifiedString = [NSMutableString stringWithCapacity:lengthOfInputString];
	for(i=0;i<lengthOfInputString;i++) {
		[modifiedString appendString:MOD_STRING];
	}

    //check options
    BOOL ignoreQuotes = (options & DDAdvancedSplitOptionsIgnoreQuotedString) ==DDAdvancedSplitOptionsIgnoreQuotedString;
    BOOL ignoreEscapes = (options & DDAdvancedSplitOptionsIgnoreEscapedString) ==DDAdvancedSplitOptionsIgnoreEscapedString;
    BOOL cleanupString = (options & DDAdvancedSplitOptionsRemoveQuotesAndEscapes) == DDAdvancedSplitOptionsRemoveQuotesAndEscapes;
   BOOL inQuote = NO;
    BOOL isEscaped = NO;
    
	for(i=0;i<c;i++) {
		unichar ch = [copy characterAtIndex:i];

        //check for quotation if it is wished :)
        if(ignoreQuotes) {
            if(ch=='"') {
                if(inQuote) {
                    inQuote = NO;
                }
                else {
                    inQuote = YES;
                }
                
                if(cleanupString) {
                    [copy deleteCharactersInRange:NSMakeRange(i, 1)];
                    i--;
                    c--;
                }
                
                continue;
            }
        }
        
        //check for escapes
        if(ignoreEscapes) {
            if(!isEscaped) {
                //got escape dont check next
                if (ch == '\\') {
                    isEscaped = YES;

                    if(cleanupString) {
                        [copy deleteCharactersInRange:NSMakeRange(i, 1)];
                        i--;
                        c--;
                    }
                    
                    continue;
                }
            }
        }

        //check for substring
        if(!inQuote && !isEscaped) {
            NSRange r = NSMakeRange(i, MIN(c-(i+1), lengthOfInputString));
            NSString *substring = [copy substringWithRange:r];
            if([substring isEqualToString:string]) {
                [copy replaceCharactersInRange:r withString:modifiedString];
            }
        }
        
        isEscaped = NO;
	}

	return [copy componentsSeparatedByString:modifiedString];
}

@end
