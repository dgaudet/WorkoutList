//
//  DatabasePopulator.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Exercise.h"
#import "ExerciseGroup.h"
@class ManagedObjectContextService;
@class ExerciseService;
@class ExerciseGroupService;
@class WorkOutService;

@interface DatabasePopulator : NSObject {
	NSManagedObjectContext *_managedObjectContext;
    ManagedObjectContextService *_managedObjectContextService;
    ExerciseService *_exerciseService;
    ExerciseGroupService *_exerciseGroupService;
    WorkOutService *_workOutService;
}

+ (id)sharedInstance;
- (void)populateDatabase;
- (void)addSessionForWorkOutWithName:(NSString *)name startDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

@end
