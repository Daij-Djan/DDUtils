//
//  UIImage+DDBadge.m
//
//  Created by Dominik Pich on 14.06.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "UIImage+DDBadge.h"

NSString *DDBadgeValue = @"value";
NSString *DDBadgeBackgroundColor = @"backgroundColor";
NSString *DDBadgeFrameColor = @"frameColor";
NSString *DDBadgeTextColor = @"textColor";
NSString *DDBadgeShowWhenZero = @"showWhenZero";
NSString *DDBadgeFrameWidth = @"frameWidth";
NSString *DDBadgeFont = @"DDBadgeFont";
NSString *DDBadgeSize = @"DDBadgeSize";
NSString *DDBadgeOrigin = @"DDBadgeOrigin";

CGPoint DDBadgeOriginForSize(DDBadgeOriginMode origin, CGSize size, CGSize badgeSize);
CGPoint DDBadgeOriginForSize(DDBadgeOriginMode origin, CGSize size, CGSize badgeSize) {
    CGPoint pt = CGPointZero;
    
    switch (origin) {
        case DDBadgeOriginModeTopLeft:
            break;
        case DDBadgeOriginModeTopRight:
            pt.x = size.width - badgeSize.width;
            break;
        case DDBadgeOriginModeTopCenter:
            pt.x = size.width / 2 - badgeSize.width / 2;
            break;
            
        case DDBadgeOriginModeMiddleLeft:
            pt.y = size.height / 2 - badgeSize.height / 2;
            break;
        case DDBadgeOriginModeMiddleRight:
            pt.y = size.height / 2 - badgeSize.height / 2;
            pt.x = size.width - badgeSize.width;
            break;
        case DDBadgeOriginModeMiddleCenter:
            pt.y = size.height / 2 - badgeSize.height / 2;
            pt.x = size.width / 2 - badgeSize.width / 2;
            break;
            
        case DDBadgeOriginModeBottomLeft:
            pt.y = size.height - badgeSize.width;
            break;
        case DDBadgeOriginModeBottomRight:
            pt.y = size.height - badgeSize.width;
            pt.x = size.width - badgeSize.width;
            break;
        case DDBadgeOriginModeBottomCenter:
            pt.y = size.height - badgeSize.width;
            pt.x = size.width / 2 - badgeSize.width / 2;
            break;            
        default:
            break;
    }
    return pt;
}

@implementation UIImage (DDBadge)

- (instancetype)imageBadgedWithValue:(NSInteger)badgeValue {
    return [self imageBadgedWithOptions:@{DDBadgeFrameWidth:@1, DDBadgeTextColor:[UIColor whiteColor], DDBadgeFrameColor:[UIColor whiteColor], DDBadgeBackgroundColor:[UIColor redColor], DDBadgeShowWhenZero:@NO, DDBadgeValue:@(badgeValue), DDBadgeFont:[UIFont boldSystemFontOfSize:14], DDBadgeSize:[NSValue valueWithCGSize:CGSizeMake(26, 26)], DDBadgeOrigin:@(DDBadgeOriginModeTopRight) }];
}

- (instancetype)imageBadgedWithOptions:(NSDictionary *)options {
    NSInteger badgeValue = [options[DDBadgeValue] integerValue];
    BOOL displayWhenZero = [options[DDBadgeShowWhenZero] boolValue];
    
    if (badgeValue || displayWhenZero) {
        UIColor *badgeColor = options[DDBadgeBackgroundColor];
        UIColor *outlineColor = options[DDBadgeFrameColor];
        UIColor *textColor = options[DDBadgeTextColor];
        CGFloat outlineWidth = [options[DDBadgeFrameWidth] floatValue];
        UIFont *font = options[DDBadgeFont];
        NSValue *badgeSizeValue = options[DDBadgeSize];
        CGSize badgeSize = badgeSizeValue.CGSizeValue;
        NSNumber *badgeOriginNumber = options[DDBadgeOrigin];
        
        CGSize size = self.size;
        CGPoint badgeOrigin = DDBadgeOriginForSize(badgeOriginNumber.unsignedIntegerValue, size, badgeSize);
        
        CGRect rect = {.origin = badgeOrigin, .size = badgeSize};
        
        //begin
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //draw image
        [self drawAtPoint:CGPointZero];
        
        //frame
        [outlineColor set];
        CGContextFillEllipseInRect(context, CGRectInset(rect, 1, 1));

        //bg
        [badgeColor set];
        CGContextFillEllipseInRect(context, CGRectInset(rect, outlineWidth + 1, outlineWidth + 1));

        //text
        NSString *badgeValueString = [NSString stringWithFormat:@"%ld", (long)badgeValue];
        CGSize numberSize = [badgeValueString sizeWithAttributes:@{NSFontAttributeName:font}];
        CGRect badgeValueRect = CGRectMake(badgeOrigin.x + badgeSize.width / 2.0 - numberSize.width / 2.0,
                                           badgeOrigin.y + badgeSize.height / 2.0 - numberSize.height / 2.0,
                                           numberSize.width, numberSize.height);

        [textColor set];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.lineBreakMode = NSLineBreakByClipping;
        [badgeValueString drawInRect:badgeValueRect withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraph}];
        
        //finish
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    } else {
        return self;
    }
}

@end
