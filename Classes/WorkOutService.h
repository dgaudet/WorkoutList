//
//  WorkOutService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WorkOutService : NSObject {

}

+ (id)sharedInstance;
- (NSArray *)retreiveAllWorkOuts;
-(NSString *)generateCSVForAllWorkOuts;

@end
