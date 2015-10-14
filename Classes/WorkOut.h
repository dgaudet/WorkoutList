//
//  WorkOut.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ExerciseGroup;
@class WorkOutSession;

extern NSString * const WO_ENTITY_NAME;

@interface WorkOut : NSManagedObject {
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSSet *exerciseGroup;
@property (nonatomic, strong) NSSet *workOutSession;

@end

@interface WorkOut (CoreDataGeneratedAccessors)
- (void)addExerciseGroupObject:(ExerciseGroup *)value;
- (void)removeExerciseGroupObject:(ExerciseGroup *)value;
- (void)addExerciseGroup:(NSSet *)value;
- (void)removeExerciseGroup:(NSSet *)value;

- (void)addWorkOutSessionObject:(WorkOutSession *)value;
- (void)removeWorkOutSessionObject:(WorkOutSession *)value;
- (void)addWorkOutSession:(NSSet *)value;
- (void)removeWorkOutSession:(NSSet *)value;

@end