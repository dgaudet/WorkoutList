//
//  EditRowListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@protocol EditRowListTableViewControllerDelegate;

@interface EditRowListTableViewController : UITableViewController <UITextFieldDelegate>{
	id<EditRowListTableViewControllerDelegate> delegate;
	NSArray *tableData;
	Exercise *exercise;
	UITextField *textFieldBeingEdited;
}

@property (assign)id<EditRowListTableViewControllerDelegate> delegate;
@property(nonatomic, retain) Exercise *exercise;

@end

@protocol EditRowListTableViewControllerDelegate<NSObject>

@optional
- (void)editRowListTableViewController:(EditRowListTableViewController *)controller didChangeExercise:(Exercise *)changedExercise;

@end