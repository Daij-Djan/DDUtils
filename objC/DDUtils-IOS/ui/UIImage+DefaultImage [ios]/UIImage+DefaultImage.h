//
//  UIImage+DefaultImage.h
//
//  Created by Dominik Pich on 23.07.13.
//
#import <UIKit/UIKit.h>

@interface UIImage (DefaultImage)

// uses statusbar orientation
+ (UIImage *)defaultImage;

//uses given orientation
+ (UIImage *)defaultImageForOrientation:(UIInterfaceOrientation)orient;

@end
