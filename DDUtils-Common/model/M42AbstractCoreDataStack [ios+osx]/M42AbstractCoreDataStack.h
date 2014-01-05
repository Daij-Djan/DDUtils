//
//  M42AbstractCoreDataStack.h
//  Project
//
//  Created by Dominik Pich on 01.09.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface M42AbstractCoreDataStack : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;	
	NSString *modelPath;
	NSString *storePath;
	BOOL readonly;
}
- (id)initWithModelPath:(NSString*)path storePath:(NSString*)path2 readonly:(BOOL)flag;

- (BOOL)save;
- (void)close;

- (NSArray*) fetchAllObjects: (NSString *) entityDescription;
- (NSArray*) fetchAllObjects: (NSString *) entityDescription withPredicate:(NSPredicate*)predicate;

- (void) deleteAllObjects: (NSString *) entityDescription;
- (void) deleteAllObjects: (NSString *) entityDescription withPredicate:(NSPredicate*)predicate;

- (NSManagedObjectContext*)newSeperateManagedObjectContext;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain, readonly) NSString *modelPath;
@property (nonatomic, retain, readonly) NSString *storePath;
@property (assign, readonly) BOOL readonly;

@end
