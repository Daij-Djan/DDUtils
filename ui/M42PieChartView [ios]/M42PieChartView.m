//
//  M42PieChartView.m
//  Project
//
//  Created by Dominik Pich on 25.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import "M42PieChartView.h"
#import "UIDevice+Platform.h"
#import "M42CompatibleImage.h"

#define pi 3.14159265
double radians(double percentage)
{
	return (percentage/100)*360 * (pi/180);
}


@implementation M42PieChartView

@synthesize dataSource;
@synthesize title;

- (CGImageRef) newPieWithRadiusImage:(CGFloat)PieRadius borderWidth:(CGFloat)TopLeftBorder {
	CGFloat CenterX   = PieRadius + TopLeftBorder;
	CGFloat CenterY   = PieRadius + TopLeftBorder;
	CGFloat StartRad  = 0;
	CGFloat EndRad    = 0;
	//---------------------------------------------------------------------------------------
	CGColorSpaceRef _ColorSpace  = CGColorSpaceCreateDeviceRGB();
	CGContextRef    _ViewContext = CGBitmapContextCreate (NULL,  2*CenterX, 2*CenterY, 8, 0, _ColorSpace, kCGImageAlphaPremultipliedLast);
	if (_ViewContext == NULL){
		CGColorSpaceRelease(_ColorSpace);
		return nil;
	}
	//---------------------------------------------------------------------------------------
	CGContextSetRGBStrokeColor(_ViewContext, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(_ViewContext, 4.0);
	//---------------------------------------------------------------------------------------
	NSUInteger c = [dataSource numberOfItemsInPieChart:self];	 
	for (NSUInteger i = 0; i<c; i++) {
		//-------------------------------------------------------------
		// set the pie part color
		const CGFloat* RGBComponents = CGColorGetComponents( [[dataSource colorForItem:i inPieChart:self] CGColor] );
		CGContextSetRGBFillColor(_ViewContext, RGBComponents[0], RGBComponents[1], RGBComponents[2], 1.0 );
		
		//-------------------------------------------------------------
		// Compute the finale angle for the pie part arc
		EndRad = StartRad + [dataSource percentageForItem:i inPieChart:self];
		
		//-------------------------------------------------------------
		// draw the pie part
		CGContextMoveToPoint(_ViewContext, CenterX, CenterY);
		CGContextAddArc(_ViewContext, CenterX, CenterY, PieRadius, radians(StartRad), radians(EndRad), 0);
		CGContextClosePath(_ViewContext);
		CGContextFillPath(_ViewContext);
		
		StartRad = EndRad;
	}
	
	//--------------------------------------------------------------------------------------
	// Option : to improve rendering, you can add an overlay image on the top of the pie
	// See bellow for image example.
	NSString *name = [[UIDevice currentDevice] isIPad] ? @"chart_overlay@2x.png" : @"chart_overlay.png";
	CGImageRef OverlayImage = [[M42CompatibleImage imageNamed: name ] CGImage]; //hack: the image name should be get/set
	CGContextDrawImage(_ViewContext, CGRectMake( 0.0,  0.0, CenterX*2,CenterY*2 ), OverlayImage);	
	CGImageRef _Result = CGBitmapContextCreateImage(_ViewContext);
	
	//---------------------------------------------------------------------------------------
	// free all resource !
	CGContextRelease(_ViewContext);
	CGColorSpaceRelease(_ColorSpace);

	return _Result;
}

#pragma mark UIView

- (void)layoutSubviews {
	if(image) {
		CGImageRelease(image);
		image = nil;
	}
}

- (void)drawRect:(CGRect)rect {
	if(!image) {
		PGLog(INFO, @"pie chart needs to recalc image for rect %@", NSStringFromCGRect(rect));
		image = [self newPieWithRadiusImage:fminf(rect.size.height, rect.size.width)/2-7 borderWidth:0]; //hack: the border should be get/set
	}
	
	rect.origin.x = rect.size.width/2 - CGImageGetWidth(image)/2;
	rect.origin.y = rect.size.height/2 - CGImageGetHeight(image)/2;
	rect.size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShadow(context, CGSizeMake(3, 5), 5);
    CGContextDrawImage(context, rect, image);	

	if(title) {
		rect = CGRectMake(0, 0, self.bounds.size.width, 20);
		[title drawInRect:rect withFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
	}
}


- (void)dealloc {
	if(image) CGImageRelease(image);
	[title release];
    [super dealloc];
}


@end
