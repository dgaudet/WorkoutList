//
//  ExerciseGroup.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-02-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Exercise;
@class WorkOut;

extern NSString * const EG_ENTITY_NAME;

@interface ExerciseGroup : NSManagedObject {
}

//http://mobile.tutsplus.com/tutorials/iphone/iphone-core-data/

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet *exercise;
@property (nonatomic, strong) WorkOut *workOut;

@end

@interface ExerciseGroup (CoreDataGeneratedAccessors)
- (void)addExerciseObject:(Exercise *)value;
- (void)removeExerciseObject:(Exercise *)value;
- (void)addExercise:(NSSet *)value;
- (void)removeExercise:(NSSet *)value;

- (NSArray *)sortedExercies;

@end