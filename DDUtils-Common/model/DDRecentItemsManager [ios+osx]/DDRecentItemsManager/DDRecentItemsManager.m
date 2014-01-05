//
//  DDRecentItemsManager.m
//
//  Created by Dominik Pich on 9/7/12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//
#import "DDRecentItemsManager.h"

#if TARGET_OS_IPHONE
#define maximumRecentDocumentCount 10
#else
#import <Cocoa/Cocoa.h>
#endif

@implementation DDRecentItemsManager

+ (NSUInteger)defaultMaxiumSavesCount {
#if TARGET_OS_IPHONE
    return maximumRecentDocumentCount;
#else
    return [[NSDocumentController sharedDocumentController] maximumRecentDocumentCount];
#endif
}

+ (DDRecentItemsManager*)sharedManager {
    static DDRecentItemsManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if(self)
        self.maximumSavesCount = [[self class] defaultMaxiumSavesCount];
    return self;
}

- (BOOL)saveSearch:(NSDictionary*)search forIdentifier:(NSString*)identifier error:(NSError**)pError {
    NSParameterAssert(search);
    NSParameterAssert(identifier);

    //Error handling
    //TODO but uncritical
    
    //build path
    NSArray *supports = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *dir = supports[0];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *file = [dir stringByAppendingPathComponent:identifier];
    
    //open plist
    NSMutableDictionary *plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:file]
                                                                  mutabilityOption:NSPropertyListMutableContainers
                                                                            format:nil
                                                                  errorDescription:nil];
    if(!plist)
        plist = [NSMutableDictionary dictionaryWithCapacity:1];
    
    //get array
    NSMutableArray *saves = [plist objectForKey:identifier];
    if(![saves isKindOfClass:[NSMutableArray class]]) {
        saves = [NSMutableArray arrayWithCapacity:1];
        [plist setObject:saves forKey:identifier];
    }
    
    //get rid of duplicates
    while([saves containsObject:search]) {
        [saves removeObject:search];
    }
    
    //insert
    [saves addObject:search];
    
    //if bigger than maximum, trim
    if(saves.count > self.maximumSavesCount) {
        NSUInteger l = self.maximumSavesCount;
        NSLog(@"trim to %lu",(unsigned long)l);
        NSUInteger c = saves.count - self.maximumSavesCount;
        NSArray *newsaves = [saves subarrayWithRange:NSMakeRange(c, l)];
        [plist setObject:newsaves forKey:identifier];
    }
    
    //write
    NSData *data = [NSPropertyListSerialization dataFromPropertyList:plist
                                                              format:NSPropertyListXMLFormat_v1_0
                                                    errorDescription:nil];
    return [data writeToFile:file atomically:YES];
}

- (NSArray*)savedSearchesforIdentifier:(NSString*)identifier {
    NSParameterAssert(identifier);
    
    //Error handling
    //TODO but uncritical
    
    //build path
    NSArray *supports = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *dir = supports[0];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *file = [dir stringByAppendingPathComponent:identifier];
    
    //open plist
    NSMutableDictionary *plist = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:file]
                                                                  mutabilityOption:NSPropertyListImmutable
                                                                            format:nil
                                                                  errorDescription:nil];
    NSArray *saves = [plist objectForKey:identifier];
    return [saves isKindOfClass:[NSArray class]] ? saves : nil;
}

@end