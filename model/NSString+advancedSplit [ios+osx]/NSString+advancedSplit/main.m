//
//  main.m
//  NSString+advancedSplit
//
//  Created by Dominik Pich on 7/24/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+advancedSplit.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSString *testShellLineQuoted = @"ls \"/Library/Application Support\"";
        NSString *testShellLineEscaped = @"ls /Library/Application\\ Support";
        NSString *testShellLineQuotedAndEscaped = @"ls \"/Library/Application\\ Support\"";
        
        //ignore quotes
        NSArray *comps = [testShellLineQuoted componentsSeparatedByString:@" " options:0];
        NSLog(@"%@ = %lu parts with no options: %@", testShellLineQuoted, comps.count, comps);
        comps = [testShellLineQuoted componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreQuotedString];
        NSLog(@"%@ = %lu parts ignoring quotes: %@", testShellLineQuoted, comps.count, comps);
        comps = [testShellLineQuoted componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreQuotedString|DDAdvancedSplitOptionsRemoveQuotesAndEscapes];
        NSLog(@"%@ = %lu parts ignoring and removing quotes: %@", testShellLineQuoted, comps.count, comps);

        //ignore escapes
        comps = [testShellLineEscaped componentsSeparatedByString:@" " options:0];
        NSLog(@"%@ = %lu parts with no options: %@", testShellLineEscaped, comps.count, comps);
        comps = [testShellLineEscaped componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreEscapedString];
        NSLog(@"%@ = %lu parts ignoring escapes: %@", testShellLineEscaped, comps.count, comps);
        comps = [testShellLineEscaped componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreEscapedString | DDAdvancedSplitOptionsRemoveQuotesAndEscapes];
        NSLog(@"%@ = %lu parts ignoring and removing escapes: %@", testShellLineEscaped, comps.count, comps);

        //ignore quotes AND escapes
        comps = [testShellLineQuotedAndEscaped componentsSeparatedByString:@" " options:0];
        NSLog(@"%@ = %lu parts with no options: %@", testShellLineQuotedAndEscaped, comps.count, comps);
        comps = [testShellLineQuotedAndEscaped componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreQuotedString | DDAdvancedSplitOptionsIgnoreEscapedString];
        NSLog(@"%@ = %lu parts ignoring quotes & escapes: %@", testShellLineQuotedAndEscaped, comps.count, comps);
        comps = [testShellLineEscaped componentsSeparatedByString:@" " options:DDAdvancedSplitOptionsIgnoreQuotedString |DDAdvancedSplitOptionsIgnoreEscapedString | DDAdvancedSplitOptionsRemoveQuotesAndEscapes];
        NSLog(@"%@ = %lu parts ignoring and removing quotes & escapes: %@", testShellLineQuotedAndEscaped, comps.count, comps);
    }
    return 0;
}

