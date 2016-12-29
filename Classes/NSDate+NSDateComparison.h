//
//  NSDate+NSDateComparison.h
//  WorkoutList
//
//  Created by Dean on 2016-12-29.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDateComparison)

- (bool)isTimeIntervalLargerThanWeekSinceDate:(NSDate *)date2;

@end
