/**
@file      NSFileManager+DataProtection.h
@author    Dominik Pich
@date      2012-10-19
*/
#import <Foundation/Foundation.h>

@interface NSFileManager (DataProtection)

//sets the protection class to NSFileProtectionComplete
- (BOOL)setFullDataProtectionForItemAtPath:(NSString *)filePath
                                     error:(NSError *__autoreleasing*)error;

//can be null for NSFileProtectionNone
- (BOOL)setDataProtection:(NSString*)protection
            forItemAtPath:(NSString *)filePath
                    error:(NSError *__autoreleasing*)error;

@end
