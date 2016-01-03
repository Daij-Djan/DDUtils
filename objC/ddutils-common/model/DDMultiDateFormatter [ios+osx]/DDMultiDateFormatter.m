//
//  DDMultiDateFormatter.m
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/2/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

#import "DDMultiDateFormatter.h"

@implementation DDMultiDateFormatter

- (NSArray *)formatters {
    if(!_formatters.count) {
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        id sRFC3339DateFormatterSubSeconds = [[NSDateFormatter alloc] init];
        [sRFC3339DateFormatterSubSeconds setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatterSubSeconds setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSXXXXX"];
        [sRFC3339DateFormatterSubSeconds setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

        id sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        [sRFC3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"];
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        _formatters = @[sRFC3339DateFormatterSubSeconds, sRFC3339DateFormatter];
    }
    return _formatters;
}

- (void)addNewFormatter:(void (^)(NSDateFormatter *newFormatter)) handler {
    id arr = [self.formatters mutableCopy];
    id newF = [[arr firstObject] copy];
    handler(newF);

    [arr addObject:newF];
    self.formatters = arr;
}

- (void)removeFormatter:(NSDateFormatter *)formatter {
    id arr = [self.formatters mutableCopy];
    [arr removeObject:formatter];
    self.formatters = arr;
}

- (NSString *)description {
    return [[self.formatters valueForKey:@"dateFormat"] description];
}

#pragma mark -

- (nullable NSString *)stringForObjectValue:(id)obj {
    return ([obj isKindOfClass:[NSDate class]]) ? [self stringFromDate:obj] : nil;
}

- (nullable NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(nullable NSDictionary<NSString *, id> *)attrs {
    id str = [self stringForObjectValue:obj];
    return (str != nil) ? [[NSAttributedString alloc] initWithString:str attributes:attrs] : nil;
}

- (nullable NSString *)editingStringForObjectValue:(id)obj {
    return [self stringForObjectValue:obj];
}

- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string errorDescription:(out NSString * __nullable * __nullable)error {
    id date = [self dateFromString:string];
    if(date != nil && obj != nil) {
        *obj = date;
    }
    else if(date == nil && error != nil) {
        *error = @"Cant parse string to NSDate";
    }
    return (date != nil);
}

- (BOOL)isPartialStringValid:(NSString * __nonnull * __nonnull)partialStringPtr proposedSelectedRange:(nullable NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString * __nullable * __nullable)error {
    return YES; //anything goes ;)
}

#pragma mark -

//- (BOOL)getObjectValue:(out id __nullable * __nullable)obj forString:(NSString *)string range:(inout nullable NSRange *)rangep error:(out NSError **)error;

- (NSString *)stringFromDate:(NSDate *)date {
    id str = nil;
    for (NSDateFormatter *formatter in self.formatters) {
        str = [formatter stringFromDate:date];
        if(str != nil) {
            break;
        }
    }
    return str;
}

- (nullable NSDate *)dateFromString:(NSString *)string {
    id date = nil;
    for (NSDateFormatter *formatter in self.formatters) {
        date = [formatter dateFromString:string];
        if(date != nil) {
            break;
        }
    }
    return date; 
}

@end
