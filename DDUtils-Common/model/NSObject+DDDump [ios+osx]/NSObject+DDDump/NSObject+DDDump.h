//
//  NSObject+DDDump.h
//  OMMiniXcode
//
//  Created by Dominik Pich on 9/17/12.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (DDDump)

@property(readonly) NSString *dump;
@property(readonly) NSDictionary *reflection;

+ (NSString  *)dumpOfClass:(Class)cls;
+ (NSDictionary *)reflectionOfClass:(Class)cls;
+ (NSArray *)classDumps; //TODO add filter criteria

@end