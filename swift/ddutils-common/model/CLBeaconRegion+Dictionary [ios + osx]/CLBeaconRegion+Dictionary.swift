//
//  CLBeaconRegionUtils.swift
//  ibeacon-background-demo-swift
//
//  Created by Dominik Pich on 05/06/14.
//  Copyright (c) 2014 Dominik Pich. All rights reserved.
//

import CoreLocation

extension CLBeaconRegion {
    class func fromDictionary(dictionary:Dictionary<String, AnyObject>) -> CLBeaconRegion? {
        //read dict
        var uuidString:AnyObject! = dictionary["uuid"]
        let identifier:AnyObject! = dictionary["identifier"]
        let major: Int? = dictionary["major"] ? dictionary["major"]!.integerValue : nil
        let minor: Int? = dictionary["minor"] ? dictionary["minor"]!.integerValue : nil

        if(!uuidString) {
            println("region needs a uuid")
            return nil
        }
        
        if(!identifier) {
            println("region needs an identifier")
            return nil
        }
        let id = identifier as String

        let uuid : NSUUID? = NSUUID(UUIDString: uuidString as String)
        if(!uuid) {
            println("region needs a valid uuid")
            return nil
        }
        println(uuid!.UUIDString)
        
        //make CLRegion
        var clRegion: CLBeaconRegion
        if let ma = major {
            if  let mi = minor {
                clRegion = CLBeaconRegion(proximityUUID: uuid,
                    major: CLBeaconMajorValue(ma),
                    minor: CLBeaconMinorValue(mi),
                    identifier: id)
            }
            else {
                clRegion = CLBeaconRegion(proximityUUID: uuid,
                    major: CLBeaconMajorValue(ma),
                    identifier: id)
            }
        }
        else {
            clRegion = CLBeaconRegion(proximityUUID: uuid,
                identifier: id)
        }
        
        return clRegion;
    }

    func toDictionary() -> Dictionary<String, AnyObject> {
        var dict = Dictionary<String, AnyObject>()
        dict["uuid"] = self.proximityUUID.UUIDString;
        dict["identifier"] = self.identifier;
        if self.major {
            dict["major"] = self.major;
        }
        if self.minor {
            dict["minor"] = self.minor;
        }
        return dict
    }
}
