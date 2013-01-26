//
//  RootViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditUserListTableViewController.h"

@interface RootViewController : UITableViewController <EditUserListTableViewControllerDelegate> {
	NSArray *tableData;
	UIActivityIndicatorView *spinner;
}

@end
