//
//  ExcerciseListTableViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExerciseListTableViewController.h"
#import "EditRowListTableViewController.h"
#import "ExerciseGroupService.h"
#import "WorkOutSession.h"
#import "WorkOutSessionService.h"
#import "ExerciseService.h"
#import "Exercise.h"
#import "ExerciseGroup.h"
#import "ExerciseTableViewCell.h"
#import "CenteredTableViewCell.h"

@interface ExerciseListTableViewController (PrivateMethods)

- (NSArray *)loadTableDataArrayWithExerciseGroupsFromDb;
- (Exercise *)exerciseForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setupNotificationObservers;
- (void)removeNotificationObservers;
- (void)setupTimers;
- (void)invalidateTimers;
- (void)startEndButtonDisplayTimer;
- (void)setupStartEndButtonCell:(CenteredTableViewCell *)cell forSession:(WorkOutSession *)session;
- (UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCell:(NSString *)name cellValue:(NSString *)value;
- (UITableViewCell *)tableView:(UITableView *)tableView textBoxStyleCell:(NSString *)name cellValue:(NSString *)value;
- (UITableViewCell *)tableView:(UITableView *)tableView threeColumnStyleCell:(NSString *)leftLabel middleLabel:(NSString *)middleLabel rightLabel:(NSString *)rightLabel;
- (void)workOutSessionButtonPressed:(NSIndexPath *)indexPath;
- (void)startWorkOut;
- (void)endWorkOut;
- (void)showErrorAlert;
- (WorkOutSession *)findStartedWorkOutSession;
- (bool)tableView:(UITableView *)tableView isWorkOutTimerButtonAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)colorForStartEndWorkOutCell;
- (void)applicationWillResignActive;
- (void)applicationDidBecomeActive;

@end

@implementation ExerciseListTableViewController

@synthesize workOutName;

NSString *const START_WORK_OUT = @"Start Work Out";
NSString *const END_WORK_OUT = @"Press to end work out timer";

#pragma mark -
#pragma mark Initialization
//ToDo: handle any and all database errors gracefully, show a message box stating there was a problem
//ToDo: fix the cells to display correctly if you hit the edit button, as well as if you hit the delete button
//ToDo: add the ability to move rows to different sections
//ToDo: add the ability to add work outs
//ToDo: add the ability to export work outs to somewhere
//ToDo: fix bug where if you delete all rows for a section, the section continues to display
//ToDo: need to add a delegate with ok/cancel functionality for the start workout button
//ToDo: What should happen if there is no currentSession, and someone hits the end button, not sure if it is possible

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
	
    _exerciseGroupService = [ExerciseGroupService sharedInstance];
    _workOutSessionService = [WorkOutSessionService sharedInstance];
    
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
		
	tableData = [[NSMutableArray alloc] initWithArray: self.loadTableDataArrayWithExerciseGroupsFromDb];
	
	lastRow = 0;
	lastSection = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupNotificationObservers];
    
    [self setupTimers];
}

- (NSArray *)loadTableDataArrayWithExerciseGroupsFromDb {
	NSMutableArray *data = [[NSMutableArray alloc] initWithArray:[_exerciseGroupService
																  retreiveAllExerciseGroupsForWorkOutWithName: workOutName]];
	_startButtonIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _endButtonIndexPath = [NSIndexPath indexPathForRow:0 inSection:[data count] + 1];
    if ([self findStartedWorkOutSession]) {
		[data insertObject:END_WORK_OUT atIndex:0];
        [data addObject:END_WORK_OUT];
	} else {
		[data insertObject:START_WORK_OUT atIndex:0];
        [data addObject:START_WORK_OUT];
	}
	
	return data;
}

- (void)setupNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)removeNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setupTimers {
    _startEndButtonTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startEndButtonDisplayTimer) userInfo:nil repeats:YES];
}

- (void)invalidateTimers {
    [_startEndButtonTimer invalidate];
}

- (Exercise *)exerciseForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseGroup *group = [tableData objectAtIndex:indexPath.section];
    NSArray *rowsForSection = [group sortedExercies];
    return [rowsForSection objectAtIndex: indexPath.row];
}

