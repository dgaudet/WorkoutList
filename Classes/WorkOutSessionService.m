//
//  WorkOutSessionService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkOutSessionService.h"
#import "WorkOutSession.h"
#import "WorkOut.h"
#import "ManagedObjectContextService.h"
#import "NSDate+NSDateComparison.h"

@implementation WorkOutSessionService

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
        _fetchedEntityService = [FetchEntityService sharedInstance];
        _managedObjectContextService = [ManagedObjectContextService sharedInstance];
    }
    return self;
}

- (NSArray *)retrieveAllWorkOutSessionsWithNullForWeekGaps {
    //This adds a null record each time there is a week break in between sessions
    NSArray *sessions = self.retreiveAllWorkOutSessions;
    NSMutableArray *sessionsWithGaps = [NSMutableArray array];
    for (WorkOutSession *session in sessions) {
        if ((sessionsWithGaps.count > 1) && [session.endDate isTimeIntervalLargerThanWeekSinceDate:[[sessionsWithGaps objectAtIndex:sessionsWithGaps.count - 1] endDate]]) {
            [sessionsWithGaps addObject:[NSNull null]];
        }
        [sessionsWithGaps addObject:session];
    }
    return sessionsWithGaps;
}

- (NSArray *)retreiveAllWorkOutSessions {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	NSArray *data = [[NSArray alloc] initWithArray:[_fetchedEntityService fetchManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:nil withSortDescriptor: sortDescriptor]];
	return data;
}

- (WorkOutSession *)retreiveStartedWorkOutSessionWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(workOut.name like %@) AND (endDate == nil)", name];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	return (WorkOutSession *)[_fetchedEntityService fetchFirstManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor];
}

- (WorkOutSession *)retreiveMostRecentlyEndedWorkOutSessionWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(workOut.name like %@) AND (endDate != nil)", name];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:NO];
    return (WorkOutSession *)[_fetchedEntityService fetchFirstManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor];
}

- (BOOL)startWorkOutSessionForWorkOutWithName:(NSString *)name {
    NSManagedObjectContext *managedObjectContext = [_managedObjectContextService managedObjectContext];
	WorkOutSession *session = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:managedObjectContext];
	[session setStartDate:[NSDate date]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
	NSArray *workOuts = [_fetchedEntityService fetchManagedObjectsForEntity:WO_ENTITY_NAME withPredicate:predicate];	
	[session setWorkOut:[workOuts objectAtIndex:0]];
	
    return [_managedObjectContextService saveContextSuccessOrFail];
}

- (BOOL)endStartedWorkOutSessionForWorkOutWithName:(NSString *)name {
	WorkOutSession *session = [self retreiveStartedWorkOutSessionWithName:name];
	if (session) {	
		[session setEndDate:[NSDate date]];
		
		if ([_managedObjectContextService saveContextSuccessOrFail]) {
			return YES;
		} else {
			return NO;
		}
	}
	return NO;
}

- (NSString *)generateCSVDataForAllWorkOutSessionsWithDateFormatter:(NSDateFormatter *)formatter {
	NSString *colHeaders = @"Work Out Session,Start Date,End Date,Duration";
	NSString *rowData = [[NSString alloc] init];
		
	for (WorkOutSession *session in [self retreiveAllWorkOutSessions]) {
		NSString *formattedStartDateString = [formatter stringFromDate:[session startDate]];
        NSString *formattedEndDateString = [formatter stringFromDate:[session endDate]];
        NSString *friendlyDuration = [self friendlyDurationForWorkOutSession:session];
		rowData = [rowData stringByAppendingFormat:@"\n%@, %@, %@, %@", [[session workOut] name], formattedStartDateString, formattedEndDateString, friendlyDuration];
	}
	
	return [NSString stringWithFormat:@"%@%@", colHeaders, rowData];
}

- (NSString *)friendlyDurationForWorkOutSession:(WorkOutSession *)session {
    NSDate *endDate = [NSDate date];
    if (session.isSessionFinished) {
        endDate = session.endDate;
    }
    NSTimeInterval interval = [endDate timeIntervalSinceDate:session.startDate];
    NSString *friendlyDuration = @"";
    int duration = round(interval);

    int hours = duration / (60 * 60);
    if (hours > 0) {
        friendlyDuration = [friendlyDuration stringByAppendingFormat:@"%i h - ", hours];
    }
    
    int minutes = (duration / 60) % 60;
    if (minutes > 0) {
        friendlyDuration = [friendlyDuration stringByAppendingFormat:@"%i m - ", minutes];
    }
    
    int seconds = duration % 60;
    return [friendlyDuration stringByAppendingFormat:@"%i s", seconds];
}

@end
