//
//  WorkOutSession.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorkOut;

extern NSString * const WOS_ENTITY_NAME;

@interface WorkOutSession : NSObject {

}

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) WorkOut *workOut;

@end