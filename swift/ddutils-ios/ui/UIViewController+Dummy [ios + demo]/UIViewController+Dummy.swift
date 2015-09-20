//
//  UIViewController+Dummy.m
//  VPH
//
//  Created by Dominik Pich on 16/09/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import UIKit
//#import <objc/runtime.h>

let kBaseTag = 5000

extension UIViewController {

    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        dispatch_once(&Static.token) {
            self.swizzleSelector("viewWillAppear:", withSelector: "xchg_viewWillAppear:")
        }
    }

    func xchg_viewWillAppear(animated:Bool) {
        self.xchg_viewWillAppear(animated)
    
        if(!self.isMemberOfClass(UIViewController.self)) {
            return;
        }

        self.addBarIfNeeded()
        self.buttonsForSegues()
    }

    func addBarIfNeeded() {
        //if not in a navigation controller and presented
        if(self.presentingViewController != nil) {
            let item = self.navigationItem
            item.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "closeView")
            
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 74)
            let bar = UINavigationBar(frame: rect)
            bar.tag = kBaseTag-1
            bar.items = [item]
            self.view.addSubview(bar)
        }
        else {
            if let bar = self.view.viewWithTag(kBaseTag-1) {
                bar.removeFromSuperview()
            }
        }
    }
    
    func buttonsForSegues() {
        if let seguesIds = self.segueIdentifiers {
            //rm any old buttons
            var i = kBaseTag
            var v = self.view.viewWithTag(i)
            while(v != nil) {
                v!.removeFromSuperview()
                v = self.view.viewWithTag(++i)
            }
            
            //add a button list for the ids
            var y = 88;
            i = kBaseTag;
            for identifier in seguesIds {
                let button = UIButton(type: UIButtonType.System)
                button.frame = CGRect(x: 44, y: y, width: Int(self.view.frame.width) - 88, height: 44)
                button.tag = i;
                button.setTitle(identifier, forState: UIControlState.Normal)
                button.addTarget(self, action: "performSegueForButton:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(button)
                
                y+=44;
                i+=1;
            }
        }
    }
    
    // MARK: -

    var segueIdentifiers: [String]? {
        get {
            if let segues = self.valueForKey("storyboardSegueTemplates") as? NSArray {
                let identifiers = segues.valueForKeyPath("identifier") as! [String]!
                return identifiers
            }
            return nil
        }
    }

    func performSegueForButton(button:UIButton!) -> Void {
        if let seguesIds = self.segueIdentifiers {
            let i = button.tag - kBaseTag
            let identifier = seguesIds[i]
            self.performSegueWithIdentifier(identifier, sender: button)
        }
    }

    func closeView() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: -

    class func swizzleSelector(origSelector:String, withSelector:String) -> Void {
        let originalMethod = class_getInstanceMethod(self, Selector(origSelector))
        let swizzledMethod = class_getInstanceMethod(self, Selector(withSelector))
        
        let didAddMethod = class_addMethod(self, Selector(origSelector), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self, Selector(withSelector), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}