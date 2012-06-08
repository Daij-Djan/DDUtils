//
//  M42PieChartView.h
//  Project
//
//  Created by Dominik Pich on 25.08.10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@class M42PieChartView;

@protocol M42PieChartViewDataSource

- (NSUInteger)numberOfItemsInPieChart:(M42PieChartView*)chart;
- (UIColor*)colorForItem:(NSUInteger)itemIndex inPieChart:(M42PieChartView*)chart;
- (double)percentageForItem:(NSUInteger)itemIndex inPieChart:(M42PieChartView*)chart;

@end

@interface M42PieChartView : UIView {
	id<M42PieChartViewDataSource> dataSource;
	CGImageRef image;
	NSString *title;
}
@property(nonatomic, assign) IBOutlet id<M42PieChartViewDataSource> dataSource;

@property(copy) NSString *title;
@end
