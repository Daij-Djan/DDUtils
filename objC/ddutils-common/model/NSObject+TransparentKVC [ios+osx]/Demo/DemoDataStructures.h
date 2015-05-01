//
//  DemoDataStructures.h
//  test
//
//  Created by Dominik Pich on 09/12/13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>

//forward decl
@class Container1, Container2, Leaf;

//protocols
@protocol Property
@property(readonly) NSString *property;
@end

@protocol LeafContainer
@property(readonly) id<Property> leafItem;
@end

@protocol MainContainer
@property(readonly) id<LeafContainer> container2;
@end
