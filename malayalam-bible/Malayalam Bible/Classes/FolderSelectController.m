//
//  FolderSelectController.m
//  Malayalam Bible
//
//  Created by jijo on 10/18/12.
//
//

#import "FolderSelectController.h"
#import "FolderDetailController.h"
#import "BibleDao.h"
#import "MalayalamBibleAppDelegate.h"

@interface FolderSelectController ()

@property (nonatomic) id <MBFolderSelectDelegate> delegatee;

@end

@implementation FolderSelectController

@synthesize arrayFolders = _arrayFolders;
@synthesize arrayNewFolders = _arrayNewFolders;
@synthesize delegatee;



- (id)initWithStyle:(UITableViewStyle)style Delegate:(id)del
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        BibleDao *daoo = [[BibleDao alloc] init];
        self.arrayFolders = [daoo getAllFolders];
        self.delegatee = del;
    }
    return self;
}

- (void)viewDidLoad
{
    UIBarButtonItem *temporaryBarButtonItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
	
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem1;
    
    [super viewDidLoad];

    [self.tableView setAllowsSelectionDuringEditing:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    if(self.tableView.editing){
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
       
      
        return [self.arrayFolders count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                       
    }
    if(indexPath.section == 0){
        
        Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
        MBLog(@"fldr.folder_label = %@", fldr.folder_label);
        cell.textLabel.text = fldr.folder_label;
    }else{
        
        cell.textLabel.text = @"Add Folder";
    }
        
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
    
}*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.editing){
	if(indexPath.section == 0) {
        
        
        Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
        if([fldr.folder_label isEqualToString:@"Bookmarks"]){
            return UITableViewCellEditingStyleNone;
        }else{
            return UITableViewCellEditingStyleDelete;
        }
		
        
        
	} else {
		return UITableViewCellEditingStyleInsert;
	}
    }
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            
            
            [tableView beginUpdates];
            
            
            MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
             
             NSManagedObjectContext *context =  [appDelegate managedObjectContext];
             Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
             [context deleteObject:fldr];
             
             NSError *error;
             [context save:&error];
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.arrayFolders removeObjectAtIndex:indexPath.row];
            [tableView endUpdates];
            
            
        }
        else if (editingStyle == UITableViewCellEditingStyleInsert) {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeNew AndDelegate:self];
            [self.navigationController pushViewController:detailCtrlr animated:YES];
        }
    
       
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger difrence = fromIndexPath.row-toIndexPath.row;
    
    if(difrence == 1){
        Folders *fldr1 = [self.arrayFolders objectAtIndex:fromIndexPath.row];
        Folders *fldr2 = [self.arrayFolders objectAtIndex:toIndexPath.row];
        NSDate *temp = fldr1.createddate;
        fldr1.createddate = fldr2.createddate;
        fldr2.createddate = temp;
        
        [self.arrayFolders exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        
        MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
        NSError *error;
        [context save:&error];

        
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
            [temp dateByAddingTimeInterval:1*60];
        }
        MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
        NSError *error;
        [context save:&error];

    }
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        MBLog(@"here1");
        FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeNew AndDelegate:self];
        [self.navigationController pushViewController:detailCtrlr animated:YES];
    }else{
        
        if(self.editing){
             MBLog(@"here11");
            Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
            
            FolderDetailController *detailCtrlr = [[FolderDetailController alloc] initWithStyle:UITableViewStyleGrouped ViewMode:kModeEdit AndDelegate:self];
            detailCtrlr.folderD = fldr;
            [self.navigationController pushViewController:detailCtrlr animated:YES];
            
        }else{
             MBLog(@"here2");
            Folders *fldr = [self.arrayFolders objectAtIndex:indexPath.row];
            [self.delegatee selectedFolder:fldr];
            
        }
        
        

    }
    
}

#pragma mark @selector methods
/*
- (void) cancelClicked:(UIBarButtonItem *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    [context rollback];
}*/
-(void) editButtonClicked:(id)sender{
    
    [self setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
     
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
        
        
        
        if(mode == kModeNew){
            
            
            
            [folder setCreateddate:[NSDate date]];
            
            
        }else{
            //update to coredata
            
        }
        
        MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
        NSError *error;
        [context save:&error];
        
         if(mode == kModeNew){
             [self.tableView beginUpdates];
             
             [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.arrayFolders count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
             [self.arrayFolders addObject:folder];
             [self.tableView endUpdates];
         }
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
