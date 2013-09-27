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

@interface DatabasePopulator : NSObject {
	NSManagedObjectContext *managedObjectContext;
    ManagedObjectContextService *_managedObjectContextService;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

+ (id)sharedInstance;
- (void)populateDatabase;

@end
