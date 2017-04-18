//
//  AppDelegate.swift
//
//  Created by Dominik Pich on 8/10/16.
//
//

import UIKit

let BEACON_FAMILY_A = NSUUID(uuidString: "B392911F-6970-4D8E-BF37-A802D6F07B7F")!
let BEACON_FAMILY_B = NSUUID(uuidString: "11D561EE-6384-4254-A24B-D1B8C220FD12")!

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate, BeaconManagerDelegate {
    var window: UIWindow?
    let beaconsManager = BeaconManager()

    //MARK: notification handling
    
    func handleLocalNotification(note:UILocalNotification, fromLaunch:Bool) {
        guard let id = note.userInfo?["id"] as? String else {
            print("notification has no id")
            return
        }
        
        let message = note.alertBody!
        
        let tapAction = {
            print(message)
        }
        
        if(!fromLaunch) {
            print("show alert since the app is active at the moment and ios didnt show it")
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.title = id
            alert.message = message
            let action = UIAlertAction(title: "OK", style: .default, handler: { (a) in
                tapAction()
            })
            alert.addAction(action)
            
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else {
            tapAction()
        }
    }
    
    // MARK: application delegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        //allow notifs
        let types : UIUserNotificationType = [.alert]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        //setup beacon monitoring
        beaconsManager.start(regionUUIDs: [BEACON_FAMILY_A, BEACON_FAMILY_B], delegate: self)
        
        //forward notif, if any
        if let note = launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
            handleLocalNotification(note: note, fromLaunch: true)
        }
        
        return true
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        let fromLaunch = application.applicationState != .active
        handleLocalNotification(note: notification, fromLaunch:fromLaunch)
    }
        
    //MARK: beaconManager delegate
    
    func startedInRegion(regionUUID: NSUUID) {
        didEnterRegion(regionUUID: regionUUID)
    }
    
    func didEnterRegion(regionUUID: NSUUID) {
        switch regionUUID {
        case BEACON_FAMILY_A:
            didReachBeaconA()
        case BEACON_FAMILY_B:
            didReachBeaconB()
        default:
            print("ignoring unknown beacon")
        }
    }

    func didExitRegion(regionUUID: NSUUID) {
        print("didExitRegion \(regionUUID)")
    }
    
    //MARK: beacon visits to generate local notifications
    
    func didReachBeaconA() {
        print("notify")
        
        let note = UILocalNotification()
        note.userInfo = ["id": BEACON_FAMILY_A.uuidString]
        note.alertBody = "BeaconA reached"
        UIApplication.shared.presentLocalNotificationNow(note)
    }
    
    func didReachBeaconB() {
        print("notify")
        
        let note = UILocalNotification()
        note.userInfo = ["id": BEACON_FAMILY_B.uuidString]
        note.alertBody = "BeaconB reached"
        UIApplication.shared.presentLocalNotificationNow(note)
    }
}

