//
//  AppDelegate.swift
//  EWSProfileImageDemo
//
//  Created by Dominik Pich on 7/9/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //setup ews
        EWSProfileImages.shared.credentials = (host:"webmail.sapient.com", username: "dpich", password: "***REMOVED***")

        return true
    }
}

