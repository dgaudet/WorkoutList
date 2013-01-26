//
//  User.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString *userName;
	NSString *password;
	NSString *googleFolder;
}

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *googleFolder;

- (id)initWithName:(NSString *)name password:(NSString *)pass googleFolder:(NSString *)folderName;

@end
