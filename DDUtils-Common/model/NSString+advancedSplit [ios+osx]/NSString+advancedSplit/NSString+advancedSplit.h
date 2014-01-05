//
//  NSString+advancedSplit.h
//  Project
//
//  Created by Dominik Pich on 10.07.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _DDAdvancedSplitOptions {
    DDAdvancedSplitOptionsIgnoreQuotedString = 2,
    DDAdvancedSplitOptionsIgnoreEscapedString = 4,
    DDAdvancedSplitOptionsRemoveQuotesAndEscapes = 8
} DDAdvancedSplitOptions;

@interface NSString (advancedSplit)

//this method uses a dummy char to do the real spliting which may not be part of the string: ∆

//also characterAtIndex is used and the splitting is not width-independent

//lastly this method will not deal well with quotes or escapes as the first char of the seperator depending on the options

- (NSArray*)componentsSeparatedByString:(NSString*)string options:(DDAdvancedSplitOptions)options;

@end
