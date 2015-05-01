//
//  UIFont+RegisterURL.h
//  SNKit
//
//  Created by Dominik Pich on 21.06.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (RegisterURL)

+ (BOOL)registerFontsWithURL:(NSURL *)url; //if the url is a local folder, it is scanned for every ttf and otf
+ (BOOL)registerFontsFromBundle:(NSBundle *)b; // uses all fonts in the unlocalized resources directory

//convenience
+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size ifNeededLoadURL:(NSURL *)url; //tries to get the font, loads the url if it fails

@end
