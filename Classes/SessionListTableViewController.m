//
//  SessionListTableViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-03-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SessionListTableViewController.h"
#import "WorkOutSession.h"
#import "WorkOut.h"
#import "WorkOutSessionService.h"
#import "GoogleDataService.h"
//#import "GDataDocs.h"
#import "UserService.h"

//info on importing gdata http://hoishing.wordpress.com/2011/08/23/gdata-objective-c-client-setup-in-xcode-4/
//ToDo: format the duration in a more usefull format
//ToDo: Have settings somewhere for username/password
//ToDo: deal with feed fetch errors/upload errors
//ToDo: if the workout folder doesn't exist create it
//ToDo: do all the exporting in a seperate thread - I think this is already done, instead, we should display
//in the UI a spinner, as well as disable the export button so it can't be clicked while already
//exporting, then once complete re-enable the button and hide the spinner

NSString * const SLTVC_SPREADSHEET_NAME = @"Sessions";

@interface SessionListTableViewController (PrivateMethods)

- (NSArray *)loadTableDataArrayWithWorkOutSessionsFromDb;
//- (void)fetchDocList;
//- (GDataServiceGoogleDocs *)docsService;

//- (void)docListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedDocList *)feed error:(NSError *)error;
//- (void)createAndSaveSpreadsheetWithFeed:(GDataFeedDocList *)feed inFolderWithName:(GDataEntryFolderDoc *)folderEntry;
- (NSString *)generateSessionSpreadSheetTitle;
- (NSString*)generateSessionSpreadSheetData;
//- (void)uploadDocTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryDocBase *)entry error:(NSError *)error;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
- (void)showErrorAlert;

@end


@implementation SessionListTableViewController

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Sessions";
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportButtonPressed:)];
	self.navigationItem.rightBarButtonItem = exportButton;
	
	dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMM, dd, yyyy" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];
    
    csvFileGenerationService = [CSVFileGenerationService sharedInstance];
}
		 
- (NSArray *)loadTableDataArrayWithWorkOutSessionsFromDb {
	return [[WorkOutSessionService sharedInstance] retreiveAllWorkOutSessions];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	tableData = [[NSArray alloc] initWithArray: self.loadTableDataArrayWithWorkOutSessionsFromDb];
	[self.tableView reloadData];
}

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
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	WorkOutSession *session = [tableData objectAtIndex:indexPath.row];
	NSString *formattedDateString = [dateFormatter stringFromDate:[session startDate]];
	
	cell.textLabel.text = [session workOut].name;
	
    NSString *label = [NSString stringWithFormat:@"%@ - %@", formattedDateString, [[WorkOutSessionService sharedInstance] friendlyDurationForWorkOutSession:session]];
	cell.detailTextLabel.text = label;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark -
#pragma mark Export work

- (void)exportButtonPressed:(id)sender {
    NSString *fileName = [self generateSessionSpreadSheetTitle];
    
    NSString *csvString = [self generateSessionSpreadSheetData];
    NSError *error = nil;
    NSURL *csvURL = [csvFileGenerationService createCSVFileWithFileName:fileName Body:csvString error:error];
    
    if (error) {
        [self showErrorAlert];
    } else {
        if (MFMailComposeViewController.canSendMail) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setSubject:@"Email Workout Session Data"];
            [mailController setMessageBody:@"Attached is a .csv file of your Workout Session Data." isHTML:NO];
            [mailController addAttachmentData:[NSData dataWithContentsOfURL:csvURL] mimeType:@"text/csv" fileName:fileName];
            
            [self presentViewController:mailController animated:YES completion:nil];
        } else {
            [self showErrorAlert];
        }
    }
//	[[GoogleDataService sharedInstance] fetchDocListWithdidFinishSelector:@selector(docListFetchTicket:finishedWithFeed:error:) forDelegate:self];
//	[self showLoadingIndicators];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSError *removeFileError = nil;
    [csvFileGenerationService removeTempFilesWithError:removeFileError];
    if (removeFileError) {
        [self showErrorAlert];
    }
    if (error) {
        [self showErrorAlert];
    }
}

