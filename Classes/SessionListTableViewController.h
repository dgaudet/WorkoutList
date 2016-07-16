//
//  SessionListTableViewController.h
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CSVFileGenerationService.h"
#import "WorkOutSessionService.h"

@interface SessionListTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
	NSArray *_tableData;
    NSArray *_unfinishedSessionIndexPaths;
	NSDateFormatter *dateFormatter;
	NSString *lastExportedTitle;
	UIActivityIndicatorView *spinner;
    CSVFileGenerationService *csvFileGenerationService;
    WorkOutSessionService *_workOutSessionService;
}

@end
