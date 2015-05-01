#import <Foundation/Foundation.h>
#import "DemoDataStructures.h"

NSString *kLeafItemPropertyKeyPath = @"container2.leafItem.property";

NSString *kContainer2Key = @"container2";
NSString *kLeafItemKey = @"leafItem";
NSString *kPropertyKey = @"property";

//------------
//KCV compatible classes
//------------
@interface Leaf : NSObject
@end
@implementation Leaf
- (id)valueForKey:(NSString  *)key {
	if ([key isEqualToString:@"property"]) {
        static id prop = nil;
        if (!prop)
            prop = @"Hallo Welt";
		return prop;
	}
	return nil;
}
@end

@interface Container2 : NSObject
@end
@implementation Container2
- (id)valueForKey:(NSString  *)key {
	if ([key isEqualToString:@"leafItem"]) {
        static id leaf = nil;
        if (!leaf)
            leaf =  [[Leaf alloc] init];
		return leaf;
	}
	return nil;
}
@end

@interface Container1 : NSObject
@end
@implementation Container1
- (id)valueForKey:(NSString  *)key {
	if ([key isEqualToString:@"container2"]) {
        static id container2 = nil;
        if (!container2)
            container2 =  [[Container2 alloc] init];
		return container2;
	}
	return nil;
}
@end

//------------
// dummy main
//------------

int main(int argc, char *argv[]) {
	@autoreleasepool {
		id<MainContainer> container = (id)[[Container1 alloc] init];
	
		//access via KVC
       	NSString *prop = [(id)container valueForKeyPath:@"container2.leafItem.property"];
        //or a tad safer but a lot more annoying version
       	prop = [(id)container valueForKeyPath:kLeafItemPropertyKeyPath];
        
        //or a yet safer but yet more annoying version (aka CORRECT) using string constants
        id container2 = [(id)container valueForKey:kContainer2Key];
        id leafItem = [container2 valueForKey:kLeafItemKey];
		NSString *prop2 = [leafItem valueForKey:kPropertyKey];
        
		//see how we use typesafe properties here although we only have KVC
        //clean, consisce, effective, self documenting
		NSString *prop3 = container.container2.leafItem.property;
	
		NSLog(@"%@ = %@ = %@", prop, prop2, prop3);
	}
}