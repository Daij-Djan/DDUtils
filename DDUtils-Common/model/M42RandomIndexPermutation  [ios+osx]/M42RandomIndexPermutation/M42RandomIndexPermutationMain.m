//
//  main.m
//  M42RandomIndexPermutation
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M42RandomIndexPermutation.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        M42RandomIndexPermutation *permutation = [[M42RandomIndexPermutation alloc] initWithCount:46 usingSeed:0];   
        NSLog(@"0 mixed as 0 : %@", permutation);
//        for(int i=0;i<permutation.count;i++) {
//            printf("%ld, ", permutation.indices[i);
//        }
        
        [permutation remixUsingSeed:1];
        NSLog(@"0 mixed as 1 : %@", permutation);
//        for(int i=0;i<permutation.count;i++) {
//            printf("%ld, ", permutation.next);
//        }

        M42RandomIndexPermutation *permutation2 = [[M42RandomIndexPermutation alloc] initWithCount:46 usingSeed:1];   
        NSLog(@"1 mixed as 1 : %@", permutation2 );
//        for(int i=0;i<permutation2.count;i++) {
//            printf("%ld, ", permutation2.next);
//        }
        
        NSLog(@"perms equal? %d", [permutation isEqual:permutation2]);
        
}
    
    return 0;
}

