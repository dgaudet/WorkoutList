//
//  ExerciseGroup.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseGroup.h"
#import "Exercise.h"

NSString * const EG_ENTITY_NAME = @"ExerciseGroup";

@implementation ExerciseGroup

@dynamic name;
@dynamic exercise;
@dynamic workOut;

- (NSArray *)sortedExercies {
    NSMutableArray *sortedExercies = [[NSMutableArray alloc] initWithArray:[self.exercise allObjects]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordinal" ascending:YES];
    [sortedExercies sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    return [sortedExercies autorelease];
}

@end
