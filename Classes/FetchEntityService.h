//
//  FetchEntityService.h
//  WorkoutList
//
//  Created by Dean on 2013-09-26.
//
//

#import <Foundation/Foundation.h>
@class ManagedObjectContextService;

@interface FetchEntityService : NSObject {
    ManagedObjectContextService *_managedObjectContextService;
}

+ (id)sharedInstance;
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate;
- (id)fetchFirstManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate withSortDescriptor:(NSSortDescriptor *)sortDescriptor;

@end
