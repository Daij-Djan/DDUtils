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
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .all
    }

    //MARK: - observe NSNotifications
    
    lazy var rotationObserver : NotificationObserver! = NotificationObserver(events:[NSNotification.Name.UIDeviceOrientationDidChange.rawValue: self.handleOrientationChange,
        NSNotification.Name.UIDeviceBatteryLevelDidChange.rawValue: self.handleBatteryLevelChange,
        UserDefaults.didChangeNotification.rawValue: self.handleDefaultsChange])

    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let sec3 = Int64(3 * NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(sec3) / Double(NSEC_PER_SEC)) {
            UserDefaults.standard.set(1, forKey: "integer")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(sec3) / Double(NSEC_PER_SEC)) {
                UserDefaults.standard.set(2, forKey: "integer")
            }
        }
        
        super.viewWillAppear(animated)
        rotationObserver.isObserving = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        rotationObserver.isObserving = false
        super.viewDidDisappear(animated)
    }
    
    fileprivate func handleOrientationChange(_ note:Notification) {
        var str = ""
        
        switch UIDevice.current.orientation {
        case .portrait:
            str = ".Portrait"
            break
        case .portraitUpsideDown:
            str = ".PortraitUpsideDown"
            break
        case .landscapeLeft:
            str = ".LandscapeLeft"
            break
        case .landscapeRight:
            str = ".LandscapeRight"
            break
        default:
            str = ".Unknown"
        }
        
        textView.text = textView.text + "\n\ndevice orientation: \(str)"
    }

    fileprivate func handleBatteryLevelChange(_ note:Notification) {
        let level = UIDevice.current.batteryLevel
        textView.text = textView.text + "\n\ndevice battery: \(level)"
    }
    
    fileprivate func handleDefaultsChange(_ note:Notification) {
        let myint = UserDefaults.standard.integer(forKey: "integer")
        textView.text = textView.text + "\n\ndefault integer was set to: \(myint)"
    }
}

