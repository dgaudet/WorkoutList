//
//  SessionListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SessionListTableViewController : UITableViewController {
	NSArray *tableData;
	NSDateFormatter *dateFormatter;
	NSString *lastExportedTitle;
	UIActivityIndicatorView *spinner;
}

@end
