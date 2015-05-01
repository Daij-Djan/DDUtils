//
//  NSLocale+ThreeLetterIsoCode.m
//
//  Created by Dominik Pich on 28/02/14.
//

#import "DDLanguageConverter.h"

@implementation NSLocale (ThreeLetterIsoCode)

- (DDLanguageConverter*)converter {
    static dispatch_once_t onceToken;
    static DDLanguageConverter *converter = nil;
    
    dispatch_once(&onceToken, ^{
        converter = [[DDLanguageConverter alloc] init];
        if(!converter) {
            NSLog(@"Cant init iso converter");
        }
    });
    
    return converter;
}

- (NSString*)threeLetterIsoCodeForCurrentLanguage {
    return [self.converter iso6392fromAppleLanguageCode:[self objectForKey:NSLocaleLanguageCode]];
}

- (NSString*)threeLetterIsoCodeForCurrentCountry {
    return [self.converter iso3166a3fromAppleCountryCode:[self objectForKey:NSLocaleCountryCode]];
}

@end
