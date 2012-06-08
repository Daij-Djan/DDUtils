//
//  RLLabel.h
//  Project
//
//  Created by Dominik Pich on 13.05.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M42ClickableLabel : UILabel {
	SEL action;
	id target;
}
@property(assign) SEL action;
@property(assign) id target;

- (void)setTarget:(id)t andAction:(SEL)a;
@end
