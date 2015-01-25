//
//  NSFileManager+SkipBackupAttributeToItemAtPath.m
//  Created by Dominik Pich on 17/09/14.
//

#import "NSFileManager+SkipBackupAttributeToItemAtPath.h"

@implementation NSFileManager (SkipBackupAttributeToItemAtPath)

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL *fileURL = [NSURL fileURLWithPath:filePathString];
    assert(fileURL);

    return [self addSkipBackupAttributeToItemAtURL:fileURL];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL {
    assert([[NSFileManager defaultManager]
            fileExistsAtPath: [fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
    return success;
}

//---

- (BOOL)removeSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL *fileURL = [NSURL fileURLWithPath:filePathString];
    assert(fileURL);
    
    return [self removeSkipBackupAttributeToItemAtURL:fileURL];
}

- (BOOL)removeSkipBackupAttributeToItemAtURL:(NSURL *)fileURL {
    assert([[NSFileManager defaultManager]
            fileExistsAtPath: [fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool:NO]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
    return success;
}

@end
