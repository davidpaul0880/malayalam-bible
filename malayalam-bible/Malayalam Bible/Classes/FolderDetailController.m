//
//  FolderViewController.m
//  Malayalam Bible
//
//  Created by jijo on 3/13/13.
//
//

#import "FolderDetailController.h"
#import "MalayalamBibleAppDelegate.h"
#import "MBConstants.h"
#import "UIDeviceHardware.h"


@interface FolderDetailController ()

@property (nonatomic, retain) UITextField *activeTextField;
@property(nonatomic, assign) NSInteger viewMode;
@property (nonatomic) id <MBFolderEditDelegate> delegatee;

@end

@implementation FolderDetailController

@synthesize viewMode= _viewMode;
@synthesize folderD = _folderD;
@synthesize activeTextField = _activeTextField;
@synthesize delegatee;

- (id)initWithStyle:(UITableViewStyle)style ViewMode:(NSInteger)vMode AndDelegate:(id)del
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.viewMode = vMode;
        self.delegatee = del;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *changedcolor;
    if (isdark ){
        
        changedcolor = [UIColor blackColor];
        
        
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   [UIColor blackColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
    }else{
        changedcolor = [UIColor whiteColor];
    }
    self.view.backgroundColor = changedcolor;
    
    
    
    
    self.navigationController.navigationBar.translucent = NO;
     if([UIDeviceHardware isOS7Device]){
    
         self.navigationController.navigationBar.barTintColor = changedcolor;
         self.navigationController.navigationBar.tintColor = [UIColor defaultWindowColor];
     }
    
    
    
    
    if(self.viewMode == kModeNew){
        self.title = @"Add Folder";
    }else{
        self.title = @"Edit Folder";
    }
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Selector methods

- (void) saveClicked:(id)sender{
    
    [self.activeTextField resignFirstResponder];
    
    if(self.viewMode == kModeNew){
        
        MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
         MBLog(@"here 0");
        self.folderD = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
        
        self.folderD.folder_label = self.activeTextField.text;
    }
    MBLog(@"here");
    if(self.folderD.folder_label.length > 0){
        MBLog(@"here insert");
        [delegatee upsertedFolder:self.folderD AndMode:self.viewMode];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bible"
                                                        message:@"Folder name should not be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}
#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return dateFormatter;
}
#pragma mark - Table view data source

 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
     if(section == 0){
         return NSLocalizedString(@"Folder Name:", @"");
     }/*else if(section == 1){
        return NSLocalizedString(@"Highlight Color:", @"");
     }*/else if(section == 1){
         return NSLocalizedString(@"Created Time:", @"");
     }else{
         return @"";//NSLocalizedString(@"interview_comments", @"");
     }
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    if(self.viewMode == kModeNew){
        return 1;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (isdark ){
            cell.backgroundColor = [UIColor darkGrayColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.section == 0){
            CGRect cellRect = [[cell contentView] frame];
            
            UITextField *tfiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, cellRect.size.width-10, cellRect.size.height-10)];
            tfiled.delegate = self;
            tfiled.tag = 1+indexPath.section;
            [[cell contentView] addSubview:tfiled];

        }
                
    }
    
    if (isdark ){
        //cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    
    if(indexPath.section == 0){
        
        UITextField *field = (UITextField *)[[cell contentView] viewWithTag:1+indexPath.section];
        if(self.viewMode == kModeNew){
            field.enabled = YES;
        }else if(self.viewMode == kModeEdit){
            
            if([@"Bookmarks" isEqualToString:self.folderD.folder_label]){
                field.enabled = NO;
            }else{
                field.enabled = YES;
            }
            field.text = self.folderD.folder_label;
        }else{
            field.enabled = NO;
            field.text = self.folderD.folder_label;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }/*else if(indexPath.section == 1){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        MBLog(@"cellll  self.folderD.folder_color = %@", self.folderD.folder_color);
        if(self.folderD.folder_color){
            cell.textLabel.text = @"";
            
             MBLog(@"cellll1  self.folderD.folder_color = %@", self.folderD.folder_color);
        }else{
            cell.textLabel.text = @"None";
             MBLog(@"cellll2  self.folderD.folder_color = %@", self.folderD.folder_color);
        }
        
    }*/else{
        cell.textLabel.text = [self.dateFormatter stringFromDate:self.folderD.createddate];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
   
    // Configure the cell...
    
    return cell;
}

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
       
        if(self.folderD.folder_color.length > 0){
            cell.backgroundColor = [self colorFromHexString:self.folderD.folder_color];
        }else{
            cell.backgroundColor = [self colorFromHexString:@"#FFFFFF"];
        }
    }
	
}
 */
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*if(indexPath.section == 1 && (self.viewMode == kModeNew || self.viewMode == kModeEdit)){
        
        ColorViewController *controller = [[ColorViewController alloc] initWithStyle:UITableViewStyleGrouped SelectedColor:self.folderD.folder_color Delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }*/
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	self.activeTextField = textField;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   if(self.viewMode != kModeNew){
       self.folderD.folder_label = textField.text;
   }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

#pragma mark MBColourSelectorDelegate
- (void)colorStringDidChange:(NSString *)newColor{
    
    
    [self.folderD setFolder_color:newColor];
    
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


@end
