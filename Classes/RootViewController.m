//
//  RootViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "WorkOutService.h"
#import "ExerciseListTableViewController.h"
#import "DatabasePopulator.h"
#import "GoogleDataService.h"
#import "SessionListTableViewController.h"
#import "UserService.h"
#import "EditUserListTableViewController.h"

//ToDo: add code to ensure no problems occur if a user backgrounds the app while uploading to google docs
//test

@interface RootViewController (PrivateMethods)

- (NSArray *)loadTableData;
- (UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCell:(NSString *)name cellValue:(NSString *)value;
- (UITableViewCell *)tableView:(UITableView *)tableView centeredTextStyleCell:(NSString *)text;

- (void)exportButtonPressed:(id)sender;
- (void)docListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedDocList *)feed error:(NSError *)error;
- (void)createAndSaveSpreadsheetWithFeed:(GDataFeedDocList *)feed inFolderWithName:(GDataEntryFolderDoc *)folderEntry;
- (NSString *)generateSessionSpreadSheetTitle;
- (NSString*)generateSessionSpreadSheetData;
- (void)uploadDocTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryDocBase *)entry error:(NSError *)error;
- (void)settingsButtonPressed:(id)sender;
- (void)settingsControllerDidFinish;

- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (void)showErrorAlert;

@end

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Time to Work Out";
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];	
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportButtonPressed:)];
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton release];
	
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(settingsButtonPressed:)];
	self.navigationItem.leftBarButtonItem = settingsButton;
	[settingsButton release];
	
	tableData = [[NSArray alloc] initWithArray:[self loadTableData]];
}

- (NSArray *)loadTableData {
	NSArray *allWorkOuts = [NSArray arrayWithArray:[[WorkOutService sharedInstance] retreiveAllWorkOuts]];
	NSDictionary *workOutSection = [[NSDictionary alloc] initWithObjectsAndKeys:allWorkOuts, @"items", @"Work Outs", @"name", nil];
	NSArray *allSessions = [[NSArray alloc] initWithObjects:@"View Completed Sessions", nil];
	NSDictionary *sessionSection = [[NSDictionary alloc] initWithObjectsAndKeys:allSessions, @"items", @"Sessions", @"name", nil];
	[allSessions release];
	
	NSArray *data = [[[NSArray alloc] initWithObjects:workOutSection, sessionSection, nil] autorelease];
	[workOutSection release];	
	[sessionSection release];	
	
	return data;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:[tableData objectAtIndex:section]];
	return [dictionary objectForKey:@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:[tableData objectAtIndex:section]];
	NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
	return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:[tableData objectAtIndex:indexPath.section]];
	NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
	
	if (indexPath.section == 0) {			
		return [self tableView:tableView defaultStyleCell:[[array objectAtIndex:indexPath.row] name] cellValue:@""];
	} else {
		return [self tableView:tableView centeredTextStyleCell:[array objectAtIndex:indexPath.row]];
	}
}

-(UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCell:(NSString *)name cellValue:(NSString *)value {
	static NSString *CellIdentifier = @"DefaultCellStyle";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...	
	cell.textLabel.text = name;
	cell.detailTextLabel.text = value;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
    return cell;	
}

-(UITableViewCell *)tableView:(UITableView *)tableView centeredTextStyleCell:(NSString *)text {
	static NSString *CellIdentifier = @"CenteredTextCellStyle";
    
	NSInteger mainLabelTag = 1;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 2.0, 285.0, 40.0)];		
        mainLabel.textAlignment = UITextAlignmentCenter;
		mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        mainLabel.tag = mainLabelTag;		
		[cell.contentView addSubview:mainLabel];
		[mainLabel release];
    }
    
    // Set up the cell...
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
	mainLabel.text = text;	
	
    return cell;	
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		ExerciseListTableViewController *exerciseListTableViewController = [[ExerciseListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:[tableData objectAtIndex:indexPath.section]];
		NSArray *array = [NSArray arrayWithArray:[dictionary objectForKey:@"items"]];
		exerciseListTableViewController.workOutName = [[array objectAtIndex:indexPath.row] name];
		exerciseListTableViewController.title = [[array objectAtIndex:indexPath.row] name];
		
		[self.navigationController pushViewController:exerciseListTableViewController animated:YES];
		[exerciseListTableViewController release];
	} else {
		SessionListTableViewController *sessionListTable = [[SessionListTableViewController alloc] initWithStyle:UITableViewStylePlain];
		[self.navigationController pushViewController:sessionListTable animated:YES];
		[sessionListTable release];
	}
}

#pragma mark -
#pragma mark Loading Progress UI

