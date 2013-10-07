//
//  DatabasePopulator.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatabasePopulator.h"
#import "ExerciseService.h"
#import "Exercise.h"
#import "ExerciseGroupService.h"
#import "ExerciseGroup.h"
#import "WorkOutSession.h"
#import "WorkOut.h"
#import "ManagedObjectContextService.h"

@interface DatabasePopulator (PrivateMethods)

- (void)exerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps ordinal:(NSNumber *)ordinal exerciseGroup:(ExerciseGroup *)exerciseGroup;
- (NSURL *)applicationDocumentsDirectory;
- (void)generateAndSaveWorkOut1;
- (void)generateAndSaveWorkOut2;
- (void)generateAndSaveWorkOut3;

@end

@implementation DatabasePopulator

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    return master;
}

- (id)init {
    self = [super init];
    if (self) {
        _managedObjectContextService = [ManagedObjectContextService sharedInstance];
        _managedObjectContext = [_managedObjectContextService managedObjectContext];
        _exerciseService = [ExerciseService sharedInstance];
        _exerciseGroupService = [ExerciseGroupService sharedInstance];
    }
    return self;
}

- (void)populateDatabase {
	[self generateAndSaveWorkOut1];
	[self generateAndSaveWorkOut2];
	[self generateAndSaveWorkOut3];
}

-(void)generateAndSaveWorkOut1 {
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
	[self exerciseWithName:@"Bench Press" weight:@"130" reps:@"10" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Incline Bench Shoulder Raise" weight:@"90" reps:@"10" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Incline Bench Press" weight:@"90" reps:@"10" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup1];
	
	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Reverse Ab Crunch(On Ball)" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Half Leg Hip Raise on Tricep" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Dumbell Fly" weight:@"50" reps:@"8" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup2];
    [self exerciseWithName:@"Straight Leg Raise on Tricep" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup2];
    [self exerciseWithName:@"Incline Dumbell Press" weight:@"55" reps:@"8" ordinal:[NSNumber numberWithInt:4] exerciseGroup:exerciseGroup2];
	
	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Plank" weight:@"" reps:@"105s" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Bicycles" weight:@"" reps:@"50" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Dumbell Bench Press" weight:@"65" reps:@"9" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup3];
    [self exerciseWithName:@"Incline Dumbell Shoulder Raise" weight:@"55" reps:@"12" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup3];
	
	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Sit up on top pin(With Wieght)" weight:@"35" reps:@"3" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Pullover" weight:@"80" reps:@"10" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Rope Weight Raise" weight:@"2.5" reps:@"8" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Hammer Curl" weight:@"45" reps:@"4" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup4];
	
	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Kickbacks" weight:@"35" reps:@"7" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Dumbell Wrist Curl" weight:@"50" reps:@"11" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup5];
    [self exerciseWithName:@"Tricep Heavy Pull down" weight:@"70" reps:@"5" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup5];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
    [self exerciseWithName:@"Torso Machine" weight:@"65" reps:@"8" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Close Grip Bench Press" weight:@"110" reps:@"6" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Barbell Wrist Curl" weight:@"80" reps:@"7" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup6];
	
	ExerciseGroup *exerciseGroup7 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup7 setName: @"Workout Group 7"];
	[self exerciseWithName:@"Ab Roller" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup7];
	[self exerciseWithName:@"Tricepts Extension(French Press)" weight:@"60" reps:@"3" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup7];
    [self exerciseWithName:@"Side Bend" weight:@"80" reps:@"11" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup7];
    [self exerciseWithName:@"Dip on Tricep" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup7];
    [self exerciseWithName:@"Chinup" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:4] exerciseGroup:exerciseGroup7];
		
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[workOut setName:@"Abs/Chest/Forearm/Tricep"];
	[exerciseGroup1 setWorkOut:workOut];
	[exerciseGroup2 setWorkOut:workOut];
	[exerciseGroup3 setWorkOut:workOut];
	[exerciseGroup4 setWorkOut:workOut];
	[exerciseGroup5 setWorkOut:workOut];
	[exerciseGroup6 setWorkOut:workOut];
	[exerciseGroup7 setWorkOut:workOut];
	
	if (![_managedObjectContextService saveContextSuccessOrFail]) {
		exit(-1);  // Fail
	}
}

