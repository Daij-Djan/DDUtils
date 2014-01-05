//
//  M42AbstractCoreDataStack.m
//  Project
//
//  Created by Dominik Pich on 01.09.10.
//  Copyright 2010 Medicus 42 GmbH. All rights reserved.
//

#import "M42AbstractCoreDataStack.h"


@implementation M42AbstractCoreDataStack

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

@synthesize modelPath;
@synthesize storePath;
@synthesize readonly;

- (id)initWithModelPath:(NSString*)path storePath:(NSString*)path2 readonly:(BOOL)flag {
	self = [super init];
	if(self) {
		modelPath = [path copy];
		storePath = [path2 copy];
		readonly = flag; // DOH!
	}
	return self;
}

- (BOOL)save {
	NSError *error = nil;
	BOOL res = [self.managedObjectContext save:&error];
	if(!res) {
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
	
	return res;
}

- (void)close {
	managedObjectContext = nil;
	managedObjectModel = nil;
	persistentStoreCoordinator = nil;
}

- (void)dealloc {
	if(!readonly) [self save];
	[self close];
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext*)newSeperateManagedObjectContext {
	NSManagedObjectContext *moc = nil;
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		moc = [[NSManagedObjectContext alloc] init];
		[moc setPersistentStoreCoordinator: coordinator];
	}
	
	if(!moc) {
		NSLog(@"EXCEPTION: CoreDataException: M42Store cant get context" );
	}

    return moc;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}

	NSLog( @"INFO: Create MO Context");
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	if(!managedObjectContext) {
		NSLog( @"EXCEPTION: CoreDataException: M42Store cant get context" );
	}
	
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
	//path in bundle
	NSURL *modelUrl = [NSURL fileURLWithPath: modelPath];
#ifdef DEBUG 
	if(![[NSFileManager defaultManager] fileExistsAtPath:modelPath]) {
		NSLog( @"EXCEPTION: Model doesn't exist at %@", modelPath );
		return nil;
	}
#endif	
	NSLog( @"INFO: Using managedObjectModel at %@", modelUrl);
	
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	//create in document directory
	NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	//create store
	NSError *error = nil;

	if(!readonly && ![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
		NSLog( @"INFO: Creating Store that doesn't exist" );
		[[NSFileManager defaultManager] createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
	}

	NSLog( @"INFO: Open sqlite store at %@", storeUrl);
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	NSDictionary *options = readonly ? [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSReadOnlyPersistentStoreOption] : nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		NSLog(@"EXCEPTION: CoreDataException: M42Store cant get persitent store from %@ :: error was %@", storeUrl, error );
        
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
    }    
		
    return persistentStoreCoordinator;
}

- (NSArray*) fetchAllObjects: (NSString *) entityDescription  {
	return [self fetchAllObjects:entityDescription withPredicate:nil];
}

- (NSArray*) fetchAllObjects: (NSString *) entityDescription withPredicate:(NSPredicate*)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
	if(predicate)
		[fetchRequest setPredicate:predicate];
	
    NSError *error = nil;
    NSArray *items = [moc executeFetchRequest:fetchRequest error:&error];
	
	if(error) {
		NSLog(@"ERROR: Failed to fetch %@ with predicate %@", entityDescription, predicate);
	}
	
	return items;
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
	[self deleteAllObjects:entityDescription withPredicate:nil];
}

- (void) deleteAllObjects: (NSString *) entityDescription withPredicate:(NSPredicate*)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *moc = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
	if(predicate)
		[fetchRequest setPredicate:predicate];
	
    NSError *error = nil;
    NSArray *items = [moc executeFetchRequest:fetchRequest error:&error];
	
    for (NSManagedObject *managedObject in items) {
        [moc deleteObject:managedObject];
        NSLog(@"INFO: %@ object deleted",entityDescription);
    }
    if (![moc save:&error]) {
        NSLog(@"ERROR: Error deleting %@ - error:%@",entityDescription,error);
    }
	
}

@end
