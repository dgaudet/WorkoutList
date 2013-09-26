//
//  ExerciseService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exercise.h"

@interface ExerciseService : NSObject {

}

+ (id)sharedInstance;
- (BOOL)deleteExercise:(Exercise *)exercise;
- (BOOL)updateExercise:(Exercise *)exercise;
- (void)saveExerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps exerciseGroup:(ExerciseGroup *)exerciseGroup;

@end
