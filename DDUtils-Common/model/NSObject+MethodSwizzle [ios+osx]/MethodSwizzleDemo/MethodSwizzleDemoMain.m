//
//  main.m
//  NSObject+MethodSwizzle
//
//  Created by Dominik Pich on 07.06.12.
//

#import <Foundation/Foundation.h>
#import "NSObject+MethodSwizzle.h"

@interface NSTimeZone (myTest)
@end
@implementation NSTimeZone (myTest)
///called by runtime
+ (void)load {
    [self swizzleInstanceMethodWithSelector:@selector(description) withSelector:@selector(description_xchg)];
    [self swizzleClassMethodWithSelector:@selector(knownTimeZoneNames) withSelector:@selector(knownTimeZoneNames_xchg)];
}
- (NSString  *)description_xchg {
    NSString *str = [self description_xchg]; //calls swizzled method!
    return [str stringByAppendingString:@"_myTest"];
}
+ (NSArray  *)knownTimeZoneNames_xchg {
    NSArray *zs = [self knownTimeZoneNames_xchg]; //calls swizzled method!
    NSMutableArray *mzs = [NSMutableArray arrayWithArray:zs];
    [mzs insertObject:@"MyTestZone!!!" atIndex:0];
    return mzs;
}
@end

int main(int argc, const char *argv[])
{
    @autoreleasepool {
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        NSLog(@"%@", timeZone);

        NSArray *zones = [NSTimeZone knownTimeZoneNames];
        NSLog(@"%@", zones);
    }
    return 0;
}

///NOTE swizzeling is cool but dont swizzle into classes that are class clusters and/or briged to CFFoundation (e.g. dont do it to e.g. NSString<>CFString or NSArray or NSData or NSNumber...)