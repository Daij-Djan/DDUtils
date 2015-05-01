//
//  DDImage+Masked.m
//
//  Created by Dominik Pich on 17.08.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDImage+Masked.h"

@implementation DDImage (Masked)

- (DDImage *)imageMaskedWith:(DDImage *)mask {
    DDImage *newImage = nil;
    NSParameterAssert(mask);
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CGImageRef imageReference = self.CGImage;
    CGImageRef maskReference = mask.CGImage;
    CGRect rect = CGRectMake(0, 0, CGImageGetWidth(imageReference), CGImageGetHeight(imageReference));

    // draw with Core Graphics
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, 0.0, rect.size.height);
    CGContextScaleCTM(bitmap, 1.0, -1.0);

    CGContextClipToMask(bitmap, rect, maskReference);
    CGContextDrawImage(bitmap, rect, imageReference);
    
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
#else
    CGRect rect = NSMakeRect(0.0, 0.0, self.size.width, self.size.height);
    CGImageRef imageReference = [self CGImageForProposedRect:nil context:nil hints:nil];
    CGImageRef maskReference = [mask CGImageForProposedRect:nil context:nil hints:nil];
    
    NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc]
                                       initWithBitmapDataPlanes:NULL
                                       pixelsWide:rect.size.width
                                       pixelsHigh:rect.size.height
                                       bitsPerSample:8
                                       samplesPerPixel:4
                                       hasAlpha:YES
                                       isPlanar:NO
                                       colorSpaceName:NSDeviceRGBColorSpace
                                       bitmapFormat:NSAlphaFirstBitmapFormat
                                       bytesPerRow:0
                                       bitsPerPixel:0];
    
    // set offscreen context
    NSGraphicsContext *g = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:g];
    
    // draw with Core Graphics
    CGContextRef bitmap = [g graphicsPort];
//    CGContextTranslateCTM(bitmap, 0.0, rect.size.height);
//    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextClipToMask(bitmap, rect, maskReference);
    CGContextDrawImage(bitmap, rect, imageReference);
    
    // done drawing, so set the current context back to what it was
    [NSGraphicsContext restoreGraphicsState];
    
    // create an NSImage and add the rep to it    
    newImage = [[NSImage alloc] initWithSize:rect.size];
    [newImage addRepresentation:offscreenRep];
#endif
	return newImage;    
}

@end