-(void)generateAndSaveWorkOut2 {
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
	[self exerciseWithName:@"Barbell Bent Over Row" weight:@"90" reps:@"7" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Lying External Rotation" weight:@"30" reps:@"8" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup1];
    [self exerciseWithName:@"Upright External Rotation" weight:@"45" reps:@"6" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Back Extention" weight:@"25" reps:@"8" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup1];

	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Dumbell Bent Over Row" weight:@"85" reps:@"10" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Barbell Rear Delt Row" weight:@"80" reps:@"4" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup2];	
	[self exerciseWithName:@"Lateral Neck Flexon" weight:@"--40" reps:@"12" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup2];
	
	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Chinup" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Barbell Shrug" weight:@"180" reps:@"6" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Neck Flexon 45+25" weight:@"--70" reps:@"6" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup3];
	
	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Dumbell Internal Rotation" weight:@"55" reps:@"7" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Shrug" weight:@"85" reps:@"7" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Underhand Chinup" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell Preacher Curl(Single)" weight:@"50" reps:@"-6" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup4];
	
	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Dumbell Concentration Curl" weight:@"40" reps:@"10" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Incline Curl" weight:@"35" reps:@"10" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Neck Extension 2x50-10" weight:@"60" reps:@"4" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup5];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
	[self exerciseWithName:@"Barbell Curl" weight:@"60" reps:@"8" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Seated Dumbell Curl" weight:@"40" reps:@"-4" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"21's" weight:@"30" reps:@"7" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup6];
	
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[workOut setName:@"Back/Bicep/Neck"];
	[exerciseGroup1 setWorkOut:workOut];
	[exerciseGroup2 setWorkOut:workOut];
	[exerciseGroup3 setWorkOut:workOut];
	[exerciseGroup4 setWorkOut:workOut];
	[exerciseGroup5 setWorkOut:workOut];
	[exerciseGroup6 setWorkOut:workOut];

	WorkOutSession *workOutSession = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	NSDate *currentDate = [NSDate date];
	[workOutSession setStartDate:[currentDate dateByAddingTimeInterval:-200]];
	[workOutSession setEndDate:[currentDate dateByAddingTimeInterval:-100]];
	[workOutSession setWorkOut:workOut];
	
	if (![_managedObjectContextService saveContextSuccessOrFail]) {
		exit(-1);  // Fail
	}
}	

-(void)generateAndSaveWorkOut3 {		
	WorkOut *workOut = (WorkOut *)[NSEntityDescription insertNewObjectForEntityForName:WO_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[workOut setName:@"Shoulder/Leg"];
	
	ExerciseGroup *exerciseGroup1 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup1 setName: @"Workout Group 1"];
    [self exerciseWithName:@"Front Lateral Raise" weight:@"45" reps:@"9" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Barbell Lunge" weight:@"130" reps:@"11" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup1];
	[self exerciseWithName:@"Barbell Upright Row" weight:@"80" reps:@"6" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup1];
    [self exerciseWithName:@"Rear Lateral Raise(Both Arms)" weight:@"30" reps:@"9" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup1];
	[exerciseGroup1 setWorkOut:workOut];
	
	ExerciseGroup *exerciseGroup2 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup2 setName: @"Workout Group 2"];
	[self exerciseWithName:@"Rear Lunge" weight:@"130" reps:@"11" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup2];
	[self exerciseWithName:@"Side Lunge" weight:@"110" reps:@"11" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup2];
    [self exerciseWithName:@"Lateral Raise(Both Arms)" weight:@"30" reps:@"9" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup2];
	[exerciseGroup2 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup3 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup3 setName: @"Workout Group 3"];
	[self exerciseWithName:@"Sidekick" weight:@"90" reps:@"7" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Leg Push Out" weight:@"50" reps:@"7" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup3];
	[self exerciseWithName:@"Rear Leg Curl" weight:@"90" reps:@"10" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup3];
    [self exerciseWithName:@"Pull Down" weight:@"120" reps:@"5" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup3];
	[exerciseGroup3 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup4 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup4 setName: @"Workout Group 4"];
	[self exerciseWithName:@"Seated Leg Press" weight:@"280" reps:@"9" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup4];
	[self exerciseWithName:@"Dumbell One arm Upright Row" weight:@"70" reps:@"8" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup4];
    [self exerciseWithName:@"Lying Lateral Raise" weight:@"35" reps:@"3" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup4];
    [self exerciseWithName:@"Dumbell Rear Delt Row" weight:@"80" reps:@"11" ordinal:[NSNumber numberWithInt:3] exerciseGroup:exerciseGroup4];
	[exerciseGroup4 setWorkOut:workOut];

	ExerciseGroup *exerciseGroup5 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup5 setName: @"Workout Group 5"];
	[self exerciseWithName:@"Dumbell Seated Shoulder Press" weight:@"45" reps:@"8" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup5];
	[self exerciseWithName:@"Dumbell Front Raise" weight:@"50" reps:@"4" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup5];
    [self exerciseWithName:@"One Arm Lateral Raise" weight:@"30" reps:@"8" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup5];
	[exerciseGroup5 setWorkOut:workOut];
	
	ExerciseGroup *exerciseGroup6 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 6"];
	[self exerciseWithName:@"Dumbell Single Leg Calf Raise" weight:@"100" reps:@"5" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Arnold Press" weight:@"40" reps:@"9" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup6];
	[self exerciseWithName:@"Behind Neck Press" weight:@"70" reps:@"9" ordinal:[NSNumber numberWithInt:2] exerciseGroup:exerciseGroup6];
	[exerciseGroup6 setWorkOut:workOut];
    
    ExerciseGroup *exerciseGroup7 = (ExerciseGroup *)[NSEntityDescription insertNewObjectForEntityForName:EG_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	[exerciseGroup6 setName: @"Workout Group 7"];
    [self exerciseWithName:@"Barbell Standing Leg Calf Raise" weight:@"180" reps:@"3" ordinal:[NSNumber numberWithInt:0] exerciseGroup:exerciseGroup7];
    [self exerciseWithName:@"Chinup" weight:@"" reps:@"12" ordinal:[NSNumber numberWithInt:1] exerciseGroup:exerciseGroup7];
    [exerciseGroup7 setWorkOut:workOut];
	
	WorkOutSession *workOutSession = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:_managedObjectContext];
	NSDate *currentDate = [NSDate date];
	[workOutSession setStartDate:[currentDate dateByAddingTimeInterval:-10200]];
	[workOutSession setEndDate:[currentDate dateByAddingTimeInterval:-1000]];
	[workOutSession setWorkOut:workOut];
	
	if (![_managedObjectContextService saveContextSuccessOrFail]) {
		exit(-1);  // Fail
	}
}	

- (void)exerciseWithName:(NSString *)name weight:(NSString *)weight reps:(NSString *)reps ordinal:(NSNumber *)ordinal exerciseGroup:(ExerciseGroup *)exerciseGroup {
	[_exerciseService saveExerciseWithName:name weight:weight reps:reps ordinal:ordinal exerciseGroup:exerciseGroup];
}

@end
