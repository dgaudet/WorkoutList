//
//  UserService.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"

static NSString *USER_NAME_KEY = @"UserName";
static NSString *PASSWORD_KEY = @"Password";
static NSString *GOOGLE_FOLDER_KEY = @"GoogleDocsFolder";
static NSUserDefaults *userDefaults;

@implementation UserService

+ (id)sharedInstance
{
	static id master = nil;
	@synchronized(self)
	{
		if (master == nil) {
			master = [self new];
		}
	}
    return master;
}

- (id)init {
	if (userDefaults == nil) {
		userDefaults = [NSUserDefaults standardUserDefaults];
	}	
	return self;
}

-(User *)retrieveUser {
	if ([userDefaults stringForKey:USER_NAME_KEY] != nil) {
		return [[User alloc] initWithName:[userDefaults objectForKey:USER_NAME_KEY]
								 password:[userDefaults objectForKey:PASSWORD_KEY]
							  googleFolder:[userDefaults objectForKey:GOOGLE_FOLDER_KEY]];
	}
	return [[User alloc] initWithName:@""
							  password:@""
						  googleFolder:@"WorkOutList Test Collection"];
}

- (void)updateUser:(User *)user {
	[userDefaults setObject:user.userName forKey:USER_NAME_KEY];
	[userDefaults setObject:user.password forKey:PASSWORD_KEY];
	[userDefaults setObject:user.googleFolder forKey:GOOGLE_FOLDER_KEY];
	[userDefaults synchronize];
}

@end
