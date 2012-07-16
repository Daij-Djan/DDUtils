//
//  DDEmbeddedDataReader.h
//  cocoa-interpreter
//
//  Created by Dominik Pich on 7/15/12.
//  Copyright (c) 2012 info.pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDEmbeddedDataReader : NSObject

//"?", "?"
+ (NSData*)dataFromSegment:(NSString*)segment inSection:(NSString*)section ofExecutableAtURL:(NSURL*)url error:(NSError**)error;
+ (NSData*)dataFromSegment:(NSString*)segment inSection:(NSString*)section ofExecutableAtPath:(NSString*)path error:(NSError**)error;
+ (NSData*)embeddedDataFromSegment:(NSString*)segment inSection:(NSString*)section error:(NSError**)error;

//"__TEXT", "?"
+ (NSData*)dataFromSection:(NSString*)section ofExecutableAtURL:(NSURL*)url error:(NSError**)error;
+ (NSData*)dataFromSection:(NSString*)section ofExecutableAtPath:(NSString*)path error:(NSError**)error;
+ (NSData*)embeddedDataFromSection:(NSString*)section error:(NSError**)error;

//"__TEXT", "__info_plist"
+ (id)defaultPlistOfExecutableAtURL:(NSURL*)url error:(NSError**)error;
+ (id)defaultPlistOfExecutableAtPath:(NSString*)path error:(NSError**)error;
+ (id)defaultEmbeddedPlist:(NSError**)error;
@end
