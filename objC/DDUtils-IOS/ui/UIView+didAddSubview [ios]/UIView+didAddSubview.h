//
//  UIView+didAddSubview.h
//  myAudi
//
//  Created by Dominik Pich on 02/07/14.
//  Copyright (c) 2014 Sapient GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDAddSubviewDelegate <NSObject>
- (void)view:(UIView*)view didAddSubview:(UIView*)subview;
@end

@interface UIView (didAddSubview)
@property(nonatomic, assign) id<DDAddSubviewDelegate> addSubviewDelegate;
@end

