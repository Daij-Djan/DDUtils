//
//  DDLanguageConverter.h
//  Created by Dominik Pich on 5/14/12.
//

#import <Foundation/Foundation.h>

@interface DDLanguageConverter : NSObject 

/**
 * converts an apple language code (iso 6391 or 6392) to iso 6392
 * @param code the lanuage from the NSLocale 
 * @return the iso code
 */
- (NSString*)iso6392fromAppleLanguageCode:(NSString*)code;

/**
 * converts an apple country code (iso 3166 alpha 2) to iso 3166 alpha 3
 * @param code the country from the NSLocale
 * @return the iso code
 */
- (NSString*)iso3166a3fromAppleCountryCode:(NSString*)code;

@end
