//
//  ManagedObjectContextService.h
//  WorkoutList
//
//  Created by Dean on 2013-09-26.
//
//

#import <Foundation/Foundation.h>

@interface ManagedObjectContextService : NSObject {
    NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (id)sharedInstance;

@end
