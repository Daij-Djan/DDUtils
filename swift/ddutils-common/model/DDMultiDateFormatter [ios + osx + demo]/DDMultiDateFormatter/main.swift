//
//  main.swift
//  DDMultiDateFormatter
//
//  Created by Dominik Pich on 1/3/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//

import Foundation

//as a note... the more dates the longer ;)

let df = DDMultiDateFormatter()

print("df = ", df)

print("1. test = ", df.dateFromString("2015-01-25T09:37:07Z"))
print("2. test = ", df.dateFromString("2015-01-25T09:37:07.001Z"))
print("3. test = ", df.dateFromString("2015-01-25T09:37:07+01:00"))
print("4. test = ", df.dateFromString("2015-01-25T09:37:07.0012+01:30"))
print("5a. test = ", df.dateFromString("201501250937Z")) //should fail as we havent added a formatter
print("6a. test = ", df.dateFromString("201501250937+01")) //should fail as we havent added a formatter

df.addNewFormatter { (newFormatter) -> Void in
    newFormatter.dateFormat = "yyyyMMddHHmmXXXXX"
}

print("5b. test = ", df.dateFromString("201501250937Z"))
print("6b. test = ", df.dateFromString("201501250937+2"))
print("7a test = ", df.dateFromString("20150125")) //should fail as we havent added a formatter

df.addNewFormatter { (newFormatter) -> Void in
    newFormatter.dateFormat = "yyyyMMdd"
}

print("7b test = ", df.dateFromString("20150125"))
