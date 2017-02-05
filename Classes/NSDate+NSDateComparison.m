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
    //THis is a week minus 2 hours
    int weekInterval = 604800 - 7200;
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
