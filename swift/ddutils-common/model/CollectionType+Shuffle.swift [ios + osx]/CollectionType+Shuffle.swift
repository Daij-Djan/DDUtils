//
//  CollectionShuffle.swift
//  memory
//
//  Created by Dominik Pich on 4/3/16.
//  Copyright © 2016 Dominik Pich. All rights reserved.
//
import Foundation

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    
    //uniform!
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
    
    //good twice shuffle, reproducable, when given the same seed
    func shuffle(seed: Int) -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace(seed)
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    
    //uniform!
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
    
    //good twice shuffle, reproducable, when given the same seed
    mutating func shuffleInPlace(seedInt:Int) {
        let seed = UInt32(seedInt)
        srandom(seed)
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(random()) % (count - i) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
        
        //reverse
        var c = count - 1
        var i = 0
        while i < c {
            swap(&self[i],&self[c])
            i = i+1 //They remove ++ or += 1
            c = c-1 //They remove -- or -= 1
        }

        for i in 0..<count - 1 {
            let j = Int(random()) % (count - i) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
   }
}