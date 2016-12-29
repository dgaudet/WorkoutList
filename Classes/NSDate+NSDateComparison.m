//
//  NSDate+NSDateComparison.m
//  WorkoutList
//
//  Created by Dean on 2016-12-29.
//
//

#import "NSDate+NSDateComparison.h"

@implementation NSDate (NSDateComparison)

- (bool)isTimeIntervalLargerThanWeekSinceDate:(NSDate *)date2 {
    if (self == nil || date2 == nil) {
        return false;
    }
    int weekInterval = 604800;
    NSTimeInterval differenceBetween = [self timeIntervalSinceDate:date2];
    if (differenceBetween < 0) {
        differenceBetween = -differenceBetween;
    }
    if (differenceBetween >= weekInterval) {
        return true;
    }
    return false;
}

@end
