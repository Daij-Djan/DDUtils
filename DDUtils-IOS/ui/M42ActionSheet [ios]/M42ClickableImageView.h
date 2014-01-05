//
//  M42ClickableImageView.h
//  Mediscript
//
//  Created by Dominik Pich on 11/23/10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M42ClickableImageView : UIImageView
@property(nonatomic, assign) SEL action;
@property(nonatomic, weak) id target;

- (void)setTarget:(id)t andAction:(SEL)a;
@end
