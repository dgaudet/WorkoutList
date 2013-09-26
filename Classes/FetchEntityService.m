//
//  FetchEntityService.m
//  WorkoutList
//
//  Created by Dean on 2013-09-26.
//
//

#import "FetchEntityService.h"
#import "ManagedObjectContextService.h"

@implementation FetchEntityService

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
    }
    return self;
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate {
	return [self fetchManagedObjectsForEntity:entityName withPredicate:predicate withSortDescriptor:nil];
}

- (id)fetchFirstManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSArray *data = [[NSArray alloc] initWithArray:[self fetchManagedObjectsForEntity:entityName withPredicate:predicate withSortDescriptor:sortDescriptor]];
	[sortDescriptor release];
	if (data.count > 0) {
		return [data objectAtIndex:0];
	} else {
		return nil;
	}
}

- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor {
	NSManagedObjectContext *context = [_managedObjectContextService managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	if (sortDescriptor) {
		NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[request setSortDescriptors:sortDescriptors];
	}
	if (predicate) {
		[request setPredicate:predicate];
	}
	
	NSError *error;
	NSArray *fetchResults = [[[context executeFetchRequest:request error:&error] copy] autorelease];
	
	if (!fetchResults) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	[request release];
	return fetchResults;
}

@end
