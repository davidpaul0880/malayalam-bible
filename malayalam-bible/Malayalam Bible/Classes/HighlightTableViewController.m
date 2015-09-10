//
//  HighlightTableViewController.m
//  Malayalam Bible
//
//  Created by jijo on 4/9/15.
//
//

#import "HighlightTableViewController.h"
#import "BibleDao.h"
#import "MBConstants.h"
#import "MalayalamBibleAppDelegate.h"
#import "MBUtils.h"
#import "ColordVerses.h"
#import "UIDeviceHardware.h"

@interface HighlightTableViewController ()

@property(nonatomic) NSArray *arrayElements;
@property(nonatomic) NSString *colorCode;
@property(nonatomic) NSMutableDictionary *bookIdName;

- (UIBarButtonItem *)getButtonWithImage:(NSString *)img1 Selector:(SEL)selector;

@end

@implementation HighlightTableViewController

@synthesize detailViewController = _detailViewController;

- (void) executeQuery{
    
    NSFetchRequest *fetchRequest = self.fetchedResultsController.fetchRequest;
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(colorcode = %@ )", self.colorCode];
    [fetchRequest setPredicate:pred];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        MBLogAll(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}
- (void)color1Clicked:(UIBarButtonItem *)sender{
    
    self.colorCode = kStoreColor1;
    [self executeQuery];
}
- (void)color2Clicked:(UIBarButtonItem *)sender{
    
    self.colorCode = kStoreColor2;
    [self executeQuery];
}
- (void)color3Clicked:(UIBarButtonItem *)sender{
    
    self.colorCode = kStoreColor3;
    [self executeQuery];
}
- (void)color4Clicked:(UIBarButtonItem *)sender{
    
    self.colorCode = kStoreColor4;
    [self executeQuery];
}
- (void)color5Clicked:(UIBarButtonItem *)sender{
    
    self.colorCode = kStoreColor5;
    [self executeQuery];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = YES;
}
- (UIBarButtonItem *)getButtonWithImage:(NSString *)img1 Selector:(SEL)selector{
    
    //UIImage *buttonImage = [UIImage imageNamed:img1];
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setImage:buttonImage forState:UIControlStateNormal];
    
    NSString *color = [MBUtils getHighlightColorof:img1];//
    [button setBackgroundColor:[UIColor colorWithHexString:color]];

    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 32, 32);
    //create a UIBarButtonItem with the button as a custom view
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    self.bookIdName = [[NSMutableDictionary alloc] init];
    
    //BibleDao *b = [[BibleDao alloc] init];
    //[b getAllColordVersesOfColor:kStoreColor1];
    
    self.navigationController.toolbarHidden = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *item1 = [self getButtonWithImage:kStoreColor1 Selector:@selector(color1Clicked:)];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [self getButtonWithImage:kStoreColor2 Selector:@selector(color2Clicked:)];
    
    //UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item3 = [self getButtonWithImage:kStoreColor3 Selector:@selector(color3Clicked:)];
    UIBarButtonItem *item4 = [self getButtonWithImage:kStoreColor4 Selector:@selector(color4Clicked:)];
    UIBarButtonItem *item5 = [self getButtonWithImage:kStoreColor5 Selector:@selector(color5Clicked:)];

    
    self.toolbarItems = [NSArray arrayWithObjects:item1,flex1,item2,flex1, item3, flex1, item4, flex1, item5, nil];
    
    
    BOOL isos7 = NO;
    if([UIDeviceHardware isOS7Device]){
        isos7 = YES;
        self.navigationController.navigationBar.tintColor = [UIColor defaultWindowColor];
    }

    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *changedcolor;
    if (isdark ){
        
        if (!isos7) {
            [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
        }
        
        changedcolor = [UIColor blackColor];
        
        
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        
        
        
    }else{
        if (!isos7) {
            [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
        }

        changedcolor = [UIColor whiteColor];
    }
    self.view.backgroundColor = changedcolor;
    
    
    //BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    CGRect r = self.navigationController.navigationBar.frame;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
    
    lblTitle.text = NSLocalizedString(@"highlighted.verses", @"");
    
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    if (isdark || !isos7) {
        lblTitle.textColor = [UIColor whiteColor];
    }else{
        lblTitle.textColor = [UIColor blackColor];
    }
    self.navigationItem.titleView = lblTitle;
    //self.navigationItem.title = NSLocalizedString(@"highlighted.verses", @"");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo numberOfObjects];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ColordVerses *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *verseidNum = object.verseid;
    
    NSMutableDictionary *dictVerseid = [NSMutableDictionary dictionaryWithObject:verseidNum forKey:@"verse_id"];
    
    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:dictVerseid];
    
    
    BibleDao *daoo = [[BibleDao alloc] init];
    Book *bookdetails = [daoo getBookUsingId:[object.bookid integerValue]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        MBLog(@"jj verseidNum = %@,bookdetails.bookId = %i, bm.chapter = %@ ", verseidNum, bookdetails.bookId, object.chapter);
        self.detailViewController.selectedBook = bookdetails;
        self.detailViewController.chapterId = [object.chapter integerValue];
        [self.detailViewController configureView];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else{
        
        
        MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Book *selectBook = bookdetails;
        
        /**set select book*** +20121006 **/
        NSUInteger bookindex= selectBook.bookId;
        NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:0];//+20140929
        
        [dict setObject:[NSNumber numberWithInteger:bookindex-1] forKey:bmBookSection];//+20121017
        
        
        
        [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:object.chapter];
        
        
        NSMutableDictionary *dictthird = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSNumber *verseid =  [NSNumber numberWithInteger:[object.verseid integerValue]];
        [dictthird setValue:verseid forKey:@"verse_id"];
        
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [appDelegate openVerseForiPadSavedLocation];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ident = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
        
        cell.textLabel.font = [UIFont fontWithName:kFontName size:FONT_SIZE];
        cell.detailTextLabel.font = [UIFont fontWithName:kFontName size:(FONT_SIZE * 14 / 18)];
       
        
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if (isdark ){
            cell.backgroundColor = [UIColor blackColor];
            
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            MBLogAll(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ColordVerses *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
    NSString *bkName = [self.bookIdName objectForKey:object.bookid];
    if(bkName == nil){
        
        BibleDao *b = [[BibleDao alloc] init];
        Book *book = [b getBookUsingId:object.bookid.integerValue];
        bkName = book.shortName;
    }
    NSString *str = [NSString stringWithFormat:@"%@.png", self.colorCode];

    cell.imageView.image = [UIImage imageNamed:str];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@:%@", bkName, object.chapter, object.verseid];
    cell.detailTextLabel.text = object.version;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ColordVerses" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc]
                               initWithKey:@"bookid" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc]
                               initWithKey:@"chapter" ascending:YES];
    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc]
                               initWithKey:@"verseid" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, sort2, sort3, nil]];

    if (self.colorCode == nil){
    
        self.colorCode = kStoreColor1;
    }
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(colorcode = %@ )", self.colorCode];
    [fetchRequest setPredicate:pred];
    
    
    
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        MBLogAll(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
