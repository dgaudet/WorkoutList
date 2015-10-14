//
//  WorkOutSession.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class WorkOut;

extern NSString * const WOS_ENTITY_NAME;

@interface WorkOutSession : NSManagedObject

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) WorkOut *workOut;

@end