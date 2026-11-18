//
//  ColorViewController.m
//  Malayalam Bible
//
//  Created by jijo on 4/22/13.
//
//

#import "ColorViewController.h"
#import "MBConstants.h"

@interface ColorViewController ()


@property (nonatomic) NSInteger selectedColor;
@property (nonatomic) id <MBColourSelectorDelegate> delegatee;

@end

@implementation ColorViewController

@synthesize selectedColor;
@synthesize delegatee;



+ (NSArray *)arrayColors{
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if(isdark){
        return [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor defaultBlueColor], [UIColor cyanColor],[UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    }else{
        return [NSArray arrayWithObjects:[UIColor redColor], [UIColor colorWithRed:0 green:153/255. blue:0 alpha:1], [UIColor defaultBlueColor], [UIColor colorWithRed:0 green:204/255. blue:204/255. alpha:1],[UIColor colorWithRed:204/255. green:204/255. blue:0 alpha:1],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor], nil];
    }
    
}
- (id)initWithStyle:(UITableViewStyle)style SelectedColor:(NSInteger)selColor Delegate:(id)delgte
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.selectedColor = selColor;
        self.delegatee = delgte;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //+20261118 Night mode: follow the app's own Night mode (kNightTime) rather than the iOS appearance, the
    // same convention as Settings, Add Bookmark, Notes and Bookmarks. Settings saves kNightTime before pushing
    // this screen, so the value here is current.
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    self.overrideUserInterfaceStyle = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    // Navigation bar matching the reading screen's own bar (opaque black in Night, the default bar in Light),
    // so it is right even when Night mode was just switched in Settings. Set on the shared navigation bar,
    // as the reading screen does; screens with their own navigationItem appearance (Settings) keep theirs.
    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    if (isdark) {
        [barAppearance configureWithOpaqueBackground];
        barAppearance.backgroundColor = [UIColor blackColor];
        barAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        barAppearance.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    } else {
        [barAppearance configureWithDefaultBackground];
    }
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.standardAppearance = barAppearance;
    navigationBar.compactAppearance = barAppearance;
    navigationBar.scrollEdgeAppearance = barAppearance;
    navigationBar.compactScrollEdgeAppearance = barAppearance;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [ColorViewController.arrayColors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    
    
    
    if(self.selectedColor == indexPath.row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
   cell.backgroundColor = [ColorViewController.arrayColors objectAtIndex:indexPath.row];
    //+20261118 Readability: the checkmark took the theme colour, so on the selected row (which is that same
    // colour) it was invisible. Draw it white, or black on the light swatches (e.g. yellow, cyan, green).
    UIColor *swatch = [ColorViewController.arrayColors objectAtIndex:indexPath.row];
    CGFloat r = 0, g = 0, b = 0, a = 0;
    BOOL isLight = [swatch getRed:&r green:&g blue:&b alpha:&a] && (0.299 * r + 0.587 * g + 0.114 * b) > 0.6;
    cell.tintColor = isLight ? [UIColor blackColor] : [UIColor whiteColor];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegatee  colorStringDidChange:[NSNumber numberWithInteger:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
