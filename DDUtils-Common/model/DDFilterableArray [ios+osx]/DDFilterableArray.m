//
//  DDFilterableArray.m
//  filterableArrayDemo
//
//  Created by Dominik Pich on 19/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "DDFilterableArray.h"

#pragma mark -
#pragma mark immutable
#pragma mark -

@implementation DDFilterableArray {
    NSArray *_backingStore;
}
- (instancetype)initWithArray:(NSArray *)array {
    NSParameterAssert(array);
    self = [super init];
    if(self) {
        _backingStore = array;
    }
    return self;
}
- (NSUInteger)count {
    return _backingStore.count;
}
- (id)objectAtIndex:(NSUInteger)index {
    return [_backingStore objectAtIndex:index];
}

- (id)objectForKeyedSubscript:(id)key {
    NSPredicate *predicate = [key isKindOfClass:[NSPredicate class]] ? key : nil;
    if(!predicate && [key isKindOfClass:[NSString class]]) {
        predicate = [NSPredicate predicateWithFormat:key];
    }
    return predicate ? [[self->_backingStore filteredArrayUsingPredicate:predicate] filterableCopy] : nil;
}
- (id)copyWithZone:(NSZone *)zone {
    DDFilterableArray *newArray = [[DDFilterableArray alloc] initWithArray:_backingStore];
    return newArray;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    DDMutableFilterableArray *newArray = [[DDMutableFilterableArray alloc] initWithArray:[_backingStore mutableCopy]];
    return newArray;
}
@end

#pragma mark -
#pragma mark Mutable
#pragma mark -

@implementation DDMutableFilterableArray {
    NSMutableArray *_backingStore;
}
- (instancetype)init {
    self = [super init];
    if(self) {
        _backingStore = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithArray:(NSArray *)array {
    NSParameterAssert(array);
    self = [super init];
    if(self) {
        _backingStore = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}
- (NSUInteger)count {
    return _backingStore.count;
}
- (id)objectAtIndex:(NSUInteger)index {
    return [_backingStore objectAtIndex:index];
}
- (void)addObject:(id)anObject {
    [_backingStore addObject:anObject];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_backingStore insertObject:anObject atIndex:index];
}
- (void)removeLastObject {
    [_backingStore removeLastObject];
}
- (void)removeObjectAtIndex:(NSUInteger)index {
    [_backingStore removeObjectAtIndex:index];
}
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_backingStore replaceObjectAtIndex:index withObject:anObject];
}

- (id)objectForKeyedSubscript:(id)key {
    NSPredicate *predicate = [key isKindOfClass:[NSPredicate class]] ? key : nil;
    if(!predicate && [key isKindOfClass:[NSString class]]) {
        predicate = [NSPredicate predicateWithFormat:key];
    }
    return predicate ? [[self->_backingStore filteredArrayUsingPredicate:predicate] filterableCopy] : nil;
}

- (id)copyWithZone:(NSZone *)zone {
    DDFilterableArray *newArray = [[DDFilterableArray alloc] initWithArray:_backingStore];
    return newArray;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    DDMutableFilterableArray *newArray = [[DDMutableFilterableArray alloc] initWithArray:_backingStore.mutableCopy];
    return newArray;
}

@end

#pragma mark -
#pragma mark Helper Category
#pragma mark -

@implementation NSArray (DDFilterableArray)

- (id)filterableCopy {
    if([self isKindOfClass:[NSMutableArray class]])
        return [[DDMutableFilterableArray alloc] initWithArray:self];
    else
        return [[DDFilterableArray alloc] initWithArray:self];
}

@end
