//
//  M42ReadLog.m
//  Medikamente
//
//  Created by Dominik Pich on 2/27/11.
//  Copyright 2011 Medicus 42 GmbH. All rights reserved.
//

#import "DDASLQuery.h"
#include <asl.h>

@implementation DDASLQuery

@synthesize seconds;
@synthesize identifier;
@synthesize minimumLogLevel;

- (id)execute:(BOOL)returnDicts { //array of dicts / string;
	aslmsg query = asl_new(ASL_TYPE_QUERY);
	
	//criteria
	if(identifier) {
		asl_set_query(query, ASL_KEY_SENDER, [identifier UTF8String], ASL_QUERY_OP_EQUAL);
	}
	
	if(seconds) {
		NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-seconds]; 
		NSString *logSince = [NSString stringWithFormat:@"%.0f", [startDate timeIntervalSince1970]];
		asl_set_query(query, ASL_KEY_TIME, [logSince UTF8String], ASL_QUERY_OP_GREATER_EQUAL); 
	}
	
	if(minimumLogLevel != NSNotFound) {
		NSString *minLevel = nil;//[NSString stringWithFormat:@"%u", (flag ? ASL_LEVEL_ERR : ASL_LEVEL_NOTICE)];	
		asl_set_query(query, ASL_KEY_LEVEL, [minLevel UTF8String], ASL_QUERY_OP_LESS_EQUAL | ASL_QUERY_OP_NUMERIC);
	}
	
	//read
	aslresponse r = asl_search(NULL, query);
	asl_free(query);
	
	NSMutableArray *dicts;
	NSMutableString *string;
	if(returnDicts) {
		dicts = [NSMutableArray arrayWithCapacity:100];
		string = nil;
	}
	else {
		string = [NSMutableString stringWithCapacity:1000];
	}
    
	//convert each
	aslmsg m = NULL;
	while (NULL != (m = aslresponse_next(r)))
	{
		int i;
		const char *key;
		const char *val;
		const char *sender = NULL;
		const char *message = NULL;
		const char *time = NULL;

		NSMutableDictionary *dict;
		if(returnDicts) {
			dict = [[NSMutableDictionary alloc] init];
		}
		
		for (i = 0; (NULL != (key = asl_key(m, i))); i++)
		{
			if(returnDicts) {
				val = asl_get(m, key);
				
				[dict setObject:[NSString stringWithCString:val encoding:NSUTF8StringEncoding] 
						 forKey:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
			}
			else {
				if(strcmp(key, ASL_KEY_SENDER)==0) {
					sender = asl_get(m, key);
				}
				else if(strcmp(key, ASL_KEY_MSG)==0) {
					message = asl_get(m, key);
				}
				else if(strcmp(key, ASL_KEY_TIME)==0) {
					time = asl_get(m, key);
				}
			}

		}

		if(returnDicts) {
			[dicts addObject:[NSDictionary dictionaryWithDictionary:dict]];
			//[dict release];
		}
		else {
			if(sender && message && time)
				[string appendFormat:@"[%@] %s: %s\n", [NSDate dateWithTimeIntervalSince1970:atof(time)], sender, message];
			else
				[string appendString:@"???\n"];
		}
	}
	aslresponse_free(r);	
	
	if(returnDicts) {
		return dicts;
	}
	else {
		return string;
	}
}

- (id)initSince:(NSTimeInterval)secs
 withIdentifier:(NSString *)ident
    andMinLevel:(NSInteger)level {
    self = [super init];
    if(self) {
        self.seconds = secs;
        self.identifier = ident;
        self.minimumLogLevel = level;
    }
    return self;
}

#pragma mark helpers

+ (NSArray*)entriesSince:(NSTimeInterval)seconds
          withIdentifier:(NSString*)ident
             andMinLevel:(NSInteger)level
{
    DDASLQuery *query = [[DDASLQuery alloc] initSince:seconds withIdentifier:ident andMinLevel:level];
    return [query execute:YES];
}

+ (NSString*)stringSince:(NSTimeInterval)seconds
          withIdentifier:(NSString*)ident
             andMinLevel:(NSInteger)level
{
    DDASLQuery *query = [[DDASLQuery alloc] initSince:seconds withIdentifier:ident andMinLevel:level];
    return [query execute:NO];
}

+(NSArray*)appLogEntriesForLastDay 
{
    id i = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSTimeInterval t = 60*60*24;
	return [DDASLQuery entriesSince:t withIdentifier:i andMinLevel:NSNotFound];
}

+(NSString*)appLogStringForLastHour {
    id i = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSTimeInterval t = 60*60*24;
	return [DDASLQuery stringSince:t withIdentifier:i andMinLevel:NSNotFound];
}

@end