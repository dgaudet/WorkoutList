//
//  ExerciseGroupService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseGroupService.h"
#import "ExerciseService.h"
#import "ExerciseGroup.h"
#import "Exercise.h"
#import "FetchEntityService.h"
#import "ManagedObjectContextService.h"

@implementation ExerciseGroupService

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
        _exerciseService = [ExerciseService sharedInstance];
        _fetchEntityService = [FetchEntityService sharedInstance];
        _managedObjectContextService = [ManagedObjectContextService sharedInstance];
    }
    return self;
}

- (NSArray *)retreiveAllExerciseGroupsForWorkOutWithName:(NSString *) workOutName {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workOut.name like %@", workOutName];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *data = [[[NSArray alloc] initWithArray:[_fetchEntityService fetchManagedObjectsForEntity:EG_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor]] autorelease];
	[sortDescriptor release];	
	
	return data;
}

- (void)moveExcercise:(Exercise *)exercise fromGroup:(ExerciseGroup *)fromGroup toGroup:(ExerciseGroup *)toGroup {
    [_exerciseService saveExerciseWithName:exercise.name weight:exercise.weight reps:exercise.reps exerciseGroup:toGroup];
    
    [_exerciseService deleteExercise:exercise];
}

- (BOOL)saveExerciseGroupWithName:(NSString *)groupName {
    ExerciseGroup *group = (ExerciseGroup *)[_managedObjectContextService createManagedObjectWithEntityName:EG_ENTITY_NAME];
    [group setName:groupName];
    
    return [_managedObjectContextService saveContextSuccessOrFail];
}

@end
