//
//  ExerciseGroupService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseGroupService.h"
#import "ExerciseGroup.h"
#import "DatabasePopulator.h"

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

- (NSArray *)retreiveAllExerciseGroupsForWorkOutWithName:(NSString *) workOutName {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"workOut.name like %@", workOutName];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *data = [[[NSArray alloc] initWithArray:[[DatabasePopulator sharedInstance] fetchManagedObjectsForEntity:EG_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor]] autorelease];
	[sortDescriptor release];	
	
	return data;
}

@end
