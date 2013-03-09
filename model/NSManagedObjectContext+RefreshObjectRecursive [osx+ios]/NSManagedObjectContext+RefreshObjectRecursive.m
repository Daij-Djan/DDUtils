//
//  NSManagedObjectContext+RefreshObjectRecursive.m
//  myAudi
//
//  Created by Dominik Pich on 09.03.13.
//

#import "NSManagedObjectContext+RefreshObjectRecursive.h"

@implementation NSManagedObjectContext (RefreshObjectRecursive)

- (void)refreshObject:(NSManagedObject*)object mergeChanges:(BOOL)mergeChanges recursive:(BOOL)recursive {
    [self refreshObject:object mergeChanges:mergeChanges recursive:recursive doneObjects:recursive?[NSMutableSet set]:nil];
}

- (void)refreshObject:(NSManagedObject*)object mergeChanges:(BOOL)mergeChanges recursive:(BOOL)recursive doneObjects:(NSMutableSet*)doneObjects {
    //prevent us from going in circles
    if([doneObjects containsObject:object.objectID])
        return;
    [doneObjects addObject:object.objectID];
    
    if(object.isFault)
        return;
    
    //visit all non-transient relations
    if(recursive) {
        NSDictionary *relationshipsByName = object.entity.relationshipsByName;
        for(NSString *relationshipName in relationshipsByName) {
            if(![object hasFaultForRelationshipNamed:relationshipName]) {
                NSRelationshipDescription *relationship = [relationshipsByName objectForKey:relationshipName];
                if(!relationship.isTransient) {
                    NSSet *relation = [object valueForKey:relationshipName];
                    
                    if([relation isKindOfClass:[NSManagedObject class]]) {
                        [self refreshObject:(NSManagedObject*)relation mergeChanges:mergeChanges recursive:YES doneObjects:doneObjects];
                    }
                    else {
                        for (NSManagedObject *child in relation) {
                            [self refreshObject:child mergeChanges:mergeChanges recursive:YES doneObjects:doneObjects];
                        }
                    }
                }
            }
        }
    }

    [self refreshObject:object mergeChanges:mergeChanges];
}

@end
