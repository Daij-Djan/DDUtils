//
//  DDPermutation.m
//
//  First Created by Dominik Pich on 17.08.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//
// swiftfied 2015
//
import Foundation

class DDPermutation<T> : Equatable, Sequence {

    fileprivate let seedUsed: UInt32
    fileprivate let indexes: [Int] //indices is taken
    fileprivate let data: [T] //indices is taken
    
    init(dataArray:Array<T>, usingSeed:UInt32) {
        seedUsed = usingSeed
        data = dataArray;
        indexes = DDPermutation.remix(dataArray.count, seed: usingSeed)
    }

    fileprivate class func remix(_ count:Int, seed:UInt32) -> [Int] {
        var myIndexes = [Int]()
        for index in 0 ..< count {
            myIndexes.append(index)
        }
        
        seed_random(seed)
        for index in 0 ..< count {
            let swap = myIndexes[index]
            let destinationIndex = Int(next_random()) % (count - index) + index
            myIndexes[index] = myIndexes[destinationIndex]
            myIndexes[destinationIndex] = swap
        }

        return myIndexes
    }
    
    func makeIterator() -> DDPermutationIterator<T> {
        return DDPermutationIterator<T>(self)
    }
    
    //MARK: public
    
    var allIndexes: [Int] {
        return indexes
    }
    
    var description: String {
        let buf = NSMutableString(string: NSString(format: "permutation (%lu) :: ", indexes.count))
        
        for i in 0 ..< indexes.count {
            if (i > 0) {
                buf.append(" ")
            }

            buf.appendFormat(" %lu", indexes[i])
        }
        
        return buf as String
    }
}

func == <T> (perm1:DDPermutation<T>, perm2:DDPermutation<T>) -> Bool {
    return (perm1.seedUsed == perm2.seedUsed) && (perm1.indexes == perm2.indexes)
}
func permutate<T>(_ array:Array<T>, seed:UInt32) -> DDPermutation<T> {
    return DDPermutation<T>(dataArray: array, usingSeed: seed)
}
func permutate<T>(_ permutation:DDPermutation<T>, seed:UInt32) -> DDPermutation<T> {
    return DDPermutation<T>(dataArray: permutation.data, usingSeed: seed)
}

struct DDPermutationIterator<T>: IteratorProtocol {
    let permutation: DDPermutation<T>
    var nextIndex = 0
    
    init(_ permutation: DDPermutation<T>) {
        self.permutation = permutation
    }
    
    mutating func next() -> T? {
        if (nextIndex < permutation.indexes.count) {
            let index = permutation.indexes[nextIndex]
            nextIndex += 1
            return permutation.data[index]
        }
        return nil
    }
}
