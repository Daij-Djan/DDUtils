//
//  ViewController.m
//  DDTextFieldDemo_ios
//
//  Created by Dominik Pich on 09/02/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

#import "ViewController.h"
#import "DDTextField.h"

@interface ViewController () <DDTextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(DDTextField *)textField {
    return textField.isMultiLine;
}

@end
