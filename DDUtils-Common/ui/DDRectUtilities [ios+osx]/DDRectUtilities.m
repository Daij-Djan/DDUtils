//
//  DDRectUtilities.m
//
//  Created by Dominik Pich on 09.09.13.
//

#import "DDRectUtilities.h"

@implementation DDRectUtilities

#pragma mark - rect helpers

+ (CGRect)fitRect:(CGRect)rect inRect:(CGRect)inRect
{
	CGRect result = CGRectZero;
	
	CGFloat xRatio = rect.size.width / inRect.size.width;
	CGFloat yRatio = rect.size.height / inRect.size.height;
	
	CGFloat aspectRatio = rect.size.width / rect.size.height;
	
	//fit sizes
	if (xRatio >= yRatio) {
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
	
	CGFloat xRatio = rect.size.width / inRect.size.width;
	CGFloat yRatio = rect.size.height / inRect.size.height;
	
	CGFloat aspectRatio = rect.size.width / rect.size.height;
	
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
