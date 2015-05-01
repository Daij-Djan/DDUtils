//
//  String+fileName.swift
//  CoprightModifier
//
//  Created by Dominik Pich on 04/09/14.
//  Copyright (c) 2014 Dominik Pich. All rights reserved.
//

import Foundation

extension String {
    var fileName:String {
        //poor sanitasation
        var string = self as NSString;
        var sanitizedString = string.mutableCopy() as NSMutableString
            
            sanitizedString.replaceOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString(")", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("/", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("\\", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("&", withString:"and", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("?", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("'", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString("\"", withString:"", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
        sanitizedString.replaceOccurrencesOfString(" ", withString:"-", options: NSStringCompareOptions.allZeros, range: NSMakeRange(0, sanitizedString.length))
            
        return sanitizedString
    }
}