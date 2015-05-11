//
//  main.swift
//  M42RandomIndexPermutation
//
//  Created by Dominik Pich on 11/05/15.
//  Copyright (c) 2015 Dominik Pich. All rights reserved.
//

import Foundation

println("Hello, World!")

let data = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

println("seed 0")
var permutation0 = permutate(data, 0)
var idx = permutation0.allIndexes
var i = 0
for obj in permutation0 {
    println("\(obj) at \(idx[i++])")
}

println("seed 1")
var permutation1 = permutate(permutation0, UInt32(NSDate().timeIntervalSince1970))
idx = permutation1.allIndexes
i = 0
for obj in permutation1 {
    println("\(obj) at \(idx[i++])")
}

println("seed 0 (second try")
var permutation2 = permutate(data, 0)
idx = permutation2.allIndexes
i = 0
for obj in permutation1 {
    println("\(obj) at \(idx[i++])")
}

println("seed 1 (second try")
var permutation3 = permutate(permutation2, UInt32(NSDate().timeIntervalSince1970))
idx = permutation3.allIndexes
i = 0
for obj in permutation3 {
    println("\(obj) at \(idx[i++])")
}

println("permutation0 == permutation2? \(permutation0 == permutation2)")
println("permutation1 == permutation3? \(permutation1 == permutation3)")
println("permutation1 != permutation2? \(permutation1 != permutation2)")