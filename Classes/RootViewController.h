//
//  RootViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "EditUserListTableViewController.h"

@interface RootViewController : UITableViewController <EditUserListTableViewControllerDelegate, MFMailComposeViewControllerDelegate> {
	NSArray *tableData;
	UIActivityIndicatorView *spinner;
    NSURL *tempFileUrl;
}

@end
