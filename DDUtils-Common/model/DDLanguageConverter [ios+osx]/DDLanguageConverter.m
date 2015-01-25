//
//  DDLanguageConverter.m
//  Created by Dominik Pich on 5/14/12.
//

#import "DDLanguageConverter.h"

@implementation DDLanguageConverter {
    NSDictionary *_languageCodes;
    NSDictionary *_countryCodes;
}

- (id)init {
    self = [super init];
    if(self) {
        NSString *languageBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"iso-639 languages" ofType:@"plist"];
        NSDictionary *languageCodes = [[self class] codeMapWithPath:languageBundlePath];

        NSString *countryBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"iso-3166 countries" ofType:@"plist"];
        NSDictionary *countryCodes = [[self class] codeMapWithPath:countryBundlePath];

        if(languageCodes && countryCodes) {
            self->_languageCodes = languageCodes;
            self->_countryCodes = countryCodes;
            return self;
        }
    }
    return nil;
}
     
+ (NSDictionary*)codeMapWithPath:(NSString*)archive_path {
	// Try to load cached archive
    id codes = nil;
	NSData *archive_data = [NSData dataWithContentsOfFile:archive_path];
	if (archive_data) {
		NSString *archive_error = nil;
		NSDictionary *archive = (NSDictionary *)[NSPropertyListSerialization
                                                 propertyListFromData:archive_data 
                                                 mutabilityOption:NSPropertyListImmutable 
                                                 format:NULL 
                                                 errorDescription:&archive_error];
        
		if (archive_error) {
			DebugLog(@"code data couldn't be read");
		} else {
			codes = archive;
		}
    }
    else {
        DebugLog(@"code file couldn't be read");
    }
    return codes;
}
    
- (NSString*)iso6392fromAppleLanguageCode:(NSString*)code {
    //dont map it
    if(code.length != 2)
        return code;
    
    //map
    return _languageCodes[code];
}

- (NSString*)iso3166a3fromAppleCountryCode:(NSString*)code {
    //dont map it
    if(code.length != 2)
        return code;
    
    //map
    return _countryCodes[code];
}

@end
