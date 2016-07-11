//
//  EditRowListTableViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-01-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditRowListTableViewController.h"

@interface EditRowListTableViewController (PrivateMethods)

- (NSArray *)loadTableData;
- (void)setCorrectValueFromTextField:(UITextField *)textField;

@end


@implementation EditRowListTableViewController

@synthesize exercise, delegate;

#pragma mark -
#pragma mark Initialization

//ToDo: fix bug where if you select an item in the parent view change some text, but hit cancel, then select the same item again
//from the parent, this view will load with the editted information, as opposed to the data from the parent
//ToDo: fix bug where if you select an item, then put your cursor in any field from the child textField, if you save, then the field
//will be set to blank, even though you didn't actually enter blank
//ToDo: fix bug where if app is shutdown while you were on the edit form, it will actually save the temporary data in the fields, without the
//user clicking save
//ToDo: if you add text to any field then hit back it saves anyway

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Edit Exercise";
	
	tableData = [[NSArray alloc] initWithArray:[self loadTableData]];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
	self.navigationItem.rightBarButtonItem = doneButton;
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
    return [tableData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//Need to look into how to sort the allKeys so that it will behave correctly in each call for sections
	return [[tableData objectAtIndex:section] objectForKey:@"Section Name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[tableData objectAtIndex:section] objectForKey:@"items"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 250.0, 40.0)];
		textField.delegate = self;
		[cell.contentView addSubview:textField];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
	NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[tableData objectAtIndex:indexPath.section] objectForKey:@"items"]];
	
	UITextField *textField = [self textFieldForCell:cell];
	textField.placeholder = [rowsForSection objectAtIndex: indexPath.row];
    textField.tag = [indexPath section];
	if ([indexPath section] > 0) {
		textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	}
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textFieldBeingEdited = textField;
	
	NSUInteger textFieldIndex[] = {textField.tag,0};
	NSIndexPath *textFieldIndexPath = [NSIndexPath indexPathWithIndexes:textFieldIndex length:2];

	[self.tableView scrollToRowAtIndexPath:textFieldIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	[self setCorrectValueFromTextField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if (textField.tag == 2) {		
		[textField resignFirstResponder];
	} else {
		NSUInteger nextIndex[] = {textField.tag + 1,0};
		NSIndexPath *nextIndexPath = [NSIndexPath indexPathWithIndexes:nextIndex length:2];
		UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
        [self setFirstResponderOnCellTextField:nextCell];
    }

	return YES;
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    //basically sets focus on the text field when a tap is registered on the row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self setFirstResponderOnCellTextField:cell];
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

#pragma mark -
#pragma private methods

-(void)doneButtonPressed:(id)sender{
    if (textFieldBeingEdited != nil){
        [self setCorrectValueFromTextField:textFieldBeingEdited];
    }
    
    if([self.delegate respondsToSelector:@selector(editRowListTableViewController:didChangeExercise:)]){
        [self.delegate editRowListTableViewController:self didChangeExercise:exercise];
    }
}

-(void)setCorrectValueFromTextField:(UITextField *)textField {
    if (textField.tag == 0) {
        exercise.name = [textField.text copy];
    } else if (textField.tag == 1) {
        exercise.weight = [textField.text copy];
    } else {
        exercise.reps = [textField.text copy];
    }
}

- (NSArray *)loadTableData{
    NSArray *array1 = [[NSArray alloc] initWithObjects:exercise.name, nil];
    NSDictionary *section1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Exercise Name:", @"Section Name", array1, @"items", nil];
    
    NSArray *array2 = [[NSArray alloc] initWithObjects:exercise.weight, nil];
    NSDictionary *section2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Excercise Weight:", @"Section Name", array2, @"items", nil];
    
    NSArray *array3 = [[NSArray alloc] initWithObjects:exercise.reps, nil];
    NSDictionary *section3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Excercise Reps:", @"Section Name", array3, @"items", nil];
    
    NSArray *tableInfo = [[NSArray alloc] initWithObjects: section1, section2, section3, nil];
    return tableInfo;
}

- (UITextField *)textFieldForCell:(UITableViewCell *)cell {
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews) {
        if ([oneView isMemberOfClass:[UITextField class]]) {
            textField = (UITextField *)oneView;
        }
    }
    return textField;
}

- (void)setFirstResponderOnCellTextField:(UITableViewCell *)cell {
    UITextField *textField = [self textFieldForCell:cell];
    if (textField) {
        [textField becomeFirstResponder];
    }
}

@end

