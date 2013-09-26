//
//  ExerciseService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseService.h"
#import "DatabasePopulator.h"

@interface ExerciseService (PrivateMethods)

- (void)createExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup;

@end

@implementation ExerciseService

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

- (BOOL)deleteExercise:(Exercise *)exercise {
	[[[DatabasePopulator sharedInstance] managedObjectContext] deleteObject:exercise];
	
	NSError *error;
	if (![[[DatabasePopulator sharedInstance] managedObjectContext] save:&error]) {
		// Handle the error.
		NSLog(@"Saving changes failed: %@", error);		
	} else {
		return TRUE;
	}

	return FALSE;
}

- (BOOL)updateExercise:(Exercise *)exercise {
	NSError *error;
	if (![[[DatabasePopulator sharedInstance] managedObjectContext] save:&error]) {
		// Handle the error.
		NSLog(@"Saving changes failed: %@", error);		
	} else {
		return TRUE;
	}
	
	return FALSE;	
}

- (void)saveExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup {
    [self createExerciseWithName:name weight:weight reps:reps exerciseGroup:exerciseGroup];
    
    [[DatabasePopulator sharedInstance] saveContext];
}

- (void)createExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup {
    NSManagedObjectContext *managedObjectContext = [[DatabasePopulator sharedInstance] managedObjectContext];
	Exercise *exercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:E_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exercise setName: name];
	[exercise setWeight: weight];
	[exercise setReps: reps];
	[exercise setExerciseGroup: exerciseGroup];
}

@end
