//
//  NSString+advancedSplit.h
//  Project
//
//  Created by Dominik Pich on 10.07.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (advancedSplit)

- (NSArray*)componentsSeparatedByStringIgnoringAnythingInParanthesesOrAnyingStartingWithDigit:(NSString*)string;

@end
