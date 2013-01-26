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

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *weight;
@property (nonatomic, retain) NSString *reps;
@property (nonatomic, retain) ExerciseGroup *exerciseGroup;

@end
