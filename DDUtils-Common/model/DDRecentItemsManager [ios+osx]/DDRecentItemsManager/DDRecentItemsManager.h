//
//  DDRecentItemsManager.m
//
//  Created by Dominik Pich on 9/7/12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//
#import <Foundation/Foundation.h>

/** @file DDRecentItemsManager.h */

/**
 * can save and restore an array of saved search from files or tags. Can also SAVE and APPLY a saved search FROM and TO a query.
 */
@interface DDRecentItemsManager : NSObject

/**
 * the maximum number of items saved by a manager if not set.
 * On OSX the value is gotten from the NSDocumentController, on iOS is set to a constant (currently 10)
 */
+ (NSUInteger)defaultMaxiumSavesCount;

/**
 * the default instance
 */
+ (DDRecentItemsManager*)sharedManager;

/**
 * the maximum number of items saved by this manager.
 * @warning This overrides the default value.
 */
@property(assign) NSUInteger maximumSavesCount;

/**
 * saves the search for the given identifier
 * @param search the search dictionary to save
 * @param identifier the identifier to associate with the search
 * @param pError filled with an NSError when the function fails
 * @return YES or NO on error.
 */
- (BOOL)saveSearch:(NSDictionary*)search forIdentifier:(NSString*)identifier error:(NSError**)pError;

/**
 * returns all saved searches for the given identifier
 * @param identifier the identifier to associate with the search
 * @return an array of search dictionaries
 */
- (NSArray*)savedSearchesforIdentifier:(NSString*)identifier;

@end
