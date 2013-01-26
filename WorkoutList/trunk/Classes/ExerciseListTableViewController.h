//
//  ExcerciseListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EditRowListTableViewController.h"

@interface ExerciseListTableViewController : UITableViewController <EditRowListTableViewControllerDelegate>{
	NSMutableArray *tableData;
	NSInteger lastRow;
	NSInteger lastSection;
	NSString *workOutName;
}

@property (nonatomic, retain) NSString *workOutName;

@end
