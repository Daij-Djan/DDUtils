//
//  NSObject+DDDump.m
//  OMMiniXcode
//
//  Created by Dominik Pich on 9/17/12.
//
//

#import "NSObject+DDDump.h"
#import <objc/runtime.h>

@implementation NSObject (DDDump)

- (NSString *)dump {
    NSDictionary *reflection = self.reflection;

    NSMutableString *dump = [NSMutableString string];
    [dump appendFormat:@"%@ : %@ <%@> {\n%@}\n%@\n\%@",
     [reflection valueForKeyPath:@"class.name"],
     [reflection valueForKeyPath:@"superclass.name"],
     [reflection valueForKeyPath:@"protocols.name"],
     [reflection valueForKeyPath:@"variables.name"],
     [reflection valueForKeyPath:@"properties.name"],
     [reflection valueForKeyPath:@"methods.name"]];
    
    return dump;
}

- (NSDictionary*)reflection {
    NSMutableDictionary *reflect = [NSMutableDictionary dictionary];
    
    //class
    const char *name = class_getName(self.class);
    [reflect setObject:@{@"name": @(name)} forKey:@"class"];

    //superclass
    Class superClass = class_getSuperclass(self.class);
    if(superClass) {
        const char *name = class_getName(superClass);
        [reflect setObject:@{@"name": @(name)} forKey:@"superclass"];
    }
    
    //protocols
    unsigned int cProtocols = 0;
    Protocol * __unsafe_unretained *protos = class_copyProtocolList(self.class, &cProtocols);
    if(cProtocols) {
        NSMutableArray *protocols = [NSMutableArray arrayWithCapacity:cProtocols];
        for(int i = 0; i < cProtocols; i++) {
            const char *name = protocol_getName(protos[i]);
            [protocols addObject:@{@"name": @(name)}];
        }
        [reflect setObject:protocols forKey:@"protocols"];
    }
    
    //ivars
    unsigned int cVars = 0;
    Ivar *vars = class_copyIvarList(self.class, &cVars);
    if(cVars) {
        NSMutableArray *variables = [NSMutableArray arrayWithCapacity:cVars];
        for(int i = 0; i < cVars; i++) {
            const char *name = ivar_getName(vars[i]);
            const char *type = ivar_getTypeEncoding(vars[i]);
            [variables addObject:@{@"name": @(name), @"type": @(type)}];
        }
        [reflect setObject:variables forKey:@"variables"];
    }
    
    //properties
    unsigned int cProperties = 0;
    objc_property_t *props = class_copyPropertyList(self.class, &cProperties);
    if(cProperties) {
        NSMutableArray *properties = [NSMutableArray arrayWithCapacity:cProperties];
        for(int i = 0; i < cProperties; i++) {
            const char *attr = property_getAttributes(props[i]);
            const char *name = property_getName(props[i]);
            [properties addObject:@{@"name": @(name), @"attributes": @(attr)}];
        }
        [reflect setObject:properties forKey:@"properties"];
    }

    //methods
    unsigned int cMethods = 0;
    Method *ms = class_copyMethodList(self.class, &cMethods);
    if(cMethods) {
        NSMutableArray *methods = [NSMutableArray arrayWithCapacity:cMethods];
        for(int i = 0; i < cMethods; i++) {
            const char *type = method_getTypeEncoding(ms[i]);
            SEL name = method_getName(ms[i]);
            [methods addObject:@{@"name": NSStringFromSelector(name), @"type": @(type)}];
        }
        [reflect setObject:methods forKey:@"methods"];
    }

    return reflect;
}

@end
