//
//  MalayalamBibleAppDelegate.m
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MalayalamBibleAppDelegate.h"

#import "MalayalamBibleMasterViewController.h"

#import "BibleDao.h"
#import "MBConstants.h"
#import "UIDeviceHardware.h"
#import "MBUtils.h"
#import "ColorViewController.h"


@interface MalayalamBibleAppDelegate ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//- (NSURL *)applicationDocumentsDirectory;
//- (void)saveContext;

@end


@implementation MalayalamBibleAppDelegate

@synthesize detailViewController = _detailViewController;
@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize savedLocation;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

NSString *kRestoreLocationKey = @"RestoreLocation";	// preference key to obtain our restore location

//+20140929
-(void)showMasterController{
    
    
        
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    
    
    
}

-(void)hideMasterController{
    
    
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    
}


- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray{
    
    
    NSDictionary *dict = [selectionArray objectAtIndex:0];
    
    NSUInteger section = [[dict objectForKey:bmBookSection] integerValue];
   
   
    BibleDao *bdao = [[BibleDao alloc] init];
    Book *selBook = [bdao fetchBookWithSection:section Row:0];
    
    
    NSInteger chapterid = [[selectionArray objectAtIndex:1] integerValue];
    
   
	if (chapterid <= 0)
	{
        chapterid = 1;
    }
        self.detailViewController.isActionClicked = NO;
        
        self.detailViewController.selectedBook = selBook;
        self.detailViewController.chapterId = chapterid;
        [self.detailViewController configureView];

    
    
}

- (void)openVerseForiPadSavedLocation{
    
    [(MalayalamBibleMasterViewController*)[[self.splitViewController.viewControllers objectAtIndex:0] topViewController] restoreLevelWithSelectionArray:savedLocation];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   
    
    self.window = [[RootWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.detailViewController = [[MalayalamBibleDetailViewController alloc] init];
    
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
        self.window.rootViewController = self.navigationController;
        
    } else {
        
                
        //MalayalamBibleDetailViewController *detailViewController = [[MalayalamBibleDetailViewController alloc] initWithNibName:@"MalayalamBibleDetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:self.detailViewController];
        
        MalayalamBibleMasterViewController *masterViewController = [[MalayalamBibleMasterViewController alloc] init];
        masterViewController.detailViewController = self.detailViewController;
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = self.detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
        
        
    }
    
    
    
    // load the stored preference of the user's last location from a previous launch
    NSUserDefaults *def  =[NSUserDefaults standardUserDefaults];
	NSArray *ar1 = [[def objectForKey:kRestoreLocationKey] mutableCopy];
    
    MBLog(@"ar1 = %@", ar1);
    //ar1 = nil;//+roll
    
    if(ar1 != nil){
        self.savedLocation = [[NSMutableArray alloc] initWithCapacity:3];
        for (id dict in ar1) {
            
            
            
            if([dict isKindOfClass:[NSDictionary class]]){
                
                MBLog(@"c=%@", [[dict class] description]);
                [self.savedLocation addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
                
            }else{
                [self.savedLocation addObject:dict];
            }
            
        }
    }
    
    CGFloat fontSize = [def floatForKey:@"fontSize"];
    
    if(fontSize > 0){
        FONT_SIZE = fontSize;
    }
   
  
    
	if (savedLocation == nil || [savedLocation count] == 0)
	{
		// user has not launched this app nor navigated to a particular level yet, start at level 1, with no selection
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
      
            self.savedLocation = [NSMutableArray arrayWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],	// book selection at 1st level
                             [NSNumber numberWithInteger:1],	// .. 2nd level  the chapter idex
                             [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id
                             nil];
            
        }else{
            
            
            self.savedLocation = [NSMutableArray arrayWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],	// book selection at 1st level
                             [NSNumber numberWithInteger:1],	// .. 2nd level , the chapter idex
                             [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id	
                             nil];
            
        }
    }
    
    [self.window makeKeyAndVisible];
	
    NSNumber *selection = [[savedLocation objectAtIndex:0] valueForKey:@"BookPathSection"];	// read the saved selection at level 1
    if (selection)
    {
        //(@"restore point %@", selection);
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
           
            [self restoreLevelWithSelectionArray:savedLocation];
            
        }else{
           
            //+20131114
            [(MalayalamBibleMasterViewController*)[[self.splitViewController.viewControllers objectAtIndex:0] topViewController] restoreLevelWithSelectionArray:savedLocation];
        }
        
    }
    else
    {    
        //(@"no restore point");
       
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            
            self.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],	// book selection at 1st level
                                  [NSNumber numberWithInteger:1],	// .. 2nd level , the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],	
                                  nil];
            
            [(MalayalamBibleMasterViewController*)[[self.splitViewController.viewControllers objectAtIndex:0] topViewController] restoreLevelWithSelectionArray:self.savedLocation];
           
        }else{
            
            
            self.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],	// book selection at 1st level
                                  [NSNumber numberWithInteger:1],	// .. 2nd level , the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id	
                                  nil];
            
             [self restoreLevelWithSelectionArray:savedLocation];
            /*MalayalamBibleMasterViewController *masterViewController = [[MalayalamBibleMasterViewController alloc] init];
            UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:masterViewController];
            [self.window.rootViewController presentModalViewController:temp animated:YES];*/
        }
        // no saved selection, so user was at level 1 the last time
    }
	
    
    // register our preference selection data to be archived
	//NSDictionary *savedLocationDict = [NSDictionary dictionaryWithObject:savedLocation forKey:kRestoreLocationKey];
	//[[NSUserDefaults standardUserDefaults] registerDefaults:savedLocationDict];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    
    /*NSString *pathname = [[NSBundle mainBundle] pathForResource:@"malayalam-bible" ofType:@"db" inDirectory:@"/"];
    if(pathname != nil){
        
        NSLog(@"pathname = %@", pathname);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:pathname]){
            
            NSLog(@"file exist = %@", pathname);
             NSError *error;
            if([fileManager removeItemAtPath:pathname error:&error]){
                NSLog(@"removed old db");
            }else{
                 NSLog(@"err %@",[error localizedDescription]);
            }
        }
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"malayalam-english-bible.db"];

    if(dbPath != nil){
        
        NSLog(@"dbPath = %@", dbPath);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:dbPath]){
            
            NSLog(@"file exist = %@", dbPath);
            NSError *error;
            if([fileManager removeItemAtPath:dbPath error:&error]){
                NSLog(@"removed old db");
            }else{
                NSLog(@"err %@",[error localizedDescription]);
            }
        }
    }*/
    
   
    NSInteger appColorr = [def integerForKey:kStoreThemeColor];
    MBLog(@"appcolor = %li", (long)appColorr);
    if([UIDeviceHardware isOS7Device]){
        
        if(appColorr > 0){
        
            
              
          self.window.tintColor =[[ColorViewController arrayColors] objectAtIndex:appColorr-1];
            
            
        }
        
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if(isdark){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        }
        ////UIStatusBarStyleBlackOpaque
        
        
        CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
        statusBarHeight = MIN(statusBarSize.width, statusBarSize.height);

    }else{
        statusBarHeight = 0;
    }
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    MBLog(@"enter bg ");
    
	[[NSUserDefaults standardUserDefaults] setObject:savedLocation forKey:kRestoreLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self saveContext];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"userdata" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"userdata.sqlite"];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    /*NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    */

    
    NSError *error = nil;
     _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        MBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            MBLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Status bar touch tracking
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTappedNotification
                                                        object:nil];
}

@end
