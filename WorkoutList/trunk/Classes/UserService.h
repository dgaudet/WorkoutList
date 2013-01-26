//
//  UserService.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserService : NSObject {
	
}

+ (id)sharedInstance;
- (User *)retrieveUser;
- (void)updateUser:(User *)user;

@end
