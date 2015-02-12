/**
@file      DDUnits.m
@author    Dominik Pich (based heavily on code by M. Zapf)
@date      2014-05-14
*/
#import "DDUnits.h"

@implementation DDUnits

+ (NSString*)unitTextForUnitType:(DDUnitType)unitType {
    switch (unitType) {
        case DDUnitTypeNone:
            return nil;
            
        case DDUnitTypeCurrency:
            return [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCurrencyCode];
            
        case DDUnitTypeDuration:
            return @"min";
        
        case DDUnitTypeDistance:
            return @"km";
            
        case DDUnitTypeHeight:
            return @"m";
            
        case DDUnitTypeSpeed:
            return @"km/h";
            
        case DDUnitTypeLiquidVolume:
            return @"l";
    }
    return nil;
}

+ (NSString*)regExPatternForUnitType:(DDUnitType)unitType {
    switch (unitType) {
        case DDUnitTypeNone:
            return nil;
            
        case DDUnitTypeCurrency:
        case DDUnitTypeLiquidVolume:
        case DDUnitTypeDistance:
            return [NSString stringWithFormat:@"^(\\d{1,3}(\\%@\\d{3})*|(\\d+))(?:\\%@\\d{0,2})?$", [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator], [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
            
        case DDUnitTypeDuration:
        case DDUnitTypeHeight:
        case DDUnitTypeSpeed:
            return [NSString stringWithFormat:@"^\\d+(?:\\%@\\d{0,9})?", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
            
    }
    return nil;
}

+ (NSString*)valueTextWithUnitForValue:(NSNumber*)value unitType:(DDUnitType)unitType{
    return [NSString stringWithFormat:@"%@ %@",
            [self valueTextWithoutUnitForValue:value withUnitType:unitType],
            [self unitTextForUnitType:unitType]];
}


+ (NSString*)valueTextWithoutUnitForValue:(NSNumber*)value withUnitType:(DDUnitType)unitType {
    if (value == nil) {
        return @"";
    }
    
    NSNumberFormatter *formatter;
    
    switch (unitType) {
        case DDUnitTypeCurrency:
            formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            formatter.minimumFractionDigits = 2;
            return [formatter stringFromNumber:value];

        case DDUnitTypeDuration: {
            //duration is sec.
            long duration = [value longValue];
            int days = (int)(duration / 86400);
            duration -= days * 86400;
            int hours = (int)(duration / 3600);
            duration -= hours * 3600;
            int minutes = (int)(duration / 60);
            duration -= minutes * 60;
            int seconds = (int)duration;
            if(days > 0)
                return [NSString stringWithFormat:@"%02i:%02i:%02i:%02i", days, hours, minutes, seconds];
            else
                return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
        }

        case DDUnitTypeDistance: {
            formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.minimumFractionDigits = 2;
            formatter.maximumFractionDigits = 2;

            double val = METER_TO_KM([value doubleValue]);
            return [formatter stringFromNumber:[NSNumber numberWithDouble:val]];
        }
        case DDUnitTypeHeight: {
            double val = [value doubleValue];
            return [NSString stringWithFormat:@"%i", (int)val];
        }
            
        case DDUnitTypeSpeed: {
            float val = MPS_TO_KMH([value floatValue]); //m/s -> km/h
            return [NSString stringWithFormat:@"%i", (int)val];
        }
            
        case DDUnitTypeLiquidVolume:
            formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            formatter.minimumFractionDigits = 2;
            return [formatter stringFromNumber:value];
            
        default:
            formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterNoStyle;
            return [formatter stringFromNumber:value];
    }
}

+ (NSNumber*)valueForText:(NSString*)text withUnitType:(DDUnitType)unitType {
    if (!text.length) {
        return nil;
    }
    
    if(unitType == DDUnitTypeDuration) {
        NSArray *parts = [text componentsSeparatedByString:@":"];
        if(parts.count >= 3) {
            int i = 0;
            int days, hours, minutes, seconds;
            
            if(parts.count >= 4) {
                if(parts.count >= 5) {
                    return nil;
                }
                days = [parts[i++] intValue];
            }
            
            hours = [parts[i++] intValue];
            minutes = [parts[i++] intValue];
            seconds = [parts[i++] intValue];
            
            seconds += 60 * minutes;
            seconds += 60 * 60 * hours;
            seconds += 60 * 60 * 24 * days;
            
            return @(seconds);
        }
    }

    //rm grouping
    text = [text stringByReplacingOccurrencesOfString:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator] withString:@""];
    
    //trim away all unit identifiers
    NSMutableCharacterSet *set = [NSMutableCharacterSet decimalDigitCharacterSet];
    [set invert];
    text = [text stringByTrimmingCharactersInSet:set];
    
    
    //locale
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    
    NSNumber* number = [formatter numberFromString:text];
    
    switch (unitType) {
        case DDUnitTypeDistance: {
            double value = [number doubleValue];
            return [NSNumber numberWithDouble:KM_TO_METER(value)];
        }
        case DDUnitTypeSpeed: {
            double value = [number doubleValue];
            return [NSNumber numberWithDouble:KMH_TO_MPS(value)];
        }
        default:
            return number;
    }
}

@end
