//
//  ViewController.swift
//  ModifiedSinceDemo
//
//  Created by Dominik Pich on 12/07/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }

    //MARK: - observe NSNotifications
    
    lazy var rotationObserver : NotificationObserver! = NotificationObserver(events:[UIDeviceOrientationDidChangeNotification: self.handleOrientationChange,
        UIDeviceBatteryLevelDidChangeNotification: self.handleBatteryLevelChange,
        NSUserDefaultsDidChangeNotification: self.handleDefaultsChange])

    override func viewWillAppear(animated: Bool) {
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        
        let sec3 = Int64(3 * NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec3), dispatch_get_main_queue()) {
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "integer")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec3), dispatch_get_main_queue()) {
                NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "integer")
            }
        }
        
        super.viewWillAppear(animated)
        rotationObserver.isObserving = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        rotationObserver.isObserving = false
        super.viewDidDisappear(animated)
    }
    
    private func handleOrientationChange(note:NSNotification) {
        var str = ""
        
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            str = ".Portrait"
            break
        case .PortraitUpsideDown:
            str = ".PortraitUpsideDown"
            break
        case .LandscapeLeft:
            str = ".LandscapeLeft"
            break
        case .LandscapeRight:
            str = ".LandscapeRight"
            break
        default:
            str = ".Unknown"
        }
        
        textView.text = "\(textView.text)\n\ndevice orientation: \(str)"
    }

    private func handleBatteryLevelChange(note:NSNotification) {
        let level = UIDevice.currentDevice().batteryLevel
        textView.text = "\(textView.text)\n\ndevice battery: \(level)"
    }
    
    private func handleDefaultsChange(note:NSNotification) {
        let myint = NSUserDefaults.standardUserDefaults().integerForKey("integer")
        textView.text = "\(textView.text)\n\ndefault integer was set to: \(myint)"
    }
}

