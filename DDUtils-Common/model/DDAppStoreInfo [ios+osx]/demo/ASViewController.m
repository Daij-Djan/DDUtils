#import "DDAppStoreInfo.h"
#import "ASViewController.h"

@implementation ASViewController

- (void)viewWillAppear:(BOOL)animated {
    self.theID.text = @"id333903271"; //twitter
    [self refresh:nil];
}

- (IBAction)refresh:(id)sender {
    self.resultJSON.text = @"";
    self.iconView.image = nil;

    //demo
    [DDAppStoreInfo appStoreInfoForID:self.theID.text completion:^(DDAppStoreInfo *appstoreInfo) {
        self.resultJSON.text = appstoreInfo.json.description;
        self.iconView.image = appstoreInfo.smallArtwork;
    }];
}

@end
