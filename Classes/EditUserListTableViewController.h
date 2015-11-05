//
//  EditUserListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Google/SignIn.h>

@protocol EditUserListTableViewControllerDelegate;

@interface EditUserListTableViewController : UITableViewController <UITextFieldDelegate, GIDSignInUIDelegate> {
	NSArray *tableData;
	User *user;
	UITextField *textFieldBeingEdited;
}

@property(nonatomic, strong) id<EditUserListTableViewControllerDelegate> delegate;
@property(nonatomic, strong) User *user;

@end

@protocol EditUserListTableViewControllerDelegate<NSObject>

@optional
- (void)editUserListTableViewController:(EditUserListTableViewController *)controller didChangeUser:(User *)changedUser;
- (void)editUserListTableViewControllerDidCancel:(EditUserListTableViewController *)controller;

@end