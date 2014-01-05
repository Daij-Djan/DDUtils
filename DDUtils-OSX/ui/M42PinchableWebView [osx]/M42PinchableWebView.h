//
//  MedikamenteWebview.h
//  Medikamente
//
//  Created by Dominik Pich on 1/28/11.
//  Copyright 2011 FHK Gummersbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface M42PinchableWebView : WebView {
}
-(IBAction)zoomIn:(id)sender;
-(IBAction)zoomOut:(id)sender;
@end
