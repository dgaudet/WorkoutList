//
//  ManagedObjectContextService.m
//  WorkoutList
//
//  Created by Dean on 2013-09-26.
//
//

#import "ManagedObjectContextService.h"

@implementation ManagedObjectContextService

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

@end
