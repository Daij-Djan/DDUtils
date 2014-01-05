//
//  UIImage+DefaultImage.m
//
//  Created by Dominik Pich on 23.07.13.
//
#import "UIImage+DefaultImage.h"

@implementation UIImage (DefaultImage)

+ (UIImage*)defaultImage {
    return [self defaultImageForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

+ (UIImage *)defaultImageForOrientation:(UIInterfaceOrientation)orient {
    // choose the correct launch image for orientation, device and scale
    NSMutableString *launchImageName = [[NSMutableString alloc] initWithString:@"Default"];
    BOOL isPad = ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad );
    if( isPad ) {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(orient);
        NSString *imageOrientation = (isLandscape) ? @"Landscape" : @"Portrait";
        
        BOOL isRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0);
        NSString *scaleString = (isRetina) ? @"@2x" : @"";
        
        // Default-Landscape~ipad.png
        // Default-Landscape@2x~ipad.png
        // Default-Portrait~ipad.png
        // Default-Portrait@2x~ipad.png
        launchImageName = [NSMutableString stringWithFormat:@"%@-%@%@.png", launchImageName, imageOrientation, scaleString];       
    } else {
        if( CGRectGetHeight([UIScreen mainScreen].bounds) > 480.f) {
            // Default-568h.png
            launchImageName = [NSMutableString stringWithFormat:@"%@-568h.png", launchImageName];
        } else {
            // Default.png
            // Default@2x.png
            launchImageName = [NSMutableString stringWithFormat:@"%@.png", launchImageName];
        }
    }
    return [UIImage imageNamed:launchImageName];
}

@end
