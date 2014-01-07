//
//  NSString+Entities.h
//  mediscript
//
//  Created by Dominik Pich on 13.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Entities)

- (NSString *)stringByEscapingXmlEntities;
- (NSString *)stringByUnescapingXmlEntities;

@end
