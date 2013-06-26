//
//  UIImage+DDBadge.h
//
//  Created by Dominik Pich on 14.06.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DDBadge)

- (instancetype)imageBadgedWithValue:(NSInteger)badgeValue; //this method assumes defaults (white text & 1px frame on red & hide if 0 & bold sys default font 14pt & 26px26px in TR corner )
- (instancetype)imageBadgedWithOptions:(NSDictionary*)options;

@end

//options
extern NSString *DDBadgeValue;
extern NSString *DDBadgeBackgroundColor;
extern NSString *DDBadgeFrameColor;
extern NSString *DDBadgeTextColor;
extern NSString *DDBadgeShowWhenZero;
extern NSString *DDBadgeFrameWidth;
extern NSString *DDBadgeFont;
extern NSString *DDBadgeSize; //NSValue valueWithSize
extern NSString *DDBadgeOrigin; //NSNumber enum

//enum
typedef NS_ENUM(NSUInteger, DDBadgeOriginMode) {
    DDBadgeOriginModeTopLeft,
    DDBadgeOriginModeTopRight,
    DDBadgeOriginModeTopCenter,
    DDBadgeOriginModeMiddleLeft,
    DDBadgeOriginModeMiddleRight,
    DDBadgeOriginModeMiddleCenter,
    DDBadgeOriginModeBottomLeft,
    DDBadgeOriginModeBottomRight,
    DDBadgeOriginModeBottomCenter,
};
