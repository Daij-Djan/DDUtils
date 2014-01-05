//
//  UIImage+DefaultImage.h
//  MSSChassis
//
//  Created by Dominik Pich on 23.07.13.
//  Copyright (c) 2013 Sapient GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DefaultImage)

// uses statusbar orientation
+ (UIImage*)defaultImage;

//uses given orientation
+ (UIImage*)defaultImageForOrientation:(UIInterfaceOrientation)orient;

@end
