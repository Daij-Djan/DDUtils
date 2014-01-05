//
//  DDRectUtilities.h
//
//  Created by Dominik Pich on 09.09.13.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DDRectUtilities : NSObject

//rect helpers
+ (CGRect)fitRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)fillRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)centerRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)frameRectWithSize:(CGSize)size atCenter:(CGPoint)center;
+ (CGRect)scaleRect:(CGRect)rect byFactor:(float)factor;

@end
