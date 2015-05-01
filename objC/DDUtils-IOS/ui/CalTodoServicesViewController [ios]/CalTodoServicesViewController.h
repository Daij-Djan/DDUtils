//
//  ServicesViewController.h
//  calTodo
//
//  Created by Dominik Pich on 15.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDBonjourServicesBrowser;

@interface CalTodoServicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
	IBOutlet UIImageView *disabledImage;
	IBOutlet UIActivityIndicatorView *activityIndicatorView;
	IBOutlet UILabel *activityLabelView;
}
- (void)serviceChosen:(NSNetService *)service; //can be used by subclass
@property(nonatomic, strong) DDBonjourServicesBrowser *browser;

@end
