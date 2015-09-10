//
//  BookMarkViewController.m
//  Malayalam Bible
//
//  Created by jijo on 4/22/13.
//
//

#import "BookMarkViewController.h"
#import "BibleDao.h"
#import "BookMarks.h"
#import "Folders.h"
#import "MalayalamBibleDetailViewController.h"
#import "MalayalamBibleAppDelegate.h"
#import "MBConstants.h"
#import "UIDeviceHardware.h"

@interface BookMarkViewController ()

@property(assign) BOOL isChild;

@end

@implementation BookMarkViewController

@synthesize detailViewController = _detailViewController;
@synthesize arrayBookmarks, arrayFolders, bmArray, parentFolder;

- (id)initWithStyle:(UITableViewStyle)style BMFolder:(Folders *)folder
{
    self = [super initWithStyle:style];
    if (self) {
        self.parentFolder = folder;
        // Custom initialization
        if(folder == nil){
            BibleDao *daoo = [[BibleDao alloc] init];
            self.bmArray = [daoo getAllBookMarks];
            self.arrayBookmarks = [bmArray objectAtIndex:0];
            self.arrayFolders = [bmArray objectAtIndex:1];
        }else{

            self.isChild = YES;
            NSArray *af1 = [folder.bookmarks allObjects];
            self.arrayBookmarks = [NSMutableArray arrayWithArray:af1];
            self.arrayFolders = nil;
            
            self.bmArray = [NSArray arrayWithObject:arrayBookmarks];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 50;
    self.tableView.allowsSelectionDuringEditing = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *changedcolor;
    if (isdark ){
        
        changedcolor = [UIColor blackColor];
        
        
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        /*if ([UIDeviceHardware isOS7Device]) {
            
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor],UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        }*/
        
         
    }else{
        changedcolor = [UIColor whiteColor];
    }
    self.view.backgroundColor = changedcolor;
    
    
    
    
    self.navigationController.navigationBar.translucent = NO;
    BOOL isos7 = NO;
    if([UIDeviceHardware isOS7Device]){
    
        isos7 = YES;
        self.navigationController.navigationBar.barTintColor = changedcolor;
        self.navigationController.navigationBar.tintColor = [UIColor defaultWindowColor];
    }else{
        if (isdark) {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            
        }else{
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
    }
    
    
    
    //BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    CGRect r = self.navigationController.navigationBar.frame;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
    
    lblTitle.text = NSLocalizedString(@"title.bookmarks", @"");
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    
    if (isdark || !isos7) {
        lblTitle.textColor = [UIColor whiteColor];
    }else{
        lblTitle.textColor = [UIColor blackColor];
    }
    self.navigationItem.titleView = lblTitle;

    
    //self.navigationItem.title =
    
    if(!self.isChild){
        
        UIBarButtonItem *temporaryBarButtonItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
        
        self.navigationItem.rightBarButtonItem = temporaryBarButtonItem1;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark @Selector methods

-(void) editButtonClicked:(id)sender{
    
    [self setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [self.tableView reloadData];
}
- (void) cancelClicked:(id) sender{
    
    [self setEditing:NO animated:YES];
    
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    [context rollback];
    if(self.parentFolder == nil){
        BibleDao *daoo = [[BibleDao alloc] init];
        self.bmArray = [daoo getAllBookMarks];
        self.arrayBookmarks = [bmArray objectAtIndex:0];
        self.arrayFolders = [bmArray objectAtIndex:1];
    }else{
        
        self.isChild = YES;
        NSArray *af1 = [parentFolder.bookmarks allObjects];
        self.arrayBookmarks = [NSMutableArray arrayWithArray:af1];
        self.arrayFolders = nil;
        
        self.bmArray = [NSArray arrayWithObject:arrayBookmarks];
    }
    
    
    UIBarButtonItem *temporaryBarButtonItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem1;
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    
    [self.tableView reloadData];

}
- (void) doneClicked:(id) sender{
    
    [self setEditing:NO animated:YES];
    
    [self.navigationItem setHidesBackButton:NO animated:YES];
    //save context
    
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    NSError *error;
    [context save:&error];
    
    UIBarButtonItem *temporaryBarButtonItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem1;
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section == 0 && arrayBookmarks.count == 0 && arrayFolders.count == 0 && !tableView.editing){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if (isdark ){
            lbl.textColor = [UIColor whiteColor];
        }
        lbl.numberOfLines = 0;
        lbl.text = NSLocalizedString(@"no.bookmarks", @"");
        //    UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        //    [fview setBackgroundColor:[UIColor greenColor]];
        return  lbl;
    }
    return nil;
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    if(section == 0 && arrayBookmarks.count == 0 && arrayFolders.count == 0 && !tableView.editing){
        return 300;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if(self.tableView.editing){
        return 1 + bmArray.count;
    }
    
    return 2;//bmArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(section == 0){
        
        
        return [self.arrayBookmarks count];
        
    }else if (section == 1) {
        
        return [self.arrayFolders count];
        
    }else{
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"BookmarkCell";
    if (indexPath.section == 1) {
        ident = @"FolderCell";
    }else if (indexPath.section == 2) {
        ident = @"NewFolder";
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
       
        if (isdark ){
            cell.backgroundColor = [UIColor darkGrayColor];
        }
        
        cell.textLabel.font = [UIFont fontWithName:kFontName size:FONT_SIZE];
        cell.detailTextLabel.font = [UIFont fontWithName:kFontName size:(FONT_SIZE * 14 / 18)];
    }
    
    if (isdark ){
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
    }
    
    
    if(indexPath.section == 0){
        
        BookMarks *bm = [self.arrayBookmarks objectAtIndex:indexPath.row];
        cell.textLabel.text = bm.versetitle;
        cell.detailTextLabel.text = bm.bmdescription;
        
        
    }else if (indexPath.section == 1){
        
        Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
        cell.textLabel.text = fldr.folder_label;
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
        
    }else{
        
        cell.textLabel.text = @"Add Folder";
    }
    
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0 || indexPath.section == 1){
        
        if(self.editing){
            
         
            if(indexPath.section == 0){
                
                //BookMarks *bm = [self.arrayBookmarks objectAtIndex:indexPath.row];
              
                
            }else{
                
                Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
                
                FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeEdit AndDelegate:self];
                detailCtrlr.folderD = fldr;
                [self.navigationController pushViewController:detailCtrlr animated:YES];

            }
            
            
            
            
            
        }else{
            
            if(indexPath.section == 0){
                BookMarks *bm = [self.arrayBookmarks objectAtIndex:indexPath.row];
                NSNumber *verseidNum = [NSNumber numberWithInteger:[bm.verseid integerValue]];
                
                NSMutableDictionary *dictVerseid = [NSMutableDictionary dictionaryWithObject:verseidNum forKey:@"verse_id"];
                
                MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:dictVerseid];
                
                
                BibleDao *daoo = [[BibleDao alloc] init];
                Book *bookdetails = [daoo getBookUsingId:[bm.bookid integerValue]];
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    
                    MBLog(@"verseidNum = %@,bookdetails.bookId = %i, bm.chapter = %@ ", verseidNum, bookdetails.bookId, bm.chapter);
                    self.detailViewController.selectedBook = bookdetails;
                    self.detailViewController.chapterId = [bm.chapter integerValue];
                    [self.detailViewController configureView];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }else{
                    
                    
                    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    Book *selectBook = bookdetails;
                    
                    /**set select book*** +20121006 **/
                    NSUInteger bookindex= selectBook.bookId;
                    NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:0];//+20140929
                    
                    [dict setObject:[NSNumber numberWithInteger:bookindex-1] forKey:bmBookSection];//+20121017
                    
                    
                    
                    [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:bm.chapter];
                    
                    
                    NSMutableDictionary *dictthird = [NSMutableDictionary dictionaryWithCapacity:1];
                    
                    NSNumber *verseid =  [NSNumber numberWithInteger:[bm.verseid integerValue]];
                    [dictthird setValue:verseid forKey:@"verse_id"];
                    
                    
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [appDelegate openVerseForiPadSavedLocation];
                }
            }else{
                Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
                
                BookMarkViewController *bmctrlr = [[BookMarkViewController alloc] initWithStyle:UITableViewStyleGrouped BMFolder:fldr];
                bmctrlr.detailViewController = self.detailViewController;
                [self.navigationController pushViewController:bmctrlr animated:YES];
            }
            
          
            
        }
        
    }else{
        
        FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeNew AndDelegate:self];
        [self.navigationController pushViewController:detailCtrlr animated:YES];
        
        
    }
    
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.editing){
        if(indexPath.section == 0 || indexPath.section == 1) {
            
            return UITableViewCellEditingStyleDelete;
            /*
            NSObject *obj = [self.arrayBookmarks objectAtIndex:indexPath.row];
            
            if([obj isMemberOfClass:[Folders class]]){
                
                Folders *fldr = [self.arrayBookmarks objectAtIndex:indexPath.row];
                
                if([fldr.folder_label isEqualToString:@"Bookmarks"]){
                    return UITableViewCellEditingStyleNone;
                }else{
                    return UITableViewCellEditingStyleDelete;
                }
            }else{
                return UITableViewCellEditingStyleDelete;
            }*/
            
        } else {
            return UITableViewCellEditingStyleInsert;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //NSObject *obj = [self.arrayBookmarks objectAtIndex:indexPath.row];
        
        if(indexPath.section == 0){
            BookMarks *bm = [self.arrayBookmarks objectAtIndex:indexPath.row];
            
            
            MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
            
            NSManagedObjectContext *context =  [appDelegate managedObjectContext];
            
            [self.arrayBookmarks removeObjectAtIndex:indexPath.row];
            [context deleteObject:bm];
            
           // NSError *error;
            //[context save:&error];
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            
        }else{
            
            
            
            [tableView beginUpdates];
            
            MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            NSManagedObjectContext *context =  [appDelegate managedObjectContext];
            Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
            [context deleteObject:fldr];
            
           // NSError *error;
            //[context save:&error];
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.arrayFolders removeObjectAtIndex:indexPath.row];
            [tableView endUpdates];

        }
        
        
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeNew AndDelegate:self];
        [self.navigationController pushViewController:detailCtrlr animated:YES];
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
 
 
 }*/



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    if(fromIndexPath.section == 0){
        
        if(toIndexPath.section == 0){
            
            NSUInteger difrence = fromIndexPath.row-toIndexPath.row;
            if(difrence == 1){
                
                BookMarks *bm1 = [self.arrayBookmarks objectAtIndex:fromIndexPath.row];
                BookMarks *bm2 = [self.arrayBookmarks objectAtIndex:toIndexPath.row];
                
                NSDate *temp = bm1.createddate;
                bm1.createddate = bm2.createddate;
                bm2.createddate = temp;
                
                [self.arrayBookmarks exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
                
            }else{
                
                
                if(fromIndexPath.row > toIndexPath.row){
                    [self.arrayBookmarks insertObject:[self.arrayBookmarks objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row];
                    [self.arrayBookmarks removeObjectAtIndex:fromIndexPath.row+1];
                    
                }else{
                    [self.arrayBookmarks insertObject:[self.arrayBookmarks objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row+1];
                    [self.arrayBookmarks removeObjectAtIndex:fromIndexPath.row];
                    
                }
                
                NSDate *temp = [NSDate date];
                for (int i =0; i<self.arrayBookmarks.count; i++) {
                    
                    BookMarks *bm = [self.arrayBookmarks objectAtIndex:i];
                    
                    bm.createddate = temp;
                    
                    temp = [temp dateByAddingTimeInterval:1*60];
                }
            }
        }
        
        
    }else if(fromIndexPath.section == 1){
        
        if(toIndexPath.section == 1){
            
            NSUInteger difrence = fromIndexPath.row-toIndexPath.row;
            if(difrence == 1){
                
                Folders *fldr1 = [self.arrayFolders objectAtIndex:fromIndexPath.row];
                Folders *fldr2 = [self.arrayFolders objectAtIndex:toIndexPath.row];
                
                NSDate *temp = fldr1.createddate;
                fldr1.createddate = fldr2.createddate;
                fldr2.createddate = temp;
                
                [self.arrayFolders exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
            }else{
                
                if(fromIndexPath.row > toIndexPath.row){
                    [self.arrayFolders insertObject:[self.arrayFolders objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row];
                    [self.arrayFolders removeObjectAtIndex:fromIndexPath.row+1];
                    
                }else{
                    [self.arrayFolders insertObject:[self.arrayFolders objectAtIndex:fromIndexPath.row] atIndex:toIndexPath.row+1];
                    [self.arrayFolders removeObjectAtIndex:fromIndexPath.row];
                    
                }
                
                NSDate *temp = [NSDate date];
                for (int i =0; i<self.arrayFolders.count; i++) {
                    
                    Folders *fldr = [self.arrayFolders objectAtIndex:i];
                    
                    fldr.createddate = temp;
                    
                    temp = [temp dateByAddingTimeInterval:1*60];
                }
            }
        }
    }
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        long row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.section < 2) {
        return true;
    }else{
        return false;
    }
}

#pragma mark MBFolderEditDelegate
- (void)upsertedFolder:(Folders *)folder AndMode:(NSInteger)mode{
    
    MBLog(@"delegate updsrt %@", folder.folder_label);
    NSString *folderName = folder.folder_label;
    
    BOOL validate = true;
    if(!folderName || folderName.length == 0){
        validate = false;
    }
    
    
    if(validate){
        if(mode == kModeNew){
            
            for(Folders *tempfldr in self.arrayFolders){
                
                    MBLog(@"tempfldr.folder_label %@", tempfldr.folder_label);
                    if([folderName isEqualToString:tempfldr.folder_label]){
                        validate = false;
                        break;
                    }
                
            }
            
        }else{
            
            for(Folders *tempfldr in self.arrayFolders){
                
                
                    MBLog(@"tempfldr.folder_label %@", tempfldr.folder_label);
                    if(folder != tempfldr){
                        
                        
                        if([folderName isEqualToString:tempfldr.folder_label]){
                            validate = false;
                            break;
                        }
                    }else{
                        MBLog(@"same");
                    }

                
            }
        }
        
    }
    
    if(validate){
        
        MBLog(@"validated");
        
        if(mode == kModeNew){
            
            
            
            [folder setCreateddate:[NSDate date]];
            
            
        }else{
            //update to coredata
            
        }
        
        /*MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
        NSError *error;
        [context save:&error];
        */
        if(mode == kModeNew){
            [self.tableView beginUpdates];
            
            [self.arrayFolders addObject:folder];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrayFolders count]-1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
            MBLog(@"folder %@", self.arrayFolders);
            
            [self.tableView endUpdates];
        }
        
        MBLog(@"folder,,,");
        [self.navigationController popViewControllerAnimated:YES];
        
        if(mode == kModeNew){
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrayFolders count]-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self.tableView reloadData];
        }
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bible"
                                                        message:@"Duplicate Entry"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
}

@end
