//
//  SelectionController.m
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectionController.h"
#import "MBConstants.h"

@implementation SelectionController

@synthesize optionType = _optionType;

- (id)initWithStyle:(UITableViewStyle)style Options:(NSArray *)options
{
    self = [super initWithStyle:style];
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
        
    cell.textLabel.text = [dict valueForKey:@"display_value"];
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
