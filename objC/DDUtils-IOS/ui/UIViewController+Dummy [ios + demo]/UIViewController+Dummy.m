//
//  UIViewController+Dummy.m
//  VPH
//
//  Created by Dominik Pich on 16/09/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

#import "UIViewController+Dummy.h"
#import <objc/runtime.h>

#define kBaseTag 5000

@implementation UIViewController (Dummy)

+ (void)load {
    [self swizzleInstanceMethodWithSelector:@selector(viewWillAppear:) withSelector:@selector(xchg_viewWillAppear:)];
}

- (void)xchg_viewWillAppear:(BOOL)animated {
    [self xchg_viewWillAppear:animated];
    
    if(![self isMemberOfClass:[UIViewController class]]) {
        return;
    }
         
    NSArray *seguesIds = [self segueIdentifiers];
    
    //if not in a navigation controller and presented
    if(self.presentingViewController) {
        UINavigationItem *item = self.navigationItem;
        item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];

        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 74);
        UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:rect];
        bar.tag = kBaseTag - 1;
        bar.items = @[item];
        [self.view addSubview:bar];
        

        
    }
    else {
        UINavigationBar *bar = (id)[self.view viewWithTag:kBaseTag - 1];
        [bar removeFromSuperview];
    }
    
    //rm any old buttons
    NSUInteger i = kBaseTag;
    UIView *v = [self.view viewWithTag:i];
    while(v) {
        [v removeFromSuperview];
        v = [self.view viewWithTag:++i];
    }
    
    
    //add a button list for the ids
    CGFloat y = 88;
    i = kBaseTag;
    for (id identifier in seguesIds) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(44, y, self.view.frame.size.width - 88, 44);
        button.tag = i;
        [button setTitle:identifier forState:UIControlStateNormal];
        [button addTarget:self action:@selector(performSegueForButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        y+=44;
        i+=1;
    }
}

#pragma mark -

- (NSArray*)segueIdentifiers {
    id segues = [self valueForKey:@"storyboardSegueTemplates"];
    id identifiers = [segues valueForKeyPath:@"identifier"];
    return identifiers;
}

- (void)performSegueForButton:(UIButton*)button {
    NSArray *seguesIds = [self segueIdentifiers];
    NSUInteger i = button.tag - kBaseTag;
    NSString *identifier = seguesIds[i];
    [self performSegueWithIdentifier:identifier sender:button];
}

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 

+ (void)swizzleInstanceMethodWithSelector:(SEL)originalSelector withSelector:(SEL)overrideSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

@end
