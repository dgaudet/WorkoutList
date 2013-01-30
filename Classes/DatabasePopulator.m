//
//  DatabasePopulator.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabasePopulator.h"
#import "WorkoutListAppDelegate.h"
#import "Exercise.h"
#import "ExerciseGroup.h"
#import "WorkOutSession.h"
#import "WorkOut.h"

@interface DatabasePopulator (PrivateMethods)

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)generateAndSaveWorkOut1;
- (void)generateAndSaveWorkOut2;
- (void)generateAndSaveWorkOut3;

@end


@implementation DatabasePopulator

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

-(void)populateDatabase {
	if (managedObjectContext == nil)
	{
		managedObjectContext = [self managedObjectContext];
	}
	[self generateAndSaveWorkOut1];
	[self generateAndSaveWorkOut2];
	[self generateAndSaveWorkOut3];
}

-(void)generateAndSaveWorkOut1 {
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
	[self exerciseWithName:@"Straight Leg Raise on Tricep" weight:@"" reps:@"12" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Bench Press" weight:@"125" reps:@"11" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Incline Bench Shoulder Raise" weight:@"95" reps:@"6" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Incline Bench Press" weight:@"95" reps:@"6" exerciseGroup:exerciseGroup1];
	
	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Reverse Ab Crunch(On Ball)" weight:@"" reps:@"12" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Half Leg Hip Raise on Tricep" weight:@"" reps:@"12" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Dumbell Fly" weight:@"35" reps:@"11" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Incline Dumbell Shoulder Raise" weight:@"55" reps:@"5" exerciseGroup:exerciseGroup2];
	
	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Plank" weight:@"" reps:@"75s" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Bicycles" weight:@"" reps:@"20" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Incline Dumbell Press" weight:@"55" reps:@"4" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Dumbell Bench Press" weight:@"55" reps:@"10" exerciseGroup:exerciseGroup3];
	
	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Sit up on top pin(With Wieght)" weight:@"45" reps:@"10" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Pullover" weight:@"60" reps:@"5" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Rope Weight Raise" weight:@"2.5" reps:@"5" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Hammer Curl" weight:@"55" reps:@"10" exerciseGroup:exerciseGroup4];
	
	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Kobe" weight:@"50" reps:@"3" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Kickbacks" weight:@"40" reps:@"10" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Close Grip Bench Press" weight:@"105" reps:@"4" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Dumbell Wrist Curl" weight:@"55" reps:@"4" exerciseGroup:exerciseGroup5];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
	[self exerciseWithName:@"Side Bend" weight:@"65" reps:@"9" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Tricep Heavy Pull down" weight:@"130" reps:@"8" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Dip on Tricep" weight:@"" reps:@"12" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Barbell Wrist Curl" weight:@"70" reps:@"9" exerciseGroup:exerciseGroup6];
	
	ExerciseGroup *exerciseGroup7 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup7 setName: @"Workout Group 7"];
	[self exerciseWithName:@"Ab Roller" weight:@"" reps:@"12" exerciseGroup:exerciseGroup7];
	[self exerciseWithName:@"TriceptsExtension(French Press)" weight:@"55" reps:@"10" exerciseGroup:exerciseGroup7];
		
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[workOut setName:@"Abs/Chest/Forearm/Tricep"];
	[exerciseGroup1 setWorkOut:workOut];
	[exerciseGroup2 setWorkOut:workOut];
	[exerciseGroup3 setWorkOut:workOut];
	[exerciseGroup4 setWorkOut:workOut];
	[exerciseGroup5 setWorkOut:workOut];
	[exerciseGroup6 setWorkOut:workOut];
	[exerciseGroup7 setWorkOut:workOut];
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

-(void)generateAndSaveWorkOut2 {
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
	[self exerciseWithName:@"Barbell Bent Over Row" weight:@"105/115" reps:@"7" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Upright External Rotation" weight:@"45" reps:@"11" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Back Extention" weight:@"25" reps:@"8" exerciseGroup:exerciseGroup1];

	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Dumbell Bent Over Row" weight:@"65" reps:@"6" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Barbell Rear Delt Row" weight:@"75" reps:@"4" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Lying External Rotation" weight:@"20" reps:@"9" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Lateral Neck Flexon" weight:@"40" reps:@"7" exerciseGroup:exerciseGroup2];
	
	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Chinup" weight:@"" reps:@"10" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Barbell Shrug" weight:@"130" reps:@"3" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Neck Flexon" weight:@"40" reps:@"9" exerciseGroup:exerciseGroup3];
	
	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Dumbell Internal Rotation" weight:@"45" reps:@"11" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Shrug" weight:@"60" reps:@"6" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Underhand Chinup" weight:@"" reps:@"11" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Preacher Curl(Single)" weight:@"35" reps:@"9" exerciseGroup:exerciseGroup4];
	
	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Dumbell Concentration Curl" weight:@"45" reps:@"6" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Incline Curl" weight:@"40" reps:@"7" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Neck Extension" weight:@"40" reps:@"10" exerciseGroup:exerciseGroup5];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
	[self exerciseWithName:@"Barbell Curl" weight:@"45" reps:@"8" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Seated Dumbell Curl" weight:@"50" reps:@"4" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Elastic Curl" weight:@"" reps:@"12" exerciseGroup:exerciseGroup6];
	
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[workOut setName:@"Back/Bicep/Neck"];
	[exerciseGroup1 setWorkOut:workOut];
	[exerciseGroup2 setWorkOut:workOut];
	[exerciseGroup3 setWorkOut:workOut];
	[exerciseGroup4 setWorkOut:workOut];
	[exerciseGroup5 setWorkOut:workOut];
	[exerciseGroup6 setWorkOut:workOut];

	WorkOutSession *workOutSession = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	NSDate *currentDate = [NSDate date];
	[workOutSession setStartDate:[currentDate dateByAddingTimeInterval:-200]];
	[workOutSession setEndDate:[currentDate dateByAddingTimeInterval:-100]];
	[workOutSession setWorkOut:workOut];
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}	

