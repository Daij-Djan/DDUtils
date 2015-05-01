//
//  NSLocale+isoCode.m
//
//  Created by Dominik Pich on 19/06/14.
//

#import "NSLocale+isoCode.h"

@implementation NSLocale (isoCode)

- (NSDictionary*)countryIsoCodesDictionary {
    static NSDictionary *countryIsoCodesDictionary = nil;
    
    if(!countryIsoCodesDictionary) {
        NSArray *countryCodes = [NSLocale ISOCountryCodes];
        NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
        
        for (NSString *countryCode in countryCodes)
        {
            NSString *country = [self displayNameForKey: NSLocaleCountryCode value: countryCode];
            [countries addObject: country];
        }

        countryIsoCodesDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    }
    return countryIsoCodesDictionary;
}

- (NSDictionary*)languageIsoCodesDictionary {
    static NSDictionary *languageIsoCodesDictionary = nil;
    
    if(!languageIsoCodesDictionary) {
        NSArray *languageCodes = [NSLocale ISOLanguageCodes];
        NSMutableArray *languages = [NSMutableArray arrayWithCapacity:[languageCodes count]];
        
        for (NSString *languageCode in languageCodes)
        {
            NSString *language = [self displayNameForKey: NSLocaleLanguageCode value: languageCode];
            // MAIR-900: On iOS6, not all language codes have a language name (language == nil).
            // In that case, we'll fall back to using the raw language code.
            if(language) [languages addObject: language];
            else [languages addObject:languageCode];
        }
        
        languageIsoCodesDictionary = [[NSDictionary alloc] initWithObjects:languageCodes forKeys:languages];
    }
    return languageIsoCodesDictionary;
}

//===

- (NSString*)isoCodeForCountryNamed:(NSString*)country {
    return [self countryIsoCodesDictionary][country];
}

- (NSString*)isoCodeForLanguageNamed:(NSString*)language {
    return [self languageIsoCodesDictionary][language];
}

- (NSString*)countryNameForIsoCode:(NSString*)isoCode {
    NSString *countryName = [[[self countryIsoCodesDictionary] allKeysForObject:isoCode] lastObject];
    if(!countryName) return isoCode;
    return countryName;
}
@end
