//
//  UIViewController+Dummy.m
//  VPH
//
//  Created by Dominik Pich on 16/09/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import UIKit
//#import <objc/runtime.h>

var swizzed = false
let kBaseTag = 5000

extension UIViewController {

    open override class func initialize() {
        struct Static {
            static var token: Int = 0
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        if !swizzed {
            self.swizzleSelector("viewWillAppear:", withSelector: "xchg_viewWillAppear:")
            swizzed = true
        }
    }

    func xchg_viewWillAppear(_ animated:Bool) {
        self.xchg_viewWillAppear(animated)
    
        if(!self.isMember(of: UIViewController.self)) {
            return;
        }

        self.addBarIfNeeded()
        self.buttonsForSegues()
    }

    func addBarIfNeeded() {
        //if not in a navigation controller and presented
        if(self.presentingViewController != nil) {
            let item = self.navigationItem
            item.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.closeView))
            
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
                i = i+1
                
                v!.removeFromSuperview()
                v = self.view.viewWithTag(i)
            }
            
            //add a button list for the ids
            var y = 88;
            i = kBaseTag;
            for identifier in seguesIds {
                let button = UIButton(type: UIButtonType.system)
                button.frame = CGRect(x: 44, y: y, width: Int(self.view.frame.width) - 88, height: 44)
                button.tag = i;
                button.setTitle(identifier, for: UIControlState())
                button.addTarget(self, action: #selector(UIViewController.performSegueForButton(_:)), for: UIControlEvents.touchUpInside)
                self.view.addSubview(button)
                
                y+=44;
                i+=1;
            }
        }
    }
    
    // MARK: -

    var segueIdentifiers: [String]? {
        get {
            if let segues = self.value(forKey: "storyboardSegueTemplates") as? NSArray {
                let identifiers = segues.value(forKeyPath: "identifier") as! [String]!
                return identifiers
            }
            return nil
        }
    }

    func performSegueForButton(_ button:UIButton!) -> Void {
        if let seguesIds = self.segueIdentifiers {
            let i = button.tag - kBaseTag
            let identifier = seguesIds[i]
            self.performSegue(withIdentifier: identifier, sender: button)
        }
    }

    func closeView() -> Void {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: -

    class func swizzleSelector(_ origSelector:String, withSelector:String) -> Void {
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
