//
//  ExerciseService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseService.h"
#import "ManagedObjectContextService.h"
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

- (id)init {
    self = [super init];
    if (self) {
        _managedObjectContextService = [ManagedObjectContextService sharedInstance];
    }
    return self;
}

- (BOOL)deleteExercise:(Exercise *)exercise {
	[[[DatabasePopulator sharedInstance] managedObjectContext] deleteObject:exercise];
	
	return [_managedObjectContextService saveContextSuccessOrFail];
}

- (BOOL)updateExercise:(Exercise *)exercise {
    return [_managedObjectContextService saveContextSuccessOrFail];
}

- (void)saveExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup {
    [self createExerciseWithName:name weight:weight reps:reps exerciseGroup:exerciseGroup];
    
    [_managedObjectContextService saveContext];
}

- (void)createExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup {
    NSManagedObjectContext *managedObjectContext = [_managedObjectContextService managedObjectContext];
	Exercise *exercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:E_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[exercise setName: name];
	[exercise setWeight: weight];
	[exercise setReps: reps];
	[exercise setExerciseGroup: exerciseGroup];
}

@end
