//
//  DDImage+Masked.h
//
//  Created by Dominik Pich on 17.08.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//
#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define DDImage UIImage
#else
#import <Cocoa/Cocoa.h>
#define DDImage NSImage
#endif

@interface DDImage (Masked)

- (DDImage *)imageMaskedWith:(DDImage *)mask;

@end
