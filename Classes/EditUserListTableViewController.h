//
//  EditUserListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol EditUserListTableViewControllerDelegate;

@interface EditUserListTableViewController : UITableViewController <UITextFieldDelegate> {
	id<EditUserListTableViewControllerDelegate> __unsafe_unretained delegate;
	NSArray *tableData;
	User *user;
	UITextField *textFieldBeingEdited;
}

@property(unsafe_unretained)id<EditUserListTableViewControllerDelegate> delegate;
@property(nonatomic, strong) User *user;

@end

@protocol EditUserListTableViewControllerDelegate<NSObject>

@optional
- (void)editUserListTableViewController:(EditUserListTableViewController *)controller didChangeUser:(User *)changedUser;
- (void)editUserListTableViewControllerDidCancel:(EditUserListTableViewController *)controller;

@end