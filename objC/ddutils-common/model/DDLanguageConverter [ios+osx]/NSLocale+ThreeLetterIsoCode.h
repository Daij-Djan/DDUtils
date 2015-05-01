//
//  NSLocale+ThreeLetterIsoCode.h
//
//  Created by Dominik Pich on 28/02/14.
//

#import <Foundation/Foundation.h>

@interface NSLocale (ThreeLetterIsoCode)

- (NSString*)threeLetterIsoCodeForCurrentLanguage;
- (NSString*)threeLetterIsoCodeForCurrentCountry;

@end
