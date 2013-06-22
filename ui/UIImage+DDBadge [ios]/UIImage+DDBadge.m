//
//  UIImage+DDBadge.m
//  HBStoreLocatorTest
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
NSString *DDBadgeFont = @"badgeFont";

@implementation UIImage (DDBadge)

- (instancetype)imageBadgedWithValue:(NSInteger)badgeValue {
    return [self imageBadgedWithOptions:@{DDBadgeFrameWidth:@1, DDBadgeTextColor:[UIColor whiteColor], DDBadgeFrameColor:[UIColor whiteColor], DDBadgeBackgroundColor:[UIColor redColor], DDBadgeShowWhenZero:@NO, DDBadgeValue:@(badgeValue), DDBadgeFont:[UIFont boldSystemFontOfSize:10]}];
}

- (instancetype)imageBadgedWithOptions:(NSDictionary*)options {
    NSInteger badgeValue = [options[DDBadgeValue] integerValue];
    BOOL displayWhenZero = [options[DDBadgeShowWhenZero] boolValue];
    
    if(badgeValue || displayWhenZero) {
        UIColor *badgeColor = options[DDBadgeBackgroundColor];
        UIColor *outlineColor = options[DDBadgeFrameColor];
        UIColor *textColor = options[DDBadgeTextColor];
        CGFloat outlineWidth = [options[DDBadgeFrameWidth] floatValue];
        UIFont *font = options[DDBadgeFont];
        
        CGSize size = self.size;
        CGRect rect = {.origin=CGPointMake(size.width-22, 0), .size=CGSizeMake(22, 22)};
        
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
        CGSize numberSize = [badgeValueString sizeWithFont:font];
        CGRect badgeValueRect = CGRectMake(rect.size.width/2.0 - numberSize.width/2.0,
                                           rect.size.height/2.0 - numberSize.height/2.0,
                                           numberSize.width, numberSize.height);

        [textColor set];
        [badgeValueString drawInRect:badgeValueRect
                            withFont:font
                       lineBreakMode:NSLineBreakByClipping
                           alignment:NSTextAlignmentCenter];
        
        //finish
        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
    else
        return self;
}

@end