//- (void)docListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedDocList *)feed error:(NSError *)error {
//	if (error) {
//		NSLog(@"Got Feed with error: %@", [error description]);
//		[self showErrorAlert];
//	} else {
//		NSArray *folderEntries = [feed entriesWithCategoryKind:kGDataCategoryFolderDoc];
//		GDataEntryFolderDoc *workoutFolder;
//		
//		for(GDataEntryFolderDoc *folderEntry in folderEntries){
//			NSString *title = [[folderEntry title] stringValue];
//			if ([title isEqualToString:[[UserService sharedInstance] retrieveUser].googleFolder]) {
//				workoutFolder = folderEntry; 
//			}	
//		}
//		[self createAndSaveSpreadsheetWithFeed:feed inFolderWithName:workoutFolder];
//	}
//}

//- (void)createAndSaveSpreadsheetWithFeed:(GDataFeedDocList *)feed inFolderWithName:(GDataEntryFolderDoc *)folderEntry {
//	//http://groups.google.com/group/gdata-objectivec-client/browse_thread/thread/4569ad053eb88090
//	// Insert a new document with the client's data.
//	GDataEntrySpreadsheetDoc *entryNew = [GDataEntrySpreadsheetDoc documentEntry];
//	NSString *documentName = [self generateSessionSpreadSheetTitle];
//	NSData *data = [[self generateSessionSpreadSheetData] dataUsingEncoding:NSUTF8StringEncoding]; 
//	
//	[entryNew setTitleWithString:documentName];
//	[entryNew setUploadData:data];
//	[entryNew setUploadMIMEType:@"text/csv"];
//	[entryNew setUploadSlug:[NSString stringWithFormat:@"%@.csv", documentName]];
//	
//	GDataCategory *category = [GDataCategory categoryWithScheme:kGDataCategoryScheme term:kGDataCategorySpreadsheetDoc];	 
//	[entryNew setCategories:[NSArray arrayWithObject:category]];
//	[category setLabel:@"spreadsheet"];
//	
//	NSURL *urlPost = [GDataServiceGoogleDocs folderContentsFeedURLForFolderID:[folderEntry resourceID]];
//	GDataServiceGoogleDocs *service = [[GoogleDataService sharedInstance] docsService];
//	[service setServiceUploadChunkSize:0];
//	[service fetchEntryByInsertingEntry:entryNew forFeedURL:urlPost delegate:self
//					  didFinishSelector:@selector(uploadDocTicket:finishedWithEntry:error:)];
//}

-(NSString *)generateSessionSpreadSheetTitle {
	NSDate *currentDate = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *formattedDateString = [formatter stringFromDate:currentDate];
	NSString *title = [NSString stringWithFormat:@"%@-%@.csv", SLTVC_SPREADSHEET_NAME, formattedDateString];
	return title;
}

-(NSString *)generateSessionSpreadSheetData {
	return [[WorkOutSessionService sharedInstance] generateCSVDataForAllWorkOutSessionsWithDateFormatter:[GoogleDataService docsDateFormatter]];
}

//- (void)uploadDocTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryDocBase *)entry error:(NSError *)error {
//	NSLog(@"Uploaded???");
//	[self hideLoadingIndicators];
//	if(error){
//		NSLog(@"An error occurred: %@", error);
//		[self showErrorAlert];
//	} else {
//		lastExportedTitle = [[entry title] stringValue];
//	}
//	
//}

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
        spinner = nil;
    }
}

#pragma mark -
#pragma mark UI Type stuff
- (void)showErrorAlert {
	NSString *message = @"We are sorry there was a problem processing Your Request Please Try Again later. Press Ok to continue";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[self hideLoadingIndicators];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

