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

- (void)moveExcercise:(Exercise *)exercise fromGroup:(ExerciseGroup *)fromGroup toGroup:(ExerciseGroup *)toGroup toOrdinal:(NSNumber *)ordinal {
    //if it's the same group reorder them all based on the change
    //if it's a new group reorder any items in the row after the row it was added to
    NSLog(@"Moving exercise: %@ from: %@ to: %@", exercise.name, exercise.ordinal, ordinal);
    if ([fromGroup.name isEqualToString:toGroup.name]) {
        NSLog(@"same group");
        NSMutableArray *sortedExercies = [NSMutableArray arrayWithArray:[fromGroup sortedExercies]];
        NSLog(@"Before Sorted execies: %@", sortedExercies);
        
        NSUInteger originalOrdinal = [exercise.ordinal integerValue];
        NSUInteger toOrdinal = [ordinal integerValue];
        [sortedExercies removeObjectAtIndex:originalOrdinal];
        [sortedExercies insertObject:exercise atIndex:toOrdinal];
        NSLog(@"after move Sorted execies: %@", sortedExercies);
        
        NSInteger start = originalOrdinal;
        if (toOrdinal < start) {
            start = toOrdinal;
        }
        NSInteger end = toOrdinal;
        if (originalOrdinal > end) {
            end = originalOrdinal;
        }
        
        for (NSInteger i = start; i <= end; i++) {
            exercise = [sortedExercies objectAtIndex:i];
            exercise.ordinal = [NSNumber numberWithInteger:i];
        }
        NSLog(@"After sort Sorted execies: %@", sortedExercies);
    } else {
        [_exerciseService saveExerciseWithName:exercise.name weight:exercise.weight reps:exercise.reps ordinal:ordinal exerciseGroup:toGroup];
        
        [_exerciseService deleteExercise:exercise];
    }
}

- (void)moveExcercise:(Exercise *)exercise fromGroup:(ExerciseGroup *)fromGroup toGroup:(ExerciseGroup *)toGroup {
    [_exerciseService saveExerciseWithName:exercise.name weight:exercise.weight reps:exercise.reps ordinal:[NSNumber numberWithInt:0] exerciseGroup:toGroup];
    
    [_exerciseService deleteExercise:exercise];
}

- (BOOL)saveExerciseGroupWithName:(NSString *)groupName {
    ExerciseGroup *group = (ExerciseGroup *)[_managedObjectContextService createManagedObjectWithEntityName:EG_ENTITY_NAME];
    [group setName:groupName];
    
    return [_managedObjectContextService saveContextSuccessOrFail];
}

@end
