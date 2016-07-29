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
#import "ExerciseGroupService.h"
#import "WorkOutSessionService.h"

@interface ExerciseListTableViewController : UITableViewController <EditRowListTableViewControllerDelegate>{
	NSMutableArray *tableData;
	NSInteger lastRow;
	NSInteger lastSection;
	NSString *workOutName;
    NSIndexPath *_startButtonIndexPath;
    NSIndexPath *_endButtonIndexPath;
    NSTimer *_startEndButtonTimer;
    ExerciseGroupService *_exerciseGroupService;
    WorkOutSessionService *_workOutSessionService;
}

@property (nonatomic, strong) NSString *workOutName;

@end
