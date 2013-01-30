//
//  WorkOutSessionService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkOutSessionService.h"
#import "DatabasePopulator.h"
#import "WorkOutSession.h"
#import "WorkOut.h"

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

- (NSArray *)retreiveAllWorkOutSessions {
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	NSArray *data = [[[NSArray alloc] initWithArray:[[DatabasePopulator sharedInstance] fetchManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:nil withSortDescriptor: sortDescriptor]] autorelease];
	[sortDescriptor release];
	return data;
}

- (WorkOutSession *)retreiveStartedWorkOutSessionWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(workOut.name like %@) AND (endDate == nil)", name];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
	return (WorkOutSession *)[[DatabasePopulator sharedInstance] fetchFirstManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor];
}

- (WorkOutSession *)retreiveMostRecentlyEndedWorkOutSessionWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(workOut.name like %@) AND (endDate != nil)", name];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:NO];
    return (WorkOutSession *)[[DatabasePopulator sharedInstance] fetchFirstManagedObjectsForEntity:WOS_ENTITY_NAME withPredicate:predicate withSortDescriptor:sortDescriptor];
}

- (BOOL)startWorkOutSessionForWorkOutWithName:(NSString *)name {
	WorkOutSession *session = (WorkOutSession *)[NSEntityDescription insertNewObjectForEntityForName:WOS_ENTITY_NAME inManagedObjectContext:[[DatabasePopulator sharedInstance] managedObjectContext]];
	[session setStartDate:[NSDate date]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", name];
	NSArray *workOuts = [[DatabasePopulator sharedInstance] fetchManagedObjectsForEntity:WO_ENTITY_NAME withPredicate:predicate];	
	[session setWorkOut:[workOuts objectAtIndex:0]];
	
	NSError *error;
	if (![[[DatabasePopulator sharedInstance] managedObjectContext] save:&error]) {
		// Handle the error.
		NSLog(@"Saving changes failed: %@", error);
		return FALSE;
	}	
	return TRUE;
}

- (BOOL)endStartedWorkOutSessionForWorkOutWithName:(NSString *)name {
	WorkOutSession *session = [self retreiveStartedWorkOutSessionWithName:name];
	if (session) {	
		[session setEndDate:[NSDate date]];
		
		NSError *error;
		if (![[[DatabasePopulator sharedInstance] managedObjectContext] save:&error]) {
			// Handle the error.
			NSLog(@"Saving changes failed: %@", error);			
		} else {
			return TRUE;
		}
	} 
	
	return FALSE;
}

- (NSString *)generateCSVDataForAllWorkOutSessionsWithDateFormatter:(NSDateFormatter *)formatter {
	NSString *colHeaders = @"Work Out Session,Date,Duration";
	NSString *rowData = [[[NSString alloc] init] autorelease];
		
	for (WorkOutSession *session in [self retreiveAllWorkOutSessions]) {
		NSString *formattedDateString = [formatter stringFromDate:[session startDate]];
        NSString *friendlyDuration = [self friendlyDurationForWorkOutSession:session];
		rowData = [rowData stringByAppendingFormat:@"\n%@, %@, %@", [[session workOut] name], formattedDateString, friendlyDuration];
	}
	
	return [NSString stringWithFormat:@"%@%@", colHeaders, rowData];
}

- (NSString *)friendlyDurationForWorkOutSession:(WorkOutSession *)session {
    NSTimeInterval interval = [session.endDate timeIntervalSinceDate:session.startDate];
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
