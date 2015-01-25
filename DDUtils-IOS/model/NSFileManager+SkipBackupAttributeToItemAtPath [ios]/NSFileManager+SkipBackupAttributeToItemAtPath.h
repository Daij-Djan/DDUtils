//
//  NSFileManager+SkipBackupAttributeToItemAtPath.h
//  Created by Dominik Pich on 17/09/14.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SkipBackupAttributeToItemAtPath)

//if filePathString specifies a folder, IOS excludes contents of the folder recursivly
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL;

- (BOOL)removeSkipBackupAttributeToItemAtPath:(NSString *)filePathString;
- (BOOL)removeSkipBackupAttributeToItemAtURL:(NSURL *)fileURL;

@end
