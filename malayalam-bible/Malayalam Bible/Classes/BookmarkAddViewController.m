//
//  BookmarkAddViewController.m
//  Malayalam Bible
//
//  Created by jijo on 11/6/12.
//
//

#import "BookmarkAddViewController.h"
#import "FolderSelectController.h"
#import "MalayalamBibleAppDelegate.h"

#import "Folders.h"
#import "BookMarks.h"
#import "UIDeviceHardware.h"
#import "MBConstants.h"


@interface BookmarkAddViewController ()


@property (nonatomic, retain) UITextField *activeTextField;


@end


@implementation BookmarkAddViewController

@synthesize activeTextField = _activeTextField;
@synthesize defaultFolder = _defaultFolder;
@synthesize bookMark, delegate, verseText;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([UIDeviceHardware isOS7Device]){
        
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    
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
    
    
    
    self.navigationController.navigationBar.barTintColor = changedcolor;
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor defaultWindowColor];

    

    self.title = NSLocalizedString(@"add.bookmark", @"");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
    
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

#pragma mark selector methods

- (void) saveClicked:(UIBarButtonItem *)btn{
    
    [self.activeTextField resignFirstResponder];
    
       
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    
    
    
    BookMarks *bookMarktoSave = [NSEntityDescription insertNewObjectForEntityForName:@"BookMarks" inManagedObjectContext:context];
    [bookMarktoSave setVersetitle:self.bookMark.versetitle];
    [bookMarktoSave setBookid:self.bookMark.bookid];
    [bookMarktoSave setChapter:self.bookMark.chapter];
    [bookMarktoSave setVerseid:self.bookMark.verseid];

    
    
    bookMarktoSave.createddate = [NSDate date]; ///setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"createddate"];
    if(!self.bookMark.bmdescription){
        bookMarktoSave.bmdescription = self.verseText;
    }else{
        bookMarktoSave.bmdescription = self.bookMark.bmdescription;
    }
    
    [bookMarktoSave setFolder:self.defaultFolder];
            
    NSError *error;
    [context save:&error];
    MBLog(@"ggggg");
    [delegate setBookMarkForIds:self.bookMark];
    MBLog(@"ggggg2");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) cancelClicked:(UIBarButtonItem *)btn{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    [context rollback];
}

//+20131114
- (BOOL)shouldAutorotate {
    
    
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if([UIDeviceHardware isOS6Device]){
        return YES;
    }else{
        
    }
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        
        if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
           (interfaceOrientation == UIInterfaceOrientationLandscapeRight))  {
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;//[self.arrayBookmarkDetails count];
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
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (isdark ){
            cell.backgroundColor = [UIColor darkGrayColor];
        }
        
        if(indexPath.section == 1){
            CGRect cellRect = [[cell contentView] frame];
            UITextField *tfiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, cellRect.size.width-10, cellRect.size.height-10)];
            tfiled.delegate = self;
            tfiled.tag = 1+indexPath.section;
            [[cell contentView] addSubview:tfiled];
        }
    }
    
    if (isdark ){
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
                
    }
    
    if(indexPath.section == 2){
        Folders *foldrs = self.defaultFolder;//[self.arrayBookmarkDetails objectAtIndex:indexPath.section];
        cell.textLabel.text = foldrs.folder_label;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if(indexPath.section == 0){
        
        
        
        
        cell.textLabel.text = self.bookMark.versetitle;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        
        UITextField *field = (UITextField *)[[cell contentView] viewWithTag:1+indexPath.section];
        if(self.bookMark.bmdescription){
            field.text = self.bookMark.bmdescription;
        }else{
            field.placeholder = verseText;//self.bookMark.versetitle;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    
    return cell;
}

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
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    
    
    if(section == 2){
        return NSLocalizedString(@"bookmark.group", @"");
    }else if(section == 0){
        
        return NSLocalizedString(@"bookmark.verse", @"");
    }else{
        return NSLocalizedString(@"bookmark.description", @"");
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 2){
        
        FolderSelectController *controller = [[FolderSelectController alloc] initWithStyle:UITableViewStyleGrouped Delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	self.activeTextField = textField;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   // NSInteger section = textField.tag;
   
    self.bookMark.bmdescription = textField.text;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

#pragma mark  MBFolderSelectDelegate 

- (void)selectedFolder:(Folders *)folder{
    
    self.defaultFolder = folder;
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
