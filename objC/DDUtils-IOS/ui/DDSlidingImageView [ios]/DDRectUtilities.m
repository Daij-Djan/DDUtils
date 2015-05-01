#import "DDRectUtilities.h"

@implementation DDRectUtilities

#if TARGET_OS_IPHONE
+ (CGRect)adjustRect:(CGRect)rect forContentOfView:(UIView*)view {
    CGRect bounds = view.bounds;
    
    switch (view.contentMode) {
        case UIViewContentModeScaleToFill:
            return bounds;
            
        case UIViewContentModeScaleAspectFit:
            return [self fitRect:rect inRect:bounds];
            
        case UIViewContentModeScaleAspectFill:
            return [self fillRect:rect inRect:bounds];
            
        case UIViewContentModeRedraw:
            return rect;
            
        case UIViewContentModeCenter:
            return [self centerRect:rect inRect:bounds];
            
            
        case UIViewContentModeTop:
            rect.origin.y = bounds.origin.y;
            break;
            
        case UIViewContentModeBottom:
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentModeLeft:
            rect.origin.x = bounds.origin.x;
            return rect;
            
        case UIViewContentModeRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            return rect;
            
        case UIViewContentModeTopLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentModeTopRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y;
            return rect;
            
        case UIViewContentModeBottomLeft:
            rect.origin.x = bounds.origin.x;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        case UIViewContentModeBottomRight:
            rect.origin.x = bounds.origin.x + bounds.size.width - rect.size.width;
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            return rect;
            
        default:
            NSLog(@"Unknown content mode: %ld", view.contentMode);
    }
    return rect;
}

+ (CGRect)adjustRectOfSize:(CGSize)size forContentOfView:(UIView*)view {
    CGRect rect = CGRectZero;
    rect.size = size;
    return [self adjustRect:rect forContentOfView:view];
}

#endif

#pragma mark - rect helpers

+ (CGRect)fitRect:(CGRect)rect inRect:(CGRect)inRect
{
	CGRect result = CGRectZero;
    
    // Before dividing by zero, we better take ratios of 1.0
	
    CGFloat xRatio = 1.0;
    if(inRect.size.width != 0) xRatio = rect.size.width / inRect.size.width;
    
    CGFloat yRatio = 1.0;
    if(inRect.size.height != 0.0) yRatio = rect.size.height / inRect.size.height;
	
	CGFloat aspectRatio = 1.0;
    if(rect.size.height != 0.0) aspectRatio = rect.size.width / rect.size.height;
	
	//fit sizes
	if (xRatio >= yRatio && aspectRatio != 0.0) {
		result.size.width = inRect.size.width;
		result.size.height = result.size.width / aspectRatio;
	}
	else {
		result.size.height = inRect.size.height;
		result.size.width = result.size.height * aspectRatio;
	}
	
	//center rect
	result = [self centerRect:result inRect:inRect];
	
	return result;
}

+ (CGRect)fillRect:(CGRect)rect inRect:(CGRect)inRect
{
	CGRect result = CGRectZero;
	
    CGFloat xRatio = 1.0;
    if(inRect.size.width != 0.0) xRatio = rect.size.width / inRect.size.width;
    
    CGFloat yRatio = 1.0;
    if(inRect.size.height != 0.0) yRatio = rect.size.height / inRect.size.height;
	
    CGFloat aspectRatio = 1.0;
    if(aspectRatio != 0.0) aspectRatio = rect.size.width / rect.size.height;
	
	//fit sizes
	if (xRatio <= yRatio) {
		result.size.width = inRect.size.width;
		result.size.height = result.size.width / aspectRatio;
	}
	else {
		result.size.height = inRect.size.height;
		result.size.width = result.size.height * aspectRatio;
	}
	
	//center rect
	result = [self centerRect:result inRect:inRect];
	
	return result;
}

+ (CGRect)centerRect:(CGRect)rect inRect:(CGRect)inRect
{
	CGRect result = rect;
	result.origin.x = inRect.origin.x + (inRect.size.width - result.size.width)*0.5f;
	result.origin.y = inRect.origin.y + (inRect.size.height - result.size.height)*0.5f;
	return result;
}

+ (CGRect)frameRectWithSize:(CGSize)size atCenter:(CGPoint)center
{
	CGRect r;
	
	r.size = size;
	r.origin.x = /*roundf*/(center.x - (size.width * 0.5f));
	r.origin.y = /*roundf*/(center.y - (size.height * 0.5f));
	
	return r;
}

+ (CGRect)scaleRect:(CGRect)rect byFactor:(float)factor {
    CGRect r;
    r.origin.x = rect.origin.x * factor;
    r.origin.y = rect.origin.y * factor;
    r.size.width = rect.size.width * factor;
    r.size.height = rect.size.height * factor;
    return r;
}

@end
