//
//  M42ReadLog.h
//  Medikamente
//
//  Created by Dominik Pich on 2/27/11.
//  Copyright 2011 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDASLQuery : NSObject
{
}

@property(nonatomic, assign) double seconds;
@property(nonatomic, copy) NSString* identifier;
@property(nonatomic, assign) int minimumLogLevel;
@property(nonatomic, assign) BOOL flagForDicts; //array of dicts / string
//many more attributes are thinkable

- (id)execute;

- (id)initSince:(double)seconds withIdentifier:(NSString*)ident andMinLevel:(int)level asStringOrDictionarys:(BOOL)flagForDicts; //array of dicts / string

//---

+ (NSArray*)entriesSince:(double)seconds
           withIdentifier:(NSString*)ident
             andMinLevel:(int)level;
+ (NSString*)stringSince:(double)seconds
          withIdentifier:(NSString*)ident
             andMinLevel:(int)level;

//many more thinkable, write can be done too
+(NSArray*)appLogEntriesForLastDay;
+(NSString*)appLogStringForLastHour;


@end