-(void)generateAndSaveWorkOut3 {		
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[workOut setName:@"Shoulder/Leg"];
	
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
	[self exerciseWithName:@"Barbell Lunge" weight:@"95" reps:@"5" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Hack Squat" weight:@"95/125" reps:@"6" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Barbell Upright Row" weight:@"50" reps:@"3" exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Front Lateral Raise" weight:@"45" reps:@"5" exerciseGroup:exerciseGroup1];
	[exerciseGroup1 setWorkOut:workOut];
	
	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Rear Lunge" weight:@"95" reps:@"5" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Sidekick" weight:@"50" reps:@"10" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Lateral Raise(Both Arms)" weight:@"30" reps:@"4" exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Rear Lateral Raise(Both Arms)" weight:@"30" reps:@"10" exerciseGroup:exerciseGroup2];
	[exerciseGroup2 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Barbell Standing Leg Calf Raise" weight:@"115" reps:@"5" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Side Lunge" weight:@"85" reps:@"5" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Lying Lateral Raise" weight:@"30" reps:@"3" exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Dumbell Rear Delt Row" weight:@"65" reps:@"3" exerciseGroup:exerciseGroup3];
	[exerciseGroup3 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Hanging Straight Leg Raise(Half)" weight:@"" reps:@"12" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Lying Leg Curls" weight:@"8pl" reps:@"6" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"One Arm Lateral Raise" weight:@"45" reps:@"11" exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell One arm Upright Row" weight:@"55" reps:@"6" exerciseGroup:exerciseGroup4];
	[exerciseGroup4 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Leg Extension" weight:@"170" reps:@"4" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Dumbell Seated Shoulder Press" weight:@"50" reps:@"7" exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Dumbell Front Raise" weight:@"40" reps:@"10" exerciseGroup:exerciseGroup5];
	[exerciseGroup5 setWorkOut:workOut];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
	[self exerciseWithName:@"Dumbell Single Leg Calf Raise" weight:@"65" reps:@"10" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Arnold Press" weight:@"45" reps:@"5" exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Behind Neck Press" weight:@"50" reps:@"9" exerciseGroup:exerciseGroup6];
	[exerciseGroup6 setWorkOut:workOut];
	
	WorkOutSession *workOutSession = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	NSDate *currentDate = [NSDate date];
	[workOutSession setStartDate:[currentDate dateByAddingTimeInterval:-10200]];
	[workOutSession setEndDate:[currentDate dateByAddingTimeInterval:-1000]];
	[workOutSession setWorkOut:workOut];
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}	

- (Exercise *)exerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup1 {
	Exercise *exercise1 = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:E_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exercise1 setName: name];
	[exercise1 setWeight: weight];
	[exercise1 setReps: reps];
	[exercise1 setExerciseGroup: exerciseGroup1];
	return exercise1;
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate{
	return [self fetchManagedObjectsForEntity:entityName withPredicate:predicate withSortDescriptor:nil];
}

- (id)fetchFirstManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSArray *data = [[NSArray alloc] initWithArray:[self fetchManagedObjectsForEntity:entityName withPredicate:predicate withSortDescriptor:sortDescriptor]];
	[sortDescriptor release];
	if (data.count > 0) {
		return [data objectAtIndex:0];
	} else {
		return nil;
	}
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor {
	NSManagedObjectContext *context = [self managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	if (sortDescriptor) {
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[request setSortDescriptors:sortDescriptors];
	}
	if (predicate) {
		[request setPredicate:predicate];
	}	
	
	NSError *error;
	NSArray *fetchResults = [[[context executeFetchRequest:request error:&error] copy] autorelease];
	
	if (!fetchResults) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[request release];
	return fetchResults;
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedContext = self.managedObjectContext;
    if (managedContext != nil) {
        if ([managedContext hasChanges] && ![managedContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
 
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WorkoutList.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}

- (BOOL)databaseExists
{
	NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WorkoutList.sqlite"];
	BOOL databaseExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
	return databaseExists;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];	
	[super dealloc];
}


@end
