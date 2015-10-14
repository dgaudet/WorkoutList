//
//  WorkOutService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkOutService.h"
#import "WorkOut.h"
#import "ExerciseGroupService.h"
#import "ExerciseGroup.h"
#import "Exercise.h"
#import "FetchEntityService.h"

//ToDo:Sort the WorkOut Groups by number

@implementation WorkOutService

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
        _fetchEntityService = [FetchEntityService sharedInstance];
    }
    return self;
}

- (WorkOut *)retreiveWorkOutWithName:(NSString *)workOutName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", workOutName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *data = [[NSArray alloc] initWithArray:[_fetchEntityService fetchManagedObjectsForEntity:WO_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor]];
    
    WorkOut *workOut = nil;
    if (data) {
        if ([data count] > 0) {
            workOut = [data objectAtIndex:0];
        }
    }
    
	return workOut;

}

- (NSArray *)retreiveAllWorkOuts {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *data = [[NSArray alloc] initWithArray:[_fetchEntityService fetchManagedObjectsForEntity:WO_ENTITY_NAME withPredicate:nil withSortDescriptor:sortDescriptor]];
		
	return data;
}

-(NSString *)generateCSVForAllWorkOuts {
	NSString *colHeaders = @"Work Out,Exercise Group, Exercise Name, Weight, Sets";
	NSString *rowData = [[NSString alloc] init];	
	NSString *workOutName;
	NSString *groupName;	
	
	for (WorkOut *workOut in [self retreiveAllWorkOuts]) {
		NSArray *exerciseGroups = [[ExerciseGroupService sharedInstance] retreiveAllExerciseGroupsForWorkOutWithName:workOut.name];
		BOOL workOutDisplay = NO;
		for (ExerciseGroup *group in exerciseGroups) {            
			NSArray *exercises = [[NSArray alloc] initWithArray:[group sortedExercies]];
			BOOL groupDisplay = NO;
			for (Exercise *exercise in exercises) {
				if (!workOutDisplay) {
					workOutDisplay = YES;
					workOutName = workOut.name;
				} else {
					workOutName = @"";
				}
				
				if (!groupDisplay) {
					groupDisplay = YES;
					groupName = group.name;
				} else {
					groupName = @"";
				}
				rowData = [rowData stringByAppendingFormat:@"\n%@,%@,%@,%@,%@", 
						   workOutName, groupName, exercise.name, exercise.weight, exercise.reps]; 
			}
		}
	}
	
	return [NSString stringWithFormat:@"%@%@", colHeaders, rowData];
}

@end
