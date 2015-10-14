//
//  Excersise.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ExerciseGroup;

extern NSString * const E_ENTITY_NAME;

@interface Exercise : NSManagedObject {
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *reps;
@property (nonatomic, strong) NSNumber *ordinal;
@property (nonatomic, strong) ExerciseGroup *exerciseGroup;

@end
