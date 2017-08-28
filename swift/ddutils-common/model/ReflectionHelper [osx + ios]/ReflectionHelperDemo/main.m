//
//  main.m
//  ReflectionHelpers
//
//  Created by Dominik Pich on 24.08.17.
//  Copyright © 2017 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

//make selector known
@interface NSObject (add)
+ (id)getValueForProperty:(id)obj name:(NSString*)propertyName;
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Class Helper = objc_getClass("ReflectionHelperDemoObjC.ReflectionHelpers"); //module name + class name
        Class Testable = objc_getClass("ReflectionHelperDemoObjC.TestDummy"); //module name + class name
        
        id rootNode = [[Testable alloc] init];
        
        //string
        assert([[Helper getValueForProperty:rootNode name:@"addressLine1"] isEqualToString:@"adasdLine1"]);
        assert([[Helper getValueForProperty:rootNode name:@"addressLine2"] isEqualToString:@"tempLine2"]);

        //double
        assert([[Helper getValueForProperty:rootNode name:@"decimalTest"] isEqualToNumber:@(12.34)]);

        //bool
        assert([[Helper getValueForProperty:rootNode name:@"addressMatch"] boolValue]);
        
        //enum
        assert([[Helper getValueForProperty:rootNode name:@"test"] isEqualToString:@"ReflectionHelperDemoObjC.TestDummy.TestMe.X"]);
        
        //objc object
        assert([[[Helper getValueForProperty:rootNode name:@"locale"] localeIdentifier] isEqualToString:@"en_US_POSIX"]);
        
        //swift obj
        id inner = [Helper getValueForProperty:rootNode name:@"inner"];
        assert(inner);
        assert([[Helper getValueForProperty:inner name:@"test"] isEqualToString:@"String"]);
    }
    return 0;
}
