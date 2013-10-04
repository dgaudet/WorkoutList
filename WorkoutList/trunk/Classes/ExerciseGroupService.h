//
//  ExerciseGroupService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExerciseGroup;
@class Exercise;
@class ExerciseService;
@class FetchEntityService;
@class ManagedObjectContextService;

@interface ExerciseGroupService : NSObject {
    ExerciseService *_exerciseService;
    FetchEntityService *_fetchEntityService;
    ManagedObjectContextService *_managedObjectContextService;
}

+ (id)sharedInstance;
- (NSArray *)retreiveAllExerciseGroupsForWorkOutWithName:(NSString *) workOutName;
- (void)moveExcercise:(Exercise *)exercise fromGroup:(ExerciseGroup *)fromGroup toGroup:(ExerciseGroup *)toGroup toOrdinal:(NSNumber *)ordinal;
- (void)moveExcercise:(Exercise *)exercise fromGroup:(ExerciseGroup *)fromGroup toGroup:(ExerciseGroup *)toGroup;
- (BOOL)saveExerciseGroupWithName:(NSString *)groupName;

@end
