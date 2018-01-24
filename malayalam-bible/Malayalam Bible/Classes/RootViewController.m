//
//  RootViewController.m
//  Malayalam Bible
//
//  Created by jijo pulikkottil on 29/12/17.
//

#import "RootViewController.h"
#import "MalayalamBibleDetailViewController.h"
#import "MalayalamBibleAppDelegate.h"
#import "MalayalamBibleMasterViewController.h"
#import "MBConstants.h"
@interface RootViewController ()

@end

@implementation RootViewController
NSString *kRestoreLocationKey = @"RestoreLocation";    // preference key to obtain our restore location
- (void)viewDidLoad {
    
    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.detailViewController = [[MalayalamBibleDetailViewController alloc] init];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        
        appDelegate.navigationController = [[UINavigationController alloc] initWithRootViewController:appDelegate.detailViewController];
        //self.window.rootViewController = self.navigationController;
        [self.view addSubview:appDelegate.navigationController.view];
        appDelegate.navigationController.view.frame = [self.view bounds];
        [self addChildViewController:appDelegate.navigationController];
        [appDelegate.navigationController didMoveToParentViewController:self];
        //child.view.frame = view.bounds
        //addChildViewController(child)
        //child.didMove(toParentViewController: self)
        
    } else {
        
        
        //MalayalamBibleDetailViewController *detailViewController = [[MalayalamBibleDetailViewController alloc] initWithNibName:@"MalayalamBibleDetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:appDelegate.detailViewController];
        
        MalayalamBibleMasterViewController *masterViewController = [[MalayalamBibleMasterViewController alloc] init];
        masterViewController.detailViewController = appDelegate.detailViewController;
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        appDelegate.splitViewController = [[UISplitViewController alloc] init];
        appDelegate.splitViewController.delegate = appDelegate.detailViewController;
        appDelegate.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        //appDelegate.window.rootViewController = self.splitViewController;
        [self.view addSubview:appDelegate.splitViewController.view];
        appDelegate.splitViewController.view.frame = [self.view bounds];
        [self addChildViewController:appDelegate.splitViewController];
        [appDelegate.splitViewController didMoveToParentViewController:self];
        
    }
    
    // load the stored preference of the user's last location from a previous launch
    NSUserDefaults *def  =[NSUserDefaults standardUserDefaults];
    NSArray *ar1 = [[def objectForKey:kRestoreLocationKey] mutableCopy];
    
    MBLog(@"ar1 = %@", ar1);
    //ar1 = nil;//+roll
    
    if(ar1 != nil){
        appDelegate.savedLocation = [[NSMutableArray alloc] initWithCapacity:3];
        for (id dict in ar1) {
            
            
            
            if([dict isKindOfClass:[NSDictionary class]]){
                
                MBLog(@"c=%@", [[dict class] description]);
                [appDelegate.savedLocation addObject:[NSMutableDictionary dictionaryWithDictionary:dict]];
                
            }else{
                [appDelegate.savedLocation addObject:dict];
            }
            
        }
    }
    
    CGFloat fontSize = [def floatForKey:@"fontSize"];
    
    if(fontSize > 0){
        FONT_SIZE = fontSize;
    }
    
    
    
    if (appDelegate.savedLocation == nil || [appDelegate.savedLocation count] == 0)
    {
        // user has not launched this app nor navigated to a particular level yet, start at level 1, with no selection
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            
            appDelegate.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],    // book selection at 1st level
                                  [NSNumber numberWithInteger:1],    // .. 2nd level  the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id
                                  nil];
            
        }else{
            
            
            appDelegate.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],    // book selection at 1st level
                                  [NSNumber numberWithInteger:1],    // .. 2nd level , the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id
                                  nil];
            
        }
    }
    
    NSNumber *selection = [[appDelegate.savedLocation objectAtIndex:0] valueForKey:@"BookPathSection"];    // read the saved selection at level 1
    if (selection)
    {
        //(@"restore point %@", selection);
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            
            [appDelegate restoreLevelWithSelectionArray:appDelegate.savedLocation];
            
        }else{
            
            //+20131114
            [(MalayalamBibleMasterViewController*)[[appDelegate.splitViewController.viewControllers objectAtIndex:0] topViewController] restoreLevelWithSelectionArray:appDelegate.savedLocation];
        }
        
    }
    else
    {
        //(@"no restore point");
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            
            appDelegate.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],    // book selection at 1st level
                                  [NSNumber numberWithInteger:1],    // .. 2nd level , the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],
                                  nil];
            
            [(MalayalamBibleMasterViewController*)[[appDelegate.splitViewController.viewControllers objectAtIndex:0] topViewController] restoreLevelWithSelectionArray:appDelegate.savedLocation];
            
        }else{
            
            
            appDelegate.savedLocation = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],@"BookPathSection",[NSNumber numberWithInteger:0], @"BookPathRow", nil],    // book selection at 1st level
                                  [NSNumber numberWithInteger:1],    // .. 2nd level , the chapter idex
                                  [NSMutableDictionary dictionaryWithCapacity:1],// 3rd level - verse id
                                  nil];
            
            [appDelegate restoreLevelWithSelectionArray:appDelegate.savedLocation];
            
        }
        // no saved selection, so user was at level 1 the last time
    }
    
    
    // register our preference selection data to be archived
    //NSDictionary *savedLocationDict = [NSDictionary dictionaryWithObject:savedLocation forKey:kRestoreLocationKey];
    //[[NSUserDefaults standardUserDefaults] registerDefaults:savedLocationDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
