//
//  M42CompatibleAlert.h
//  Medikamente
//
//  Created by Dominik on 12/30/10.
//  Copyright 2010 FHK Gummersbach. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface M42CompatibleAlert : NSObject {
#if TARGET_OS_IPHONE
	UIAlertView *alertView;
#else
	NSAlert *alertView;
#endif
}
- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)title, ...;
- (void)addButtonWithTitle:(NSString*)title;
- (void)show;
@end
