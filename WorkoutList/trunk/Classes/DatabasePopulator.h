//
//  DatabasePopulator.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"
#import "ExerciseGroup.h"

@interface DatabasePopulator : NSObject {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (void)saveContext;
- (BOOL)databaseExists;
- (void)populateDatabase;
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (id)fetchFirstManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (Exercise *)exerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup1;

@end
