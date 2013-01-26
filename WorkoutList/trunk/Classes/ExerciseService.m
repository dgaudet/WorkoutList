//
//  ExerciseService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseService.h"
#import "DatabasePopulator.h"

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

@end
