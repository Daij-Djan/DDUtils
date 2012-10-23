#import <UIKit/UIKit.h>

@interface MicBlowViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *minDuration;
@property (retain, nonatomic) IBOutlet UITextField *maxDuration;
@property (retain, nonatomic) IBOutlet UITextField *requiredConfidence;
@property (retain, nonatomic) IBOutlet UIButton *toggleMonitor;
- (IBAction)toggleMonitor:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *dectedState;
@property (retain, nonatomic) IBOutlet UILabel *detectedDuration;
@end

