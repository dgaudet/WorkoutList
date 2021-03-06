//
//  ManagedObjectContextService.h
//  WorkoutList
//
//  Created by Dean on 2013-09-26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectContextService : NSObject {
    NSManagedObjectContext *_managedObjectContext;
	NSManagedObjectModel *_managedObjectModel;
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

+ (id)sharedInstance;
- (void)saveContext;
- (BOOL)saveContextSuccessOrFail;
- (BOOL)databaseExists;
- (NSManagedObjectContext *)managedObjectContext;
- (void)deleteManagedObject:(NSManagedObject *)entity;
- (NSManagedObject *)createManagedObjectWithEntityName:(NSString *)entityName;

@end
