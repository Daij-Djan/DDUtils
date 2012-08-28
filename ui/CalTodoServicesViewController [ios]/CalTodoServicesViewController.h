//
//  ServicesViewController.h
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BonjourServicesBrowser;

@interface CalTodoServicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	BonjourServicesBrowser *browser;
	IBOutlet UITableView *tableView;
	IBOutlet UIImageView *disabledImage;
	IBOutlet UIActivityIndicatorView *activityIndicatorView;
	IBOutlet UILabel *activityLabelView;
}
- (void)stopSearch;

@property(retain) BonjourServicesBrowser *browser;

@end
