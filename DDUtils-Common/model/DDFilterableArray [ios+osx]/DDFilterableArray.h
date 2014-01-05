//
//  DDFilterableArray.h
//  filterableArrayDemo
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDFilterableArray : NSArray
- (instancetype)initWithArray:(NSArray *)array;
    
///if key is a NSPredicate, returns filtered array, if it is a String, tries to parse it as a predicate and use it for filtering.
//retuns nil if not valid
- (id)objectForKeyedSubscript:(id)key;
@end

@interface DDMutableFilterableArray : NSMutableArray
- (instancetype)init;
- (instancetype)initWithArray:(NSArray *)array;

///if key is a NSPredicate, returns filtered array, if it is a String, tries to parse it as a predicate and use it for filtering.
//retuns nil if not valid
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSArray (DDFilterableArray)
- (id)filterableCopy;
@end