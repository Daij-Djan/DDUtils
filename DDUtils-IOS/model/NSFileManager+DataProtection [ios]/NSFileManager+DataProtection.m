/**
@file      NSFileManager+DataProtection.m
@author    Dominik Pich
@date      2014-06-05
*/
#import "NSFileManager+DataProtection.h"

@implementation NSFileManager (DataProtection)

- (BOOL)setFullDataProtectionForItemAtPath:(NSString *)filePath error:(NSError *__autoreleasing*)error {
    return [self setDataProtection:NSFileProtectionCompleteUnlessOpen forItemAtPath:filePath error:error];
}

- (BOOL)setDataProtection:(NSString*)protection forItemAtPath:(NSString *)filePath error:(NSError *__autoreleasing*)error {
    if(!protection) {
        protection = NSFileProtectionNone;
    }
    
    NSDictionary *fileAttributes = @{NSFileProtectionKey: protection};
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:filePath error:error]) {
        return NO;
    }
	return YES;
}

@end
