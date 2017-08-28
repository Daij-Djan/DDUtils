//
//  main.swift
//  ReflectionHelperDemoSwift
//
//  Created by Dominik Pich on 28.08.17.
//  Copyright © 2017 Dominik Pich. All rights reserved.
//

import Foundation

typealias Helper = ReflectionHelpers
let rootNode = TestDummy()

//string
assert( Helper.getValueForProperty(rootNode, name:"addressLine1") as? String ?? "" == "adasdLine1" )
assert( Helper.getValueForProperty(rootNode, name:"addressLine2") as? String == "tempLine2" )

//bool
assert( Helper.getValueForProperty(rootNode, name:"addressMatch") as? Bool ?? false )

//enum [as string]
assert( Helper.getValueForProperty(rootNode, name:"test") as? String ?? "" == "ReflectionHelperDemoSwift.TestDummy.TestMe.X" )

//objC object
let l = Helper.getValueForProperty(rootNode, name:"locale")
assert( l?.value(forKey: "localeIdentifier") as? String ?? "" == "en_US_POSIX" )

//swift object
let inner = Helper.getValueForProperty(rootNode, name:"inner")
assert( inner != nil )
assert( Helper.getValueForProperty(inner, name:"test") as? String ?? "" == "String" )
