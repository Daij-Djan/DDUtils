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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //setup ews
        EWSProfileImages.shared.credentials = (host:"webmail.sapient.com", username: "TODO", password: "TODO")

        return true
    }
}

