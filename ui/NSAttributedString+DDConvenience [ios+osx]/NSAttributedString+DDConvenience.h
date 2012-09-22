//
//  NSAttributedString+DDConvenience.h
//  OMMiniXcode
//
//  Created by Dominik Pich on 9/18/12.
//
//
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE 
#else
#import <Cocoa/Cocoa.h>
#endif

@interface NSAttributedString (DDConvenience)

#if TARGET_OS_IPHONE
#else
+ (NSAttributedString *)attributedStringWithImage:(NSImage*)image;
#endif

+ (NSAttributedString *)attributedStringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
@end
