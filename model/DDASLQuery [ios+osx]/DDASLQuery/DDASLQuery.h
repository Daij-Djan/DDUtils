//
//  M42ReadLog.h
//  Medikamente
//
//  Created by Dominik Pich on 2/27/11.
//  Copyright 2011 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/** @file DDASLQuery.h */

/**
 * this object wraps ONE query against the built-in OS ASL log library.
 * The query is mutable and can be executed many times.
 * @warning the results of executes are not cached.
 * @warning this class is not feature-complete and only reflects part of the ASL C library
 */
@interface DDASLQuery : NSObject
{
}

/**
 * The maximum number of seconds to go back in time
 * @warning if nil, any message EVER matches 
 */
@property(nonatomic, assign) NSTimeInterval seconds;

/**
 * the identifier the log entries must have
 * Typically this is a processes name (often, same as executable)
 * @warning if nil, any message matches
 * @warning this class is limited 
 */
@property(nonatomic, copy) NSString* identifier;

/**
 * the minimum 'severity' that messages must have to be matched.
 * @warning It is ignored only when set to NSNotFound
 */
@property(nonatomic, assign) NSInteger minimumLogLevel;

/**
 * executes the asl query previously set up.
 * @param returnDicts the class can return the results in two ways. Either as individual dictionaries (@see asl.h for keys) or as one string where each log message is one line
 * @return an array of dictionaries or one string with N lines
 */
- (id)execute:(BOOL)returnDicts; //array of dicts / string;

/**
 * inits the query directly setting the search parameters
 * @param seconds The maximum number of seconds to go back in time
 * @param ident the identifier the log entries must have
 * @param level the minimum 'severity' that messages must have to be matched.
 * @return self or nil
 */
- (id)initSince:(NSTimeInterval)seconds
 withIdentifier:(NSString*)ident 
    andMinLevel:(NSInteger)level;

//---

/**
 * directly inits and executes a Query to ASL. It returns Dicitionaries for the entries that match
 * @param seconds The maximum number of seconds to go back in time
 * @param ident the identifier the log entries must have
 * @param level the minimum 'severity' that messages must have to be matched.
 * @return an array of dictionaries (@see asl.h for keys)
 */
+ (NSArray*)entriesSince:(NSTimeInterval)seconds
           withIdentifier:(NSString*)ident
             andMinLevel:(NSInteger)level;

/**
 * directly inits and executes a Query to ASL. It returns Dicitionaries for the entries that match
 * @param seconds The maximum number of seconds to go back in time
 * @param ident the identifier the log entries must have
 * @param level the minimum 'severity' that messages must have to be matched.
 * @return one string where each log message is one line
 */
+ (NSString*)stringSince:(NSTimeInterval)seconds
          withIdentifier:(NSString*)ident
             andMinLevel:(NSInteger)level;

//many more thinkable, write can be done too
//'DEMO'

/**
 * directly inits and executes a Query to ASL. It returns Dicitionaries for the entries with an identifier equal to current CFBundleName and which were logged in the last 24h
 * @return an array of dictionaries (@see asl.h for keys)
 */
+(NSArray*)appLogEntriesForLastDay;

/**
 * directly inits and executes a Query to ASL. It returns Dicitionaries for the entries with an identifier equal to current CFBundleName and which were logged in the last hour
 * @return one string where each log message is one line
 */
+(NSString*)appLogStringForLastHour;

@end
