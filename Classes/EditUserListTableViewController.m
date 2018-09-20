//
//  EditUserListTableViewController.m
//  WorkoutList
//
//  Created by Dean Gaudet on 11-04-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditUserListTableViewController.h"
#import "User.h"

//ToDo: find out the correct way to have private methods in objective-c
//ToDo: clean up properties, I don't think the textFieldBeingEdited need to be a property
//ToDo: actually save the user that was modified
//ToDo: Use a gear of some sort to indicate settings, instead of the compose icon

@interface EditUserListTableViewController (PrivateMethods)

- (NSArray *)loadTableData;
- (void)setCorrectValueFromTextField:(UITextField *)textField;

@end

@implementation EditUserListTableViewController

@synthesize user, delegate;

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
	
	self.title = @"Google information";
	tableData = [[NSArray alloc] initWithArray:[self loadTableData]];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
    
    // TODO(developer) Configure the sign-in button look/feel
    
//    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
}

-(void)doneButtonPressed:(id)sender{
	if (textFieldBeingEdited != nil){
		[self setCorrectValueFromTextField:textFieldBeingEdited];
	}
	
	if([self.delegate respondsToSelector:@selector(editUserListTableViewController:didChangeUser:)]){
		[self.delegate editUserListTableViewController:self didChangeUser:user];
	}
}

-(void)cancelButtonPressed:(id)sender {
	if([self.delegate respondsToSelector:@selector(editUserListTableViewControllerDidCancel:)]){
		[self.delegate editUserListTableViewControllerDidCancel:self];
	}
}

-(void)setCorrectValueFromTextField:(UITextField *)textField {
	if (textField.tag == 0) {
		user.userName = [textField.text copy];
	} else if (textField.tag == 1) {
		user.password = [textField.text copy];
	} else {
		user.googleFolder = [textField.text copy];
	}
}

- (NSArray *)loadTableData{
	NSArray *array1 = [[NSArray alloc] initWithObjects:user.userName, nil];	
	NSDictionary *section1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email Address:", @"Section Name", array1, @"items", nil];
	
	NSArray *array2 = [[NSArray alloc] initWithObjects:user.password, nil];	
	NSDictionary *section2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Password:", @"Section Name", array2, @"items", nil];
	
	NSArray *array3 = [[NSArray alloc] initWithObjects:user.googleFolder, nil];	
	NSDictionary *section3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Folder To Store Exported items:", @"Section Name", array3, @"items", nil];
    
    NSArray *array4 = @[user.googleFolder];
    NSDictionary *section4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"Section Name", array4, @"items", nil];
    
    NSDictionary *section5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"Section Name", array4, @"items", nil];
	
    NSArray *tableInfo = @[section1, section2, section3, section4, section5];
	return tableInfo;
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
    
    if(indexPath.section < 3){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 10.0, 250.0, 40.0)];
            textField.delegate = self;	
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:textField];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // Configure the cell...
        NSArray *rowsForSection = [[NSArray alloc] initWithArray:[[tableData objectAtIndex:indexPath.section] objectForKey:@"items"]];
        
        UITextField *textField = nil;
        for (UIView *oneView in cell.contentView.subviews) {
            if ([oneView isMemberOfClass:[UITextField class]]) {
                textField = (UITextField *)oneView;
            }
        }
        
        textField.text = [rowsForSection objectAtIndex: indexPath.row];
        textField.tag = [indexPath section];
        if ([indexPath section] > 0) {
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        if ([indexPath section] == 1) {
            textField.secureTextEntry = YES;
        }
        return cell;
    } else if(indexPath.section == 3){
        static NSString *CellIdentifier = @"SignInCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
//            GIDSignInButton *siginInButton = [[GIDSignInButton alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 40.0)];
//            [cell.contentView addSubview:siginInButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        return [self tableView:tableView centeredTextStyleCell:@"Sign Out"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView centeredTextStyleCell:(NSString *)text {
    static NSString *CellIdentifier = @"CenteredTextCellStyle";
    
    NSInteger mainLabelTag = 1;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 2.0, 285.0, 40.0)];
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        mainLabel.tag = mainLabelTag;
        [cell.contentView addSubview:mainLabel];
    }
    
    // Set up the cell...
    UILabel *mainLabel = (UILabel *) [cell.contentView viewWithTag:mainLabelTag];
    mainLabel.text = text;
    
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
		
		UITextField *nextTextField = nil;
		for (UIView *oneView in nextCell.contentView.subviews) {
			if ([oneView isMemberOfClass:[UITextField class]]) {
				nextTextField = (UITextField *)oneView;
			}
		}
		[nextTextField becomeFirstResponder];
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
    if (indexPath.section == 4) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [[GIDSignIn sharedInstance] signOut];
    }
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

