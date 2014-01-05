//
//  NSAttributedString+Image.m
//  OMMiniXcode
//
//  Created by Dominik Pich on 9/18/12.
//
//

#import "NSAttributedString+DDConvenience.h"

@implementation NSAttributedString (DDConvenience)

#if TARGET_OS_IPHONE
#else
+ (NSAttributedString *)attributedStringWithImage:(NSImage*)image {
    NSParameterAssert(image);
    
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    NSTextAttachmentCell *cell = [[NSTextAttachmentCell                                               alloc] initImageCell:image];
    [attachment setAttachmentCell:cell];
    
    NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attachment];
    
    return icon;
}
#endif

+ (NSAttributedString *)attributedStringWithFormat:(NSString *)format, ... {
    NSParameterAssert(format);
    
    //get str
    va_list argp;
    va_start(argp, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:argp];
    va_end(argp);
    
    return [[NSAttributedString alloc] initWithString:str];
}

@end
