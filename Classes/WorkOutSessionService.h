//
//  WorkOutSessionService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOutSession.h"
#import "FetchEntityService.h"
#import "ManagedObjectContextService.h"

@interface WorkOutSessionService : NSObject {
    FetchEntityService *_fetchedEntityService;
    ManagedObjectContextService *_managedObjectContextService;
}

+ (id)sharedInstance;
- (NSArray *)retreiveAllWorkOutSessions;
- (NSArray *)retrieveAllWorkOutSessionsWithNullForWeekGaps;
- (WorkOutSession *)retreiveStartedWorkOutSessionWithName:(NSString *)name;
- (WorkOutSession *)retreiveMostRecentlyEndedWorkOutSessionWithName:(NSString *)name;
- (BOOL)startWorkOutSessionForWorkOutWithName:(NSString *)name;
- (BOOL)endStartedWorkOutSessionForWorkOutWithName:(NSString *)name;
- (NSString *)generateCSVDataForAllWorkOutSessionsWithDateFormatter:(NSDateFormatter *)formatter;
- (NSString *)friendlyDurationForWorkOutSession:(WorkOutSession *)session;

@end