- (void)startEndButtonDisplayTimer {
    WorkOutSession *session = [self findStartedWorkOutSession];
    if (session && !session.isSessionFinished) {
        for (NSIndexPath *visiblePath in self.tableView.indexPathsForVisibleRows) {
            if (visiblePath == _startButtonIndexPath || visiblePath == _endButtonIndexPath) {
                CenteredTableViewCell *buttonCell = [self.tableView cellForRowAtIndexPath:visiblePath];
                [self setupStartEndButtonCell:buttonCell forSession:session];
            }
        }
    }
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
	if (section != _startButtonIndexPath.section && section != _endButtonIndexPath.section) {
		ExerciseGroup *group = [tableData objectAtIndex:section];
 	 	NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[group exercise] allObjects]];
		rowCount = [rowsForSection count];
	}
	return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//Need to look into how to sort the allKeys so that it will behave correctly in each call for sections
	NSString *title = nil;
	if (section != _startButtonIndexPath.section && section != _endButtonIndexPath.section) {
		title = [[tableData objectAtIndex:section] name];
	}
	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set up the cell...
    if ([self tableView:tableView isWorkOutTimerButtonAtIndexPath:indexPath]) {
        static NSString *CellIdentifier = @"CenteredTextCellStyle";
        
        CenteredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CenteredTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        WorkOutSession *session = [self findStartedWorkOutSession];
        [self setupStartEndButtonCell:cell forSession:session];
        return cell;
	} else {
		Exercise *exerciseForRow = [self exerciseForRowAtIndexPath:indexPath];
        static NSString *ExerciseCellReuseIdentifier = @"ExerciseCellReuseIdentifier";

        ExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExerciseCellReuseIdentifier];
        if (cell == nil) {
            cell = [[ExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ExerciseCellReuseIdentifier];
            
        }
        [cell setExercise:exerciseForRow];
        [cell setShowsReorderControl:YES];
		return cell;
	}	
}

- (UITableViewCell *)tableView:(UITableView *)tableView textBoxStyleCell:(NSString *)name cellValue:(NSString *)value {
    static NSString *CellIdentifier = @"TextBoxCellStyle";
    
	NSInteger TextFieldTag = 1;
	NSInteger MainLabelTag = 2;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];	
		
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 60.0, 40.0)];		
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0]; ;
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        mainLabel.tag = MainLabelTag;
		[cell.contentView addSubview:mainLabel];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90.0, 10.0, 180.0, 40.0)];
		textField.placeholder = @"insert text";
		textField.tag = TextFieldTag;
		[cell.contentView addSubview:textField];
	}
    
    // Configure the cell...
	//cell.textLabel.text = name;
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:MainLabelTag];
	mainLabel.text = name;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView threeColumnStyleCell:(NSString *)leftText middleLabel:(NSString *)middleText rightLabel:(NSString *)rightText {
    static NSString *CellIdentifier = @"ThreeColumnCellStyle";
    
	NSInteger mainLabelTag = 1;
	NSInteger middleLabelTag = 2;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		
		UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 205.0, 40.0)];
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0]; ;
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        mainLabel.tag = mainLabelTag;
		[cell.contentView addSubview:mainLabel];
		
		UILabel *middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(235.0, 2.0, 35.0, 40.0)];
        middleLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0]; ;
        middleLabel.textColor = [UIColor redColor];		
        middleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        middleLabel.tag = middleLabelTag;
		[cell.contentView addSubview:middleLabel];
	}
    
    // Configure the cell...
	UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
	mainLabel.text = leftText;
	UILabel *middleLabel = (UILabel *) [cell.contentView viewWithTag:middleLabelTag];
    middleLabel.text = middleText;
	
    cell.detailTextLabel.text = rightText;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView defaultStyleCell:(NSString *)name cellValue:(NSString *)value {
	static NSString *CellIdentifier = @"DefaultCellStyle";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...	
	cell.textLabel.text = name;
	cell.detailTextLabel.text = value;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
    return cell;	
}

- (UITableViewCell *)tableView:(UITableView *)tableView sliderStyleCell:(NSString *)name cellValue:(NSString *)value {
	static NSString *CellIdentifier = @"SliderCellStyle";
	
	UISlider *slider;
	UILabel *mainLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		slider = [[UISlider alloc] initWithFrame:CGRectMake(80.0, 0.0, 180.0, 40.0)];
		slider.minimumValue = 0;
		slider.maximumValue = 10;
		[cell.contentView addSubview:slider];
		
		mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 40.0)];		
        mainLabel.font = [UIFont systemFontOfSize:14.0];			
        mainLabel.textColor = [UIColor blackColor];		
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;		
        [cell.contentView addSubview:mainLabel];
	}
    
    // Configure the cell...
	slider.value = 3;
	mainLabel.text = @"Hello";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 43;
    if ([self tableView:tableView isWorkOutTimerButtonAtIndexPath:indexPath]) {
        height = [CenteredTableViewCell heightForCell];
    } else {
        Exercise *exerciseForRow = [self exerciseForRowAtIndexPath:indexPath];
        height = [ExerciseTableViewCell heightForCellWithString:exerciseForRow.name editingMode:self.editing] + 2.0;
    }
    return height;
}

- (void)setupStartEndButtonCell:(CenteredTableViewCell *)cell forSession:(WorkOutSession *)session {
    NSString *topLabelText = START_WORK_OUT;
    NSString *bottomLabelText = @"";
    cell.backgroundColor = [self colorForStartEndWorkOutCell];
    if (session && !session.isSessionFinished) {
        NSString *notFinished = [NSString stringWithFormat:@"Session Time: %@", [_workOutSessionService friendlyDurationForWorkOutSession:session]];
        topLabelText = notFinished;
        bottomLabelText = END_WORK_OUT;
    }
    cell.topLabel.text = topLabelText;
    cell.bottomLabel.text = bottomLabelText;
}

