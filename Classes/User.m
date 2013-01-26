//
//  User.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userName, password, googleFolder;

- (id)initWithName:(NSString *)name password:(NSString *)pass googleFolder:(NSString *)folderName {
	if(self = [super init]) {		
		userName = name;
		password = pass;
		googleFolder = folderName;
	}
	return self;
}

@end
