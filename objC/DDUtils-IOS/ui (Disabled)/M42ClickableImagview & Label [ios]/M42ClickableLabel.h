//
//  RLLabel.h
//  Project
//
//  Created by Dominik Pich on 13.05.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M42ClickableLabel : UILabel
@property(nonatomic, assign) SEL action;
@property(nonatomic, weak) id target;

- (void)setTarget:(id)t andAction:(SEL)a;
@end
