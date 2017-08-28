//
//  ReflectionHelpers.swift
//
//  Created by Dominik Pich on 11/14/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

import Foundation

public class ReflectionHelpers : NSObject {
    @objc public class func getValueForProperty(_ cls: AnyObject!, name: String!) -> AnyObject! {
        guard(cls != nil) else {return nil}
        
        let m = Mirror(reflecting: cls!)
        let child1 = m.descendant(name)
        var value : AnyObject!
        
        if(child1 != nil) {
            value = valueAsNSNumber(child1 as AnyObject!) as AnyObject!
            if value == nil {
                if let any = child1, let maybeB = Mirror(reflecting: any).descendant("Some") {
                    if let b = (maybeB as AnyObject?) {
                        value = b
                    }
                }
                else {
                    value = child1 as AnyObject!
                }
            }
        }
        
        if(value != nil && value is RawRepresentable ) {
            value = valueOfTypeAsString(value)
        }
        
        return value
    }
    
    //MARK: -
    
    private class func valueAsNSNumber(_ child1: AnyObject!) -> NSNumber! {
        if(child1 != nil) {
            //bool
            if let b = child1  as? Bool {
                return NSNumber(value: b)
            }
            if let any = child1, let maybeB = Mirror(reflecting: any).descendant("Some") as? Bool {
                if let b = (maybeB as Bool?) {
                    return NSNumber(value: b)
                }
            }
            
            //Int
            if let b = child1  as? Int {
                return NSNumber(value: b)
            }
            if let any = child1, let maybeB = Mirror(reflecting: any).descendant("Some") as? Int {
                if let b = (maybeB as Int?) {
                    return NSNumber(value: b)
                }
            }
            
            //Double
            if let b = child1  as? Double {
                return NSNumber(value: b)
            }
            if let any = child1, let maybeB = Mirror(reflecting: any).descendant("Some") as? Double {
                if let b = (maybeB as Double?) {
                    return NSNumber(value: b)
                }
            }

            //Float
            if let b = child1  as? Float {
                return NSNumber(value: b)
            }
            if let any = child1, let maybeB = Mirror(reflecting: any).descendant("Some") as? Float {
                if let b = (maybeB as Float?) {
                    return NSNumber(value: b)
                }
            }
        }
        return nil
    }

    private class func valueOfTypeAsString(_ val: AnyObject!) -> AnyObject! {
        if val != nil {
            let any = val!
            let t = String(describing:any)
            return "\(t)" as AnyObject!
        }
        return nil
    }
}

