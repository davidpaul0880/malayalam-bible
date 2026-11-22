//
//  SelectionController.m
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectionController.h"
#import "MBConstants.h"

//+20261123 Same grouped-card metrics as the parent Settings screen (SettingsViewController).
static const CGFloat kSelectionRowVerticalMargin = 15.0;   // body text + margins = 52 pt rows, as in Settings
static const CGFloat kSelectionHeaderSpacing = 12.0;       // Settings' spacing above a section without a header
static const CGFloat kSelectionFooterSpacing = 8.0;        // Settings' section footer spacing

@implementation SelectionController

@synthesize optionType = _optionType;

- (id)initWithStyle:(UITableViewStyle)style Options:(NSArray *)options
{
    //+20261123 Rounded inset card, as on Settings (Settings still passes UITableViewStyleGrouped).
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) {
        // Custom initialization
        arrayOptions = options;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //+20261118 Night mode: follow the app's own Night mode (kNightTime) rather than the iOS appearance, the
    // same convention as Settings, Add Bookmark, Notes and Bookmarks. Settings saves kNightTime before pushing
    // this screen, so the value here is current.
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    self.overrideUserInterfaceStyle = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    //+20261123 Grouped surfaces exactly as on Settings: #F2F2F7 page with white card in Light, black page with
    // #1C1C1E card in Night (system grouped colours, resolved through the override above), system separator,
    // readable width on iPad.
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 52.0;

    // Navigation bar: the same opaque bar as Settings (page colour; a hairline only once content scrolls under
    // it). Set on the shared navigation bar, as before; Settings keeps its own navigationItem appearance and the
    // reading screen re-applies its bar when it reappears.
    UITraitCollection *traits = [UITraitCollection traitCollectionWithUserInterfaceStyle:(isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight)];
    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    [barAppearance configureWithOpaqueBackground];
    barAppearance.backgroundColor = [[UIColor systemGroupedBackgroundColor] resolvedColorWithTraitCollection:traits];
    barAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [[UIColor labelColor] resolvedColorWithTraitCollection:traits]};
    barAppearance.shadowColor = isdark ? [UIColor colorWithWhite:1.0 alpha:0.25] : [[UIColor separatorColor] resolvedColorWithTraitCollection:traits];
    UINavigationBarAppearance *scrollEdgeAppearance = [barAppearance copy];
    scrollEdgeAppearance.shadowColor = [UIColor clearColor];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.standardAppearance = barAppearance;
    navigationBar.compactAppearance = barAppearance;
    navigationBar.scrollEdgeAppearance = scrollEdgeAppearance;
    navigationBar.compactScrollEdgeAppearance = scrollEdgeAppearance;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    for (NSUInteger i=0; i<[arrayOptions count] ; i++) {
        
        NSMutableDictionary *dict = [arrayOptions objectAtIndex:i];
        
        if([[dict valueForKey:@"isSelected"] boolValue]){
            
            NSMutableDictionary *dictPref = (NSMutableDictionary *)[[[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference] mutableCopy];
            
            if(self.optionType == 1){
                
                [dictPref setValue:[dict valueForKey:@"languageid"] forKey:@"primaryLanguage"];
                
                //to reset the secondary Lang if we set primary lang as same as the secondary                
                if([[dict valueForKey:@"languageid"] isEqualToString:[dictPref valueForKey:@"secondaryLanguage"]]){
                    
                    [dictPref setValue:kLangNone forKey:@"secondaryLanguage"];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:dictPref forKey:@"Preferences"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //+20131210[[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:                 nil];


            }else if(self.optionType == 2){
                
                [dictPref setValue:[dict valueForKey:@"languageid"] forKey:@"secondaryLanguage"];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictPref forKey:@"Preferences"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //+20131210[[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:                 nil];
            }
            
            
            
            break;
        }
            
                                
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [arrayOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [arrayOptions objectAtIndex:indexPath.row];
        
    //+20261123 Row text styled like Settings rows: body font, Dynamic Type, wraps instead of clipping, 52 pt rows.
    // The checkmark and selection logic below are unchanged.
    UIListContentConfiguration *content = [UIListContentConfiguration cellConfiguration];
    content.text = [dict valueForKey:@"display_value"];
    content.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    content.textProperties.adjustsFontForContentSizeCategory = YES;
    content.textProperties.color = [UIColor labelColor];
    content.textProperties.numberOfLines = 0;
    NSDirectionalEdgeInsets margins = content.directionalLayoutMargins;
    margins.top = kSelectionRowVerticalMargin;
    margins.bottom = kSelectionRowVerticalMargin;
    content.directionalLayoutMargins = margins;
    cell.contentConfiguration = content;
    if([[dict valueForKey:@"isSelected"] boolValue]){
        
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

//+20261123 Section spacing as on Settings.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSelectionHeaderSpacing;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kSelectionFooterSpacing;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSUInteger i=0; i<[arrayOptions count] ; i++) {
        
        NSMutableDictionary *dict = [arrayOptions objectAtIndex:i];
        if(indexPath.row == i){
            [dict setValue:@"YES" forKey:@"isSelected"];
            
            
        }else{
            [dict setValue:@"NO" forKey:@"isSelected"];
        }
        
    }
    
            
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