#pragma mark -
#pragma mark TableEditting

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate{
    [super setEditing:editing animated:animate];
    //http://locassa.com/animate-uitableview-cell-height-change/
    //begin updates and end updates cause the table cells reload, but does it while animating
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark Cell Reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView isWorkOutTimerButtonAtIndexPath:indexPath]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    ExerciseGroup *fromGroup = [tableData objectAtIndex:sourceIndexPath.section];
    Exercise *exercise = [self exerciseForRowAtIndexPath:sourceIndexPath];
    
    ExerciseGroup *toGroup = [tableData objectAtIndex:destinationIndexPath.section];
    NSNumber *ordinal = [NSNumber numberWithLong:destinationIndexPath.row];

    [_exerciseGroupService moveExcercise:exercise fromGroup:fromGroup toGroup:toGroup toOrdinal:ordinal];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == _startButtonIndexPath.section) {
        return [NSIndexPath indexPathForRow:0 inSection:proposedDestinationIndexPath.section + 1];
    }
    
    // Allow the proposed destination.
    return proposedDestinationIndexPath;
}

#pragma mark Cell Deleting
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView isWorkOutTimerButtonAtIndexPath:indexPath]) {
        return NO;
    }
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		Exercise *exercise = [self exerciseForRowAtIndexPath:indexPath];
		
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self tableView:tableView isWorkOutTimerButtonAtIndexPath:indexPath]) {
		[self workOutSessionButtonPressed:indexPath];
	} else {
		EditRowListTableViewController *editNavController = [[EditRowListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		editNavController.delegate = self;
		editNavController.exercise = [self exerciseForRowAtIndexPath:indexPath];
		[self.navigationController pushViewController:editNavController animated:YES];
		lastRow = indexPath.row;
		lastSection = indexPath.section;
	}
}

- (void)workOutSessionButtonPressed:(NSIndexPath *)indexPath {
	NSString *message = @"";
    if ([[tableData objectAtIndex:0] isEqualToString:START_WORK_OUT]) {
        message = @"Get started with your Workout";
	} else {
        message = @"Do you want to finish your workout?";
	}
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[tableData objectAtIndex:0] isEqualToString:START_WORK_OUT]) {
            [self startWorkOut];
        } else {
            [self endWorkOut];
        }
        [self.tableView reloadData];
    }];
    [alertView addAction:defaultAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)startWorkOut {
	if ([_workOutSessionService startWorkOutSessionForWorkOutWithName:workOutName]) {
		[tableData replaceObjectAtIndex:_startButtonIndexPath.section withObject:END_WORK_OUT];
        [tableData replaceObjectAtIndex:_endButtonIndexPath.section withObject:END_WORK_OUT];
	} else {
		[self showErrorAlert];
	}
}

- (WorkOutSession *)findStartedWorkOutSession {
	return [_workOutSessionService retreiveStartedWorkOutSessionWithName:workOutName];
}

- (void)endWorkOut {	
	if ([_workOutSessionService endStartedWorkOutSessionForWorkOutWithName:workOutName]) {
        [tableData replaceObjectAtIndex:_startButtonIndexPath.section withObject:START_WORK_OUT];
        [tableData replaceObjectAtIndex:_endButtonIndexPath.section withObject:START_WORK_OUT];
        
        WorkOutSession *session = [_workOutSessionService retreiveMostRecentlyEndedWorkOutSessionWithName:workOutName];
        NSString *duration = [_workOutSessionService friendlyDurationForWorkOutSession:session];
        NSString *message = [NSString stringWithFormat:@"Nice Workout here's your time\n %@", duration];
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertView addAction:defaultAction];
        [self presentViewController:alertView animated:YES completion:nil];
	} else {
		[self showErrorAlert];
	}
}

- (bool)tableView:(UITableView *)tableView isWorkOutTimerButtonAtIndexPath:(NSIndexPath *)indexPath {
    bool isWorkoutTimer = NO;
    if (indexPath.row == 0 && (indexPath.section == _startButtonIndexPath.section || indexPath.section == _endButtonIndexPath.section)) {
        isWorkoutTimer = YES;
    }
    return isWorkoutTimer;
}

- (UIColor *)colorForStartEndWorkOutCell {
    UIColor *color = [UIColor greenColor];
    if ([self findStartedWorkOutSession]) {
        color = [UIColor redColor];
    }
    return color;
}


- (void)editRowListTableViewController:(EditRowListTableViewController *)controller didChangeExercise:(Exercise *)changedExercise {
	//http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/TableView_iPhone/ManageInsertDeleteRow/ManageInsertDeleteRow.html
	[self.navigationController popViewControllerAnimated:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
	Exercise *originalExercise = [self exerciseForRowAtIndexPath:indexPath];
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
}

#pragma mark - 
#pragma mark UIApplication Multitasking handling Methods
- (void)applicationWillResignActive {
    [self invalidateTimers];
}

- (void)applicationDidBecomeActive {
    [self setupTimers];
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self invalidateTimers];
    [self removeNotificationObservers];
}

@end

