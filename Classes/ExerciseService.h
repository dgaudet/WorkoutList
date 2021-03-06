//
//  ExerciseService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Exercise;
@class ExerciseGroup;
@class ManagedObjectContextService;

@interface ExerciseService : NSObject {
    ManagedObjectContextService *_managedObjectContextService;
}

+ (id)sharedInstance;
- (BOOL)deleteExercise:(Exercise *)exercise;
- (BOOL)updateExercise:(Exercise *)exercise;
- (void)saveExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps ordinal:(NSNumber *)ordinal exerciseGroup:(ExerciseGroup *)exerciseGroup;

@end
