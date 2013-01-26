//
//  WorkOutSessionService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOutSession.h"

@interface WorkOutSessionService : NSObject {

}

+ (id)sharedInstance;
- (NSArray *)retreiveAllWorkOutSessions;
- (WorkOutSession *)retreiveStartedWorkOutSessionWithName:(NSString *)name;
- (BOOL)startWorkOutSessionForWorkOutWithName:(NSString *)name;
- (BOOL)endStartedWorkOutSessionForWorkOutWithName:(NSString *)name;
- (NSString *)generateCSVDataForAllWorkOutSessionsWithDateFormatter:(NSDateFormatter *)formatter;

@end
