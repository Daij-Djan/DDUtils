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
	[managedObjectContext release];
	managedObjectContext = nil;	
	[managedObjectModel release];
	managedObjectModel = nil;
	[persistentStoreCoordinator release];
	persistentStoreCoordinator = nil;
}

- (void)dealloc {
	if(!readonly) [self save];
	[self close];
	[storePath release];
	[modelPath release];
	[super dealloc];
}

#pragma mark -
#pragma mark SQLite interface

//-(NSArray*) readArrayExecutingSql:(NSString*)sql {
//	// Setup the database object
//	static sqlite3 *database = NULL;
//	if(database == NULL)
//		if(sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) {
//			return nil;
//	
//	// Init the animals Array
//	NSMutableArray *array = [[NSMutableArray alloc] init];
//	
//	// Open the database from the users filessytem
//		// Setup the SQL Statement and compile it for faster access
//		const char *sqlStatement = "select * from animals";
//		sqlite3_stmt *compiledStatement;
//		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
//			// Loop through the results and add them to the feeds array
//			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
//				// Read the data from the result row
//				NSString *aName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
//				NSString *aDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
//				NSString *aImageUrl = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
//				
//				// Create a new animal object with the data from the database
//				Animal *animal = [[Animal alloc] initWithName:aName description:aDescription url:aImageUrl];
//				
//				// Add the animal object to the animals Array
//				[animals addObject:animal];
//				
//				[animal release];
//			}
//		}
//		// Release the compiled statement from memory
//		sqlite3_finalize(compiledStatement);
//		
//	}
////	sqlite3_close(database);
//	return array;	
//}

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
		PGLog( EXCEPTION, @"CoreDataException: M42Store cant get context" );
	}
	//	}	
	
    return moc;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	//	@synchronized(self) {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	PGLogI( @"Create MO Context");
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	if(!managedObjectContext) {
		PGLog( EXCEPTION, @"CoreDataException: M42Store cant get context" );
	}
	//	}	
	
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
		PGLog( EXCEPTION, @"Model doesn't exist at %@", modelPath );
		return nil;
	}
#endif	
	PGLogI( @"Using managedObjectModel at %@", modelUrl);
	
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
		PGLog( EXCEPTION, @"Creating Store that doesn't exist" );
		[[NSFileManager defaultManager] createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
	}

	PGLogI( @"Open sqlite store at %@", storeUrl);
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	NSDictionary *options = readonly ? [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSReadOnlyPersistentStoreOption] : nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		PGLog(EXCEPTION, @"CoreDataException: M42Store cant get persitent store from %@ :: error was %@", storeUrl, error );
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
    [fetchRequest release];
	
	if(error) {
		PGLog(ERROR, @"Failed to fetch %@ with predicate %@", entityDescription, predicate);
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
    [fetchRequest release];
	
	
    for (NSManagedObject *managedObject in items) {
        [moc deleteObject:managedObject];
        PGLogI(@"%@ object deleted",entityDescription);
    }
    if (![moc save:&error]) {
        PGLog(ERROR,@"Error deleting %@ - error:%@",entityDescription,error);
    }
	
}

@end
