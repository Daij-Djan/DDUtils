//
//  NSString+Entities.m
//  mediscript
//
//  Created by Dominik Pich on 13.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import "NSString+Entities.h"
#import "NSMutableString+Entities.h"


@implementation NSString (Entities)

- (NSString*)stringByEscapingXmlEntities {
	NSMutableString *copy = [self mutableCopy];
	[copy escapeXmlEntities];
	return [copy autorelease];
}

- (NSString*)stringByUnescapingXmlEntities {
	NSMutableString *copy = [self mutableCopy];
	[copy unescapeXmlEntities];
	return [copy autorelease];
}

@end