- (void)showLoadingIndicators
{
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
		
		spinner.frame = CGRectMake(145, 160, 25, 25);
		
        [self.view addSubview:spinner];
    }
}

- (void)hideLoadingIndicators
{
    if (spinner) {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [spinner release];
        spinner = nil;
    }
}

#pragma mark -
#pragma mark UI Type stuff
- (void)showErrorAlert {
	NSString *message = @"We are sorry there was a problem processing Your Request Please Try Again later. Press Ok to continue";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self hideLoadingIndicators];
}

#pragma mark -
#pragma mark Export work

- (void)exportButtonPressed:(id)sender {
	[[GoogleDataService sharedInstance] fetchDocListWithdidFinishSelector:@selector(docListFetchTicket:finishedWithFeed:error:) forDelegate:self];
	[self showLoadingIndicators];
}

- (void)docListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedDocList *)feed error:(NSError *)error {
	if (error) {
		NSLog(@"Got Feed with error: %@", [error description]);
		[self showErrorAlert];
	} else {
		NSArray *folderEntries = [feed entriesWithCategoryKind:kGDataCategoryFolderDoc];
		GDataEntryFolderDoc *workoutFolder;
		
		for(GDataEntryFolderDoc *folderEntry in folderEntries){
			NSString *title = [[folderEntry title] stringValue];
			if ([title isEqualToString:[[UserService sharedInstance] retrieveUser].googleFolder]) {
				workoutFolder = folderEntry; 
			}	
		}
		[self createAndSaveSpreadsheetWithFeed:feed inFolderWithName:workoutFolder];
	}
}

- (void)createAndSaveSpreadsheetWithFeed:(GDataFeedDocList *)feed inFolderWithName:(GDataEntryFolderDoc *)folderEntry {
	//http://groups.google.com/group/gdata-objectivec-client/browse_thread/thread/4569ad053eb88090
	// Insert a new document with the client's data.
	GDataEntrySpreadsheetDoc *entryNew = [GDataEntrySpreadsheetDoc documentEntry];
	NSString *documentName = [self generateSessionSpreadSheetTitle];
	NSData *data = [[self generateSessionSpreadSheetData] dataUsingEncoding:NSUTF8StringEncoding]; 
	
	[entryNew setTitleWithString:documentName];
	[entryNew setUploadData:data];
	[entryNew setUploadMIMEType:@"text/csv"];
	[entryNew setUploadSlug:[NSString stringWithFormat:@"%@.csv", documentName]];
	
	GDataCategory *category = [GDataCategory categoryWithScheme:kGDataCategoryScheme term:kGDataCategorySpreadsheetDoc];	 
	[entryNew setCategories:[NSArray arrayWithObject:category]];
	[category setLabel:@"spreadsheet"];
	
	NSURL *urlPost = [GDataServiceGoogleDocs folderContentsFeedURLForFolderID:[folderEntry resourceID]];
	GDataServiceGoogleDocs *service = [[GoogleDataService sharedInstance] docsService];
	[service setServiceUploadChunkSize:0];
	[service fetchEntryByInsertingEntry:entryNew forFeedURL:urlPost delegate:self
					  didFinishSelector:@selector(uploadDocTicket:finishedWithEntry:error:)];
}

-(NSString *)generateSessionSpreadSheetTitle {
	NSDate *currentDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *formattedDateString = [formatter stringFromDate:currentDate];
	NSString *title = [NSString stringWithFormat:@"Exercises %@", formattedDateString];
	[formatter release];
	return title;
}

-(NSString *)generateSessionSpreadSheetData {
	return [NSString stringWithString:[[WorkOutService sharedInstance] generateCSVForAllWorkOuts]];
}

- (void)uploadDocTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryDocBase *)entry error:(NSError *)error {
	NSLog(@"Uploaded???");
	[self hideLoadingIndicators];
	if(error){
		NSLog(@"An error occurred: %@", error);
		[self showErrorAlert];
	} else {
		NSLog(@"Successfully Uploaded");
	}	
}

#pragma mark -
#pragma mark Settings work
- (void)settingsButtonPressed:(id)sender {
	EditUserListTableViewController *userController = [[EditUserListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	userController.user = [[UserService sharedInstance] retrieveUser];
	userController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:userController];
	[userController release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
	
}

- (void)editUserListTableViewController:(EditUserListTableViewController *)controller didChangeUser:(User *)changedUser {
	[self dismissModalViewControllerAnimated:YES];
	[[UserService sharedInstance] updateUser:changedUser];
}

- (void)editUserListTableViewControllerDidCancel:(EditUserListTableViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableData release];
    [super dealloc];
}


@end

