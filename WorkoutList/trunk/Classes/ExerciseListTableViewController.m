//
//  ExcerciseListTableViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseListTableViewController.h"
#import "EditRowListTableViewController.h"
#import "DatabasePopulator.h"
#import "ExerciseGroupService.h"
#import "WorkOutSession.h"
#import "WorkOutSessionService.h"
#import "ExerciseService.h"

@interface ExerciseListTableViewController (PrivateMethods)

-(NSArray *)loadTableDataArrayWithExerciseGroupsFromDb;
-(UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCell:(NSString *)name cellValue:(NSString *)value;
-(UITableViewCell *)tableView:(UITableView *)tableView textBoxStyleCell:(NSString *)name cellValue:(NSString *)value;
-(UITableViewCell *)tableView:(UITableView *)tableView threeColumnStyleCell:(NSString *)leftLabel middleLabel:(NSString *)middleLabel rightLabel:(NSString *)rightLabel;
-(UITableViewCell *)tableView:(UITableView *)tableView centeredTextStyleCell:(NSString *)text;
-(void)workOutSessionButtonPressed:(NSIndexPath *)indexPath;
- (void)startWorkOut;
- (void)endWorkOut;
- (void)showErrorAlert;
- (WorkOutSession *)findStartedWorkOutSession;

@end

@implementation ExerciseListTableViewController

@synthesize workOutName;

NSString *const START_WORK_OUT = @"Start Work Out";
NSString *const END_WORK_OUT = @"End Work Out Timer";

#pragma mark -
#pragma mark Initialization
//ToDo: handle any and all database errors gracefully, show a message box stating there was a problem
//ToDo: fix the cells to display correctly if you hit the edit button, as well as if you hit the delete button
//ToDo: add the ability to move rows to different sections
//ToDo: add the ability to add work outs
//ToDo: add the ability to export work outs to somewhere
//ToDo: fix bug where if you delete all rows for a section, the section continues to display
//ToDo: need to add the start/stop button to the end of the list as well
//ToDo: need to add a delegate with ok/cancel functionality for the start workout button
//ToDo: What should happen if there is no currentSession, and someone hits the end button, not sure if it is possible
//ToDo: allow the user to start an exercise then close the app, then continue using it, and be able to end the exercise
//without having to start the work out again
//ToDo: allow the user to start an exercise then close the app, then continue using it, and be able to end the exercise
//without having to start the work out again
//ToDo: remove managed object context from this class entirely, and add save/edit/delete methods to a service class
//and pass a workOut object instead of the workOut name

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
		
	tableData = [[NSMutableArray alloc] initWithArray: self.loadTableDataArrayWithExerciseGroupsFromDb];
	
	lastRow = 0;
	lastSection = 0;
}

-(NSArray *)loadTableDataArrayWithExerciseGroupsFromDb {
	NSMutableArray *data = [[NSMutableArray alloc] initWithArray:[[ExerciseGroupService sharedInstance] 
																  retreiveAllExerciseGroupsForWorkOutWithName: workOutName]];
	if ([self findStartedWorkOutSession]) {
		[data insertObject:END_WORK_OUT atIndex:0];
	} else {
		[data insertObject:START_WORK_OUT atIndex:0];
	}
	
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
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSUInteger sectionCount = [tableData count];
    return sectionCount;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//Return the number of rows in a section
	NSUInteger rowCount = 1;
	if (section > 0) {
		ExerciseGroup *group = [tableData objectAtIndex:section];
 	 	NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[group exercise] allObjects]];
		rowCount = [rowsForSection count];
		[rowsForSection release];
	}
	return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//Need to look into how to sort the allKeys so that it will behave correctly in each call for sections
	NSString *title = nil;
	if (section > 0) {
		title = [[tableData objectAtIndex:section] name];
	}
	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set up the cell...
	if (indexPath.section == 0 && indexPath.row == 0) {
		return [self tableView:tableView centeredTextStyleCell:[tableData objectAtIndex:indexPath.section]];
	} else {
		ExerciseGroup *group = [tableData objectAtIndex:indexPath.section];
		NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[group exercise] allObjects]];
		Exercise *exerciseForRow = [rowsForSection objectAtIndex: indexPath.row];
		[rowsForSection release];
		return [self tableView:tableView threeColumnStyleCell:exerciseForRow.name middleLabel:exerciseForRow.weight rightLabel:exerciseForRow.reps];				
	}	
}

