#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <CoreGraphics/CoreGraphics.h>
#endif

@interface DDRectUtilities : NSObject

#if TARGET_OS_IPHONE 
+ (CGRect)adjustRect:(CGRect)rect forContentOfView:(UIView*)view; //honours contentMode and bounds
+ (CGRect)adjustRectOfSize:(CGSize)size forContentOfView:(UIView*)view; //honours contentMode and bounds
#endif

//rect helpers
+ (CGRect)fitRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)fillRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)centerRect:(CGRect)rect inRect:(CGRect)inRect;
+ (CGRect)scaleRect:(CGRect)rect byFactor:(float)factor;

@end
