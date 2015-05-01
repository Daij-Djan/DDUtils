//
//  NSLocale+isoCode.h
//
//  Created by Dominik Pich on 19/06/14.
//

#import <Foundation/Foundation.h>

@interface NSLocale (isoCode)

- (NSString*)isoCodeForCountryNamed:(NSString*)country;
- (NSString*)isoCodeForLanguageNamed:(NSString*)language;
- (NSString*)countryNameForIsoCode:(NSString*)isoCode;
@end