-(UITableViewCell *)tableView:(UITableView *)tableView textBoxStyleCell:(NSString *)name cellValue:(NSString *)value {
    static NSString *CellIdentifier = @"TextBoxCellStyle";
    
	NSInteger TextFieldTag = 1;
	NSInteger MainLabelTag = 2;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
		
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 60.0, 40.0)];		
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0]; ;
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        mainLabel.tag = MainLabelTag;
		[cell.contentView addSubview:mainLabel];
		[mainLabel release];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 10.0, 180.0, 40.0)];
		textField.placeholder = @"insert text";
		textField.tag = TextFieldTag;
		[cell.contentView addSubview:textField];
		[textField release];
	}
    
    // Configure the cell...
	//cell.textLabel.text = name;
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:MainLabelTag];
	mainLabel.text = name;
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView threeColumnStyleCell:(NSString *)leftLabel middleLabel:(NSString *)middleLabel2 rightLabel:(NSString *)rightLabel{
    static NSString *CellIdentifier = @"ThreeColumnCellStyle";
    
	NSInteger mainLabelTag = 1;
	NSInteger middleLabelTag = 2;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 210.0, 40.0)];		
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0]; ;
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        mainLabel.tag = mainLabelTag;
		[cell.contentView addSubview:mainLabel];
		[mainLabel release];
		
		UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 2.0, 30.0, 40.0)];		
        middleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0]; ;
        middleLabel.textColor = [UIColor redColor];		
        middleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        middleLabel.tag = middleLabelTag;
		[cell.contentView addSubview:middleLabel];
		[middleLabel release];
	}
    
    // Configure the cell...
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
	mainLabel.text = leftLabel;
	UILabel *middleLabel = (UILabel *) [cell.contentView viewWithTag:middleLabelTag];
	middleLabel.text = middleLabel2;	
	
	cell.detailTextLabel.text = rightLabel;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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


-(UITableViewCell *)tableView:(UITableView *)tableView sliderStyleCell:(NSString *)name cellValue:(NSString *)value {
	static NSString *CellIdentifier = @"SliderCellStyle";
	
	UISlider *slider;
	UILabel *mainLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(80.0, 0.0, 180.0, 40.0)];
		slider.minimumValue = 0;
		slider.maximumValue = 10;
		[cell.contentView addSubview:slider];
		[slider release];
		
		mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 40.0)];		
        mainLabel.font = [UIFont systemFontOfSize:14.0];			
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        [cell.contentView addSubview:mainLabel];
		[mainLabel release];
	}
    
    // Configure the cell...
	slider.value = 3;
	mainLabel.text = @"Hello";
    
    return cell;
}

#pragma mark -
#pragma mark TableEditting

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		ExerciseGroup *group = [tableData objectAtIndex:indexPath.section];
		Exercise *exercise = [[[group exercise] allObjects] objectAtIndex:indexPath.row];
		
		if([[ExerciseService sharedInstance] deleteExercise:exercise]){
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[self showErrorAlert];
		}
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}   
}


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
	if (indexPath.section == 0 && indexPath.row == 0) {
		[self workOutSessionButtonPressed:indexPath];
	} else {
		EditRowListTableViewController *editNavController = [[EditRowListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];	
		ExerciseGroup *group = [tableData objectAtIndex:indexPath.section];
		NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[group exercise] allObjects]];
		editNavController.delegate = self;
		editNavController.exercise = [rowsForSection objectAtIndex: indexPath.row];
		[rowsForSection release];
		[self.navigationController pushViewController:editNavController animated:YES];
		[editNavController release];
		lastRow = indexPath.row;
		lastSection = indexPath.section;
	}
}

-(void)workOutSessionButtonPressed:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *message = [NSString stringWithFormat:@"Press Ok to %@", [tableData objectAtIndex:indexPath.section]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];	
	
	if ([[tableData objectAtIndex:0] isEqualToString:START_WORK_OUT]) {
		[self startWorkOut];
	} else {
		[self endWorkOut];
	}
	[self.tableView reloadData];
}

- (void)startWorkOut {
	if ([[WorkOutSessionService sharedInstance] startWorkOutSessionForWorkOutWithName:workOutName]) {
		[tableData replaceObjectAtIndex:0 withObject:END_WORK_OUT];	
	} else {
		[self showErrorAlert];
	}
}

-(WorkOutSession *)findStartedWorkOutSession {
	return [[WorkOutSessionService sharedInstance] retreiveStartedWorkOutSessionWithName:workOutName];
}

- (void)endWorkOut {	
	if ([[WorkOutSessionService sharedInstance] endStartedWorkOutSessionForWorkOutWithName:workOutName]) {
		[tableData replaceObjectAtIndex:0 withObject:START_WORK_OUT];
	} else {
		[self showErrorAlert];
	}
}


- (void)editRowListTableViewController:(EditRowListTableViewController *)controller didChangeExercise:(Exercise *)changedExercise{
	//http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html
	[self.navigationController popViewControllerAnimated:YES];
	ExerciseGroup *group = [tableData objectAtIndex:lastSection];
	Exercise *originalExercise = [[[group exercise] allObjects] objectAtIndex:lastRow];
	[originalExercise setName:[changedExercise name]];
	[originalExercise setWeight:[changedExercise weight]];
	[originalExercise setReps:[changedExercise reps]];
	
	if ([[ExerciseService sharedInstance] updateExercise:originalExercise]) {
		[self.tableView reloadData];
	} else {
		[self showErrorAlert];
	}	
}

#pragma mark -
#pragma mark UI Type stuff
- (void)showErrorAlert {
	NSString *message = @"We are sorry there was a problem processing Your Request Please Try Again later. Press Ok to continue";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
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
	[workOutName release];
    [super dealloc];
}

@end
