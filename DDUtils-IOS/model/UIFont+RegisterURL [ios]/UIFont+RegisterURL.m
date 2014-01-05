//
//  UIFont+RegisterURL.m
//  SNKit
//
//  Created by Dominik Pich on 21.06.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "UIFont+RegisterURL.h"
#import <CoreText/CoreText.h>

@implementation UIFont (RegisterURL)

+ (BOOL)sn_registerFontsWithURL:(NSURL*)urlToFont {
    BOOL br = NO;
    NSData *inData = [NSData dataWithContentsOfURL:urlToFont];
    if(inData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (CTFontManagerRegisterGraphicsFont(font, &error)) {
            br = YES;
        }
        else {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
            br = NO;
        }
        CFRelease(font);
        CFRelease(provider);
    }
    return br;
}

#pragma mark -

+ (BOOL)registerFontsWithURL:(NSURL*)url {
    assert(url);
    
    id path = url.path;
    BOOL isDir = NO;
    if(path && [[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&isDir] && isDir) {
        NSArray *items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString *item in items) {
            if(![item.pathExtension isEqualToString:@"ttf"]
               && ![item.pathExtension isEqualToString:@"otf"]) {
                continue;
            }
            
            NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:item]];
            BOOL br = [self sn_registerFontsWithURL:url];
            if(!br) {
                NSLog(@"Failed to register %@", url);
                continue;
            }
        }
        return items.count > 0;
    }
    else {
        return [self sn_registerFontsWithURL:url];
    }
}

+ (BOOL)registerFontsFromBundle:(NSBundle*)b {
    return [self registerFontsWithURL:b.resourceURL];
}

#pragma mark -

+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size ifNeededLoadURL:(NSURL *)url {
    UIFont *f = [UIFont fontWithName:name size:size];
    if(!f) {
        BOOL br = [self registerFontsWithURL:url];
        f = [UIFont fontWithName:name size:size];
        assert(br || f);
    }
    return f;
}
@end
