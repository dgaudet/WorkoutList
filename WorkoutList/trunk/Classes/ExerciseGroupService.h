//
//  ExerciseGroupService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExerciseGroupService : NSObject {

}

+ (id)sharedInstance;
- (NSArray *)retreiveAllExerciseGroupsForWorkOutWithName:(NSString *) workOutName;

@end
