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

- (NSString  *)dump {
    return [NSObject dumpOfClass:self.class];
}

+ (NSString  *)dumpOfClass:(Class)cls {
    NSDictionary *reflection = [self reflectionOfClass:cls];

    NSMutableString *dump = [NSMutableString string];
    [dump appendFormat:@"%@ : %@ <%@> {\n%@}\n%@\n\%@",
     [reflection valueForKeyPath:@"class.name"],
     [reflection valueForKeyPath:@"superclass.name"],
     [reflection valueForKeyPath:@"protocols.name"],
     [reflection valueForKeyPath:@"variables.name"],
     [reflection valueForKeyPath:@"properties.name"],
     [reflection valueForKeyPath:@"methods.description"]];
    return dump;
}

- (NSDictionary  *)reflection {
    return [NSObject reflectionOfClass:self.class];
}

+ (NSDictionary *)reflectionOfClass:(Class)cls {
    NSMutableDictionary *reflect = [NSMutableDictionary dictionary];
    
    //class
    const char *name = class_getName(cls);
    [reflect setObject:@{@"name": @(name)} forKey:@"class"];

    //superclass
    Class superClass = class_getSuperclass(cls);
    if (superClass) {
        const char *name = class_getName(superClass);
        [reflect setObject:@{@"name": @(name)} forKey:@"superclass"];
    }
    
    //protocols
    unsigned int cProtocols = 0;
    Protocol *__unsafe_unretained *protos = class_copyProtocolList(cls, &cProtocols);
    if (cProtocols) {
        NSMutableArray *protocols = [NSMutableArray arrayWithCapacity:cProtocols];
        for (int i = 0; i < cProtocols; i++) {
            const char *name = protocol_getName(protos[i]);
            [protocols addObject:@{@"name": @(name)}];
        }
        [reflect setObject:protocols forKey:@"protocols"];
    }
    
    //ivars
    unsigned int cVars = 0;
    Ivar *vars = class_copyIvarList(cls, &cVars);
    if (cVars) {
        NSMutableArray *variables = [NSMutableArray arrayWithCapacity:cVars];
        for (int i = 0; i < cVars; i++) {
            const char *name = ivar_getName(vars[i]);
            const char *type = ivar_getTypeEncoding(vars[i]);
            [variables addObject:@{@"name": @(name), @"type": @(type)}];
        }
        [reflect setObject:variables forKey:@"variables"];
    }
    
    //properties
    unsigned int cProperties = 0;
    objc_property_t *props = class_copyPropertyList(cls, &cProperties);
    if (cProperties) {
        NSMutableArray *properties = [NSMutableArray arrayWithCapacity:cProperties];
        for (int i = 0; i < cProperties; i++) {
            const char *attr = property_getAttributes(props[i]);
            const char *name = property_getName(props[i]);
            [properties addObject:@{@"name": @(name), @"attributes": @(attr)}];
        }
        [reflect setObject:properties forKey:@"properties"];
    }

    //methods
    unsigned int cMethods = 0;
    Method *ms = class_copyMethodList(cls, &cMethods);
    if (cMethods) {
        NSMutableArray *methods = [NSMutableArray arrayWithCapacity:cMethods];
        for (int i = 0; i < cMethods; i++) {
            const char *type = method_getTypeEncoding(ms[i]);
            if (!type) type = "";

            SEL s = method_getName(ms[i]);
            NSString *name = NSStringFromSelector(s);
            [methods addObject:@{@"name": name, @"type": @(type), @"description": [NSString stringWithFormat:@"%@ %s", name, type]}];
        }
        [reflect setObject:methods forKey:@"methods"];
    }
    return reflect;
}

+ (NSArray  *)classDumps {
    int numClasses;
    Class *classes = NULL;
    NSMutableArray *dumps = nil;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 ) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);

        dumps = [NSMutableArray arrayWithCapacity:numClasses];
        for (int i = 0; i < numClasses; i++) {
            @try {
                Method s = class_getInstanceMethod(classes[i], @selector(doesNotRecognizeSelector:));
                if (!s) {
                    NSLog(@"%s doesnt implement doesNotRecognizeSelector and is no NSObject, skip it", class_getName(classes[i]));
                    continue;
                }
                [dumps addObject:[classes[i] dump]];
            }
            @catch (NSException *e) {
                NSLog(@"Exception %@ ignored during dumping", [e name]);
            }
        }
        free(classes);
    }
    return dumps;
}

@end
