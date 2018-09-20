//
//  WorkoutListAppDelegate.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedObjectContextService.h"
//#import <Google/SignIn.h>

@interface WorkoutListAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
    ManagedObjectContextService *_managedObjectContextService;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end

