#import <UIKit/UIKit.h>

@interface ASViewController : UIViewController
@property(retain, nonatomic) IBOutlet UITextField *theID;
@property (retain, nonatomic) IBOutlet UITextView *resultJSON;
@property(retain, nonatomic) IBOutlet UIImageView *iconView;
- (IBAction)refresh:(id)sender;
@end

