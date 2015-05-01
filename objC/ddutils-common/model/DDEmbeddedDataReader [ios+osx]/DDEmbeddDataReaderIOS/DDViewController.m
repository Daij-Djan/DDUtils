//
//  DDViewController.m
//  DDEmbeddDataReaderIOS
//
//  Created by Dominik Pich on 02.03.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDViewController.h"
#import "DDEmbeddedDataReader.h"

@implementation DDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //plist 1
    id plist = [DDEmbeddedDataReader defaultEmbeddedPlist:nil];
    NSLog(@"plist: %@", plist);
    
    //text data
    NSData *data = [DDEmbeddedDataReader embeddedDataFromSection:@"__testData" error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"text: %@", string);
    
    //image data
    data = [DDEmbeddedDataReader embeddedDataFromSegment:@"__IMG" inSection:@"__testImg" error:nil];
    NSLog(@"image data no of bytes: %u", data.length);
    
    //show the image
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:view];
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.frame = self.view.bounds;
}

@end
