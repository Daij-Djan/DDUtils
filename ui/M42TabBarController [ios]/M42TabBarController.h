//
//  M42TabBarController.h
//  Project
//
//  Created by Dominik Pich on 11.06.10.
//  Copyright 2010 medicus42. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface M42TabBarController : UITabBarController 
{
@private
	UILabel *overlay;
}
@property(assign) BOOL disable;
@end
