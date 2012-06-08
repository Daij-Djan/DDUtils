//
//  NSFileManager+Count.h
//  Autorunner
//
//  Created by Dominik Pich on 2/18/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSFileManager (count) 

- (NSInteger) countOfFilesInDirectory:(NSString *) inPath;

@end
