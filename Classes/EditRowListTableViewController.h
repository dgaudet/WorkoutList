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
	NSArray *tableData;
	Exercise *exercise;
	UITextField *textFieldBeingEdited;
}

@property(nonatomic, strong) id<EditRowListTableViewControllerDelegate> delegate;
@property(nonatomic, strong) Exercise *exercise;

@end

@protocol EditRowListTableViewControllerDelegate<NSObject>

@optional
- (void)editRowListTableViewController:(EditRowListTableViewController *)controller didChangeExercise:(Exercise *)changedExercise;

@end