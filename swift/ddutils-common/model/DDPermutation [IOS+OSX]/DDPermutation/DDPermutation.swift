//
//  DDPermutation.m
//
//  First Created by Dominik Pich on 17.08.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//
// swiftfied 2015
//
import Foundation

class DDPermutation<T> : Equatable, SequenceType {

    private let seedUsed: UInt32
    private let indexes: [Int] //indices is taken
    private let data: [T] //indices is taken
    
    init(dataArray:Array<T>, usingSeed:UInt32) {
        seedUsed = usingSeed
        data = dataArray;
        indexes = DDPermutation.remix(dataArray.count, seed: usingSeed)
    }

    private class func remix(count:Int, seed:UInt32) -> [Int] {
        var myIndexes = [Int]()
        for (var index = 0; index < count; index++) {
            myIndexes.append(index)
        }
        
        srand(seed)
        for (var index = 0; index < count; index++) {
            let swap = myIndexes[index]
            let destinationIndex = Int(rand()) % (count - index) + index
            myIndexes[index] = myIndexes[destinationIndex]
            myIndexes[destinationIndex] = swap
        }

        return myIndexes
    }
    
    func generate() -> GeneratorOf<T> {
        var nextIndex = 0
        
        return GeneratorOf<T> {
            if (nextIndex < self.indexes.count) {
                let index = self.indexes[nextIndex++]
                return self.data[index]
            }
            return nil
        }
    }
    
    //MARK: public
    
    var allIndexes: [Int] {
        return indexes
    }
    
    var description: String {
        var buf = NSMutableString(string: NSString(format: "permutation (%lu) :: ", indexes.count))
        
        for(var i = 0; i < indexes.count; i++) {
            if (i > 0) {
                buf.appendString(" ")
            }

            buf.appendFormat(" %lu", indexes[i])
        }
        
        return buf as String
    }
}

func == <T> (perm1:DDPermutation<T>, perm2:DDPermutation<T>) -> Bool {
    return (perm1.seedUsed == perm2.seedUsed) && (perm1.indexes == perm2.indexes)
}
func permutate<T>(array:Array<T>, seed:UInt32) -> DDPermutation<T> {
    return DDPermutation<T>(dataArray: array, usingSeed: seed)
}
func permutate<T>(permutation:DDPermutation<T>, seed:UInt32) -> DDPermutation<T> {
    return DDPermutation<T>(dataArray: permutation.data, usingSeed: seed)
}