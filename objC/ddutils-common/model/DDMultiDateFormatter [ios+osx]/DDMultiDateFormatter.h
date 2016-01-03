//
//  DDMultiDateFormatter.h
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/2/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

//formats a date using the first matching date formatter that returns a non nil value
@interface DDMultiDateFormatter : NSFormatter

NS_ASSUME_NONNULL_BEGIN

@property(nonatomic, strong) NSArray *formatters; //default are two date formatter to cover the RFC 3339. this property is never nil/empty, setting it to nil/empty, resets it

- (void)addNewFormatter:(void (^)(NSDateFormatter *newFormatter)) handler; //copies the first formatter in the array

- (void)removeFormatter:(NSDateFormatter*)formatter; //removes a formatter in the array

//---

//- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string range:(inout nullable NSRange *)rangep error:(out NSError **)error;

- (nullable NSString *)stringFromDate:(NSDate*)date;

- (nullable NSDate *)dateFromString:(NSString*)string;

NS_ASSUME_NONNULL_END

@end
