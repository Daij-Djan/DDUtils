//
//  NSWorkspace+IconBadging.m
//
//  Created by Dominik Pich on 20.8.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//  partly based on an initial implementation for doo from 2011
//

#import <Foundation/Foundation.h>

/** NSWorkspace+IconBadging.h **/

@interface NSWorkspace (IconBadging)

/**
 sets an file's icon to a badged version.
 @param badge
 @param path
 */
- (void)setIconBadge:(NSString*)badgePath atFilePath:(NSString*)filePath;

/**
 remove a file's icon badge
 @param path
 */
- (void)removeIconBadgeAtFilePath:(NSString*)filePath;

@end