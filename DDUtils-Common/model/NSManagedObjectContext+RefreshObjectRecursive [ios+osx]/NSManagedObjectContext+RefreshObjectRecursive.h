//
//  NSManagedObjectContext+RefreshObjectRecursive.h
//
//  Created by Dominik Pich on 09.03.13.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (RefreshObjectRecursive)

- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)mergeChanges recursive:(BOOL)recursive;

@end
