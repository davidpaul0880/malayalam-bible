//
//  SettingsViewController.m
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
//#import "LanguageViewController.h"
#import "Information.h"
#import "WebViewController.h"
#import "MBConstants.h"
#import "SelectionController.h"
#import "FontSizeCell.h"
#import "UIDeviceHardware.h"
#import "MBUtils.h"
#import "MalayalamBibleAppDelegate.h"

#define FontSizeRow 2

@interface SettingsViewController ()


@property(assign) BOOL isNightMode;
@property(assign) BOOL isScrollEnabled;
@property(nonatomic, assign) CGFloat currentSpeed;

@property(nonatomic) UISwitch *switchScroll;
@property(nonatomic) UISwitch *switchNightMode;

@property(nonatomic) UISwitch *switchCustomKB;
@property(nonatomic) BOOL isThemeChanged;
@end



@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
        
        
        if(dictPref !=nil ){
            
            selectedPrimary = [dictPref valueForKey:@"primaryLanguage"];
            selectedSecondary = [dictPref valueForKey:@"secondaryLanguage"];
            
        }
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
    
    
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    CGRect r = self.navigationController.navigationBar.frame;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
    lblTitle.text = @"Settings";
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    if (isdark || ![UIDeviceHardware isOS7Device]) {
        lblTitle.textColor = [UIColor whiteColor];
    }else{
        lblTitle.textColor = [UIColor blackColor];
    }
    self.navigationItem.titleView = lblTitle;
    
    
    [super viewDidLoad];

    
    //NSDictionary *dictf = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Languages", @"") ,@"title",NSLocalizedString(@"SelectLanguages", @""), @"subTitle", nil];
    
      
    //arrayPrefs = [NSArray arrayWithObjects:dictf, nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //+20150217

    if (isdark ){
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
        //self.tableView.sectionIndexColor = [UIColor whiteColor];
        //self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) test {
    
    
    NSMutableDictionary *dictMal = [arraySettings objectAtIndex:self.switchCustomKB.tag];
    
    //int x = 1;//+roll
    if(self.switchCustomKB.isOn){
        
        NSDictionary *dictMalayalamTypeChild1 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Use Custom Keyboard", @"") ,@"label", nil];
        
        
        NSDictionary *dictMalayalamTypeChild2 = nil;
        NSURL *customURLv = [NSURL URLWithString:@"VaramozhiKB://"];
        
        /*if([[UIApplication sharedApplication] canOpenURL:customURLv]){
            
            dictMalayalamTypeChild2  = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Varamozhi - Installed", @"") ,@"label",customURLv,@"customURL", nil];
            
        }else{*/
            dictMalayalamTypeChild2  = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"'Varamozhi' for manglish keyboard", @"") ,@"label", nil]; //Install
        //}
        
        NSDictionary *dictMalayalamTypeChild3 = nil;
        NSURL *customURLe = [NSURL URLWithString:@"EasyMalayalamKB://"];
        
        /*if([[UIApplication sharedApplication] canOpenURL:customURLe]){
            
            dictMalayalamTypeChild3 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"'Easy Malayalam' - Installed", @"") ,@"label",customURLe,@"customURL", nil];
            
        }else{
          */
            dictMalayalamTypeChild3 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"'Easy Malayalam' for in-script keyboard", @"") ,@"label", nil];
            
            
        //}
        
        
        
        [dictMal setValue:[NSArray arrayWithObjects:dictMalayalamTypeChild1,dictMalayalamTypeChild2,dictMalayalamTypeChild3, nil] forKey:@"data"];
        
    }else{
        NSDictionary *dictMalayalamTypeChild1 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Use Custom Keyboard", @"") ,@"label", nil];
        NSDictionary *dictMalayalamTypeChild2 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"SearchHelp", @"") ,@"label",NSLocalizedString(@"MozhiScheme", @""), @"value", nil];
        
        [dictMal setValue:[NSArray arrayWithObjects:dictMalayalamTypeChild1,dictMalayalamTypeChild2, nil] forKey:@"data"];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        

        [self.tableView reloadData];// Sections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    });

    
}
- (void) scrollchange{
    
    
    
    NSMutableDictionary *dictScroll = [arraySettings objectAtIndex:self.switchScroll.tag];
    
    if(self.switchScroll.isOn){
        
        NSDictionary *dictAutoScrollSwitch = [NSDictionary dictionaryWithObjectsAndKeys:@"Auto scroll" ,@"label", nil];
        NSString *str = [NSString stringWithFormat:@"Auto scroll speed %.2f %%", [[NSUserDefaults standardUserDefaults] floatForKey:kScrollSpeed]];
        NSMutableDictionary *dictAutoScrollSpeed = [NSMutableDictionary dictionaryWithObjectsAndKeys:str ,@"label", nil];
        
        
        [dictScroll setValue:[NSArray arrayWithObjects:dictAutoScrollSwitch,dictAutoScrollSpeed, nil] forKey:@"data"];
        
    }else{
        
        NSDictionary *dictAutoScrollSwitch = [NSDictionary dictionaryWithObjectsAndKeys:@"Auto scroll" ,@"label", nil];
        
        
        [dictScroll setValue:[NSArray arrayWithObjects:dictAutoScrollSwitch, nil] forKey:@"data"];
        
    }
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        
        [self.tableView reloadData];// Sections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    });

}
- (void) switchScrollDidChange:(UISwitch *)sender{
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollchange) object:nil];
    [self performSelectorInBackground:@selector(scrollchange) withObject:nil];

    
}
- (void)switchDidChange:(UISwitch *)sender{
 
    
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(test) object:nil];
    [self performSelectorInBackground:@selector(test) withObject:nil];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isNightMode = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    self.isScrollEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kScrollEnable];
    self.currentSpeed = [[NSUserDefaults standardUserDefaults] floatForKey:kScrollSpeed];
    if(self.currentSpeed < 1.0){
        self.currentSpeed = 10;
        [[NSUserDefaults standardUserDefaults] setFloat:10 forKey:kScrollSpeed];
    }
    self.switchNightMode = [[UISwitch alloc] init];
    [self.switchNightMode setOn:self.isNightMode];
    self.switchScroll = [[UISwitch alloc] init];
    [self.switchScroll setOn:self.isScrollEnabled];
    
    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
    
    if(dictPref == nil){
        
        
        dictPref = [[NSMutableDictionary alloc] init];
        [dictPref setValue:kLangPrimary forKey:@"primaryLanguage"];
        [dictPref setValue:kLangNone forKey:@"secondaryLanguage"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:dictPref forKey:kStorePreference];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSString *selectedPriLan = NSLocalizedString([dictPref valueForKey:@"primaryLanguage"], @"");;
    NSString *selectedSecLan = NSLocalizedString([dictPref valueForKey:@"secondaryLanguage"], @"");
    
    
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Primary", @"") ,@"label",selectedPriLan, @"value",[dictPref valueForKey:@"primaryLanguage"], @"languageid", nil];
    
    
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Secondary", @"") ,@"label",selectedSecLan, @"value",[dictPref valueForKey:@"secondaryLanguage"], @"languageid", nil];
    
    arrayLangs = [NSArray arrayWithObjects:dict1,dict2, nil];
    
    
    NSDictionary *sdict0 = [NSDictionary dictionaryWithObjectsAndKeys:@"Languages" ,@"header",@"0", @"sectionindex",arrayLangs, @"data", nil];
    
    
    /*
    if([selectedSecLan isEqualToString:NSLocalizedString(kLangNone, @"")]){
        
        
    }*/
    
    

    NSMutableDictionary *dictMalayalamType = nil;
    if([UIDeviceHardware isOS8Device]){
        
        self.switchCustomKB = [[UISwitch alloc] init];
        [self.switchCustomKB addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        
        bool isCustomkb = [[NSUserDefaults standardUserDefaults] boolForKey:kCustomKB];
        [self.switchCustomKB setOn:isCustomkb];
        self.switchCustomKB.tag = 1;
        
       
        
        NSDictionary *dictMalayalamTypeChild1 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Use Custom Keyboard", @"") ,@"label", nil];
        //NSDictionary *dictMalayalamTypeChild2 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"SearchHelp", @"") ,@"label",NSLocalizedString(@"MozhiScheme", @""), @"value", nil];

        
         dictMalayalamType = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Malayalam Typing for Search" ,@"header",[NSArray arrayWithObjects:dictMalayalamTypeChild1, nil],  @"data",@"6", @"sectionindex", nil];

    }else{
     
        NSDictionary *dictMalayalamTypeChild1 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"SearchHelp", @"") ,@"label",NSLocalizedString(@"MozhiScheme", @""), @"value", nil];
        
        dictMalayalamType = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Malayalam Typing for Search" ,@"header",@"1", @"sectionindex",[NSArray arrayWithObjects:dictMalayalamTypeChild1, nil], @"data", nil];
    }
    
    
    
    
    
    NSDictionary *sdict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Text Size" ,@"header",@"2", @"sectionindex", nil];
    
    
    
    NSDictionary *dict220 = [NSDictionary dictionaryWithObjectsAndKeys:@"Night mode" ,@"label", nil];
    NSDictionary *dict22 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:dict220, nil], @"data", @"5", @"sectionindex", nil];
    
    
    
    
    
    
    
    NSMutableDictionary *dictAutoScroll = nil;
    
    [self.switchScroll addTarget:self action:@selector(switchScrollDidChange:) forControlEvents:UIControlEventValueChanged];
    self.switchScroll.tag = 4;
    if(self.isScrollEnabled){
        
        NSDictionary *dictAutoScrollSwitch = [NSDictionary dictionaryWithObjectsAndKeys:@"Auto scroll" ,@"label", nil];
        NSString *str = [NSString stringWithFormat:@"Auto scroll speed %.2f %%", [[NSUserDefaults standardUserDefaults] floatForKey:kScrollSpeed]];
        NSMutableDictionary *dictAutoScrollSpeed = [NSMutableDictionary dictionaryWithObjectsAndKeys:str ,@"label", nil];
        
       dictAutoScroll = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"" ,@"header",@"4", @"sectionindex",[NSArray arrayWithObjects:dictAutoScrollSwitch,dictAutoScrollSpeed, nil], @"data", nil];
    }else{
        
        NSDictionary *dictAutoScrollSwitch = [NSDictionary dictionaryWithObjectsAndKeys:@"Auto scroll" ,@"label", nil];
       
        dictAutoScroll = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"" ,@"header",@"4", @"sectionindex",[NSArray arrayWithObjects:dictAutoScrollSwitch, nil], @"data", nil];
    }
    
    
    NSDictionary *dictthemee = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Color", @"") ,@"label",@"", @"value", nil];
    
    NSDictionary *dictTheme = [NSDictionary dictionaryWithObjectsAndKeys:@"Application Theme" ,@"header",@"7", @"sectionindex", [NSArray arrayWithObjects:dictthemee, nil], @"data",nil];
    
    
    
    NSDictionary *dict51 = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"AppInfo", @"") ,@"label",@"", @"value", nil];
    
    NSDictionary *dictInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Info" ,@"header",@"3", @"sectionindex", [NSArray arrayWithObjects:dict51, nil], @"data",nil];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def valueForKey:@"easteregg"]){
        
    }
    
    
    arraySettings = [[NSMutableArray alloc] init];
    
    if(sdict0){
        [arraySettings addObject:sdict0];
    }
    if(dictMalayalamType){
        [arraySettings addObject:dictMalayalamType];
    }
    if(sdict2){
        [arraySettings addObject:sdict2];
    }
    if(dict22){
        [arraySettings addObject:dict22];
    }
    if(dictAutoScroll){
        [arraySettings addObject:dictAutoScroll];
    }
    if(dictTheme){
        [arraySettings addObject:dictTheme];
    }
    if(dictInfo){
        [arraySettings addObject:dictInfo];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([UIDeviceHardware isOS8Device]){
       [self performSelectorInBackground:@selector(test) withObject:nil];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    if([self.switchScroll isOn] && !self.isScrollEnabled){
        
        
        [[NSUserDefaults standardUserDefaults] setBool:[self.switchScroll isOn] forKey:kScrollEnable];
        
        
    }else if(![self.switchScroll isOn] && self.isScrollEnabled){
        
        
        [[NSUserDefaults standardUserDefaults] setBool:[self.switchScroll isOn] forKey:kScrollEnable];
        
    }
    

    BOOL searchChanged = NO;
    if ([UIDeviceHardware isOS8Device]) {
    
        BOOL temp = [[NSUserDefaults standardUserDefaults] boolForKey:kCustomKB];
        if (temp != [self.switchCustomKB isOn]) {
            searchChanged = YES;
        }
        [[NSUserDefaults standardUserDefaults] setBool:[self.switchCustomKB isOn] forKey:kCustomKB];
    }
    
    
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"];
    
   
    if(fontSize != FONT_SIZE){
    
        [[NSUserDefaults standardUserDefaults] setFloat:FONT_SIZE forKey:@"fontSize"];
        
    }
    
    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
    
    BOOL isLangChanged = NO;
    
    if(dictPref != nil ){
        
       NSString *changedPrimary = [dictPref valueForKey:@"primaryLanguage"];
       NSString *changedSecondary = [dictPref valueForKey:@"secondaryLanguage"];
        
       
       if( ![changedPrimary isEqualToString:selectedPrimary] || ![changedSecondary isEqualToString:selectedSecondary]){
           
            isLangChanged = YES;
       }
        
    }
    
    BOOL isModeChanged = NO;
    //self.isNightMode = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if([self.switchNightMode isOn] && !self.isNightMode){
        
        isModeChanged = YES;
        [[NSUserDefaults standardUserDefaults] setBool:[self.switchNightMode isOn] forKey:kNightTime];
        
        
    }else if(![self.switchNightMode isOn] && self.isNightMode){
        
        isModeChanged = YES;
        [[NSUserDefaults standardUserDefaults] setBool:[self.switchNightMode isOn] forKey:kNightTime];

    }
    /*if(isModeChanged){
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:kStoreColor1];
        [def removeObjectForKey:kStoreColor2];
        [def removeObjectForKey:kStoreColor3];
        [def removeObjectForKey:kStoreColor4];
        [def removeObjectForKey:kStoreColor5];
        
        
    }*/
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(self.isThemeChanged){
        isModeChanged = YES;
        
        //+20150823
        if([UIDeviceHardware isOS7Device]){
            self.navigationItem.backBarButtonItem.tintColor = [UIColor defaultWindowColor];
        }
        
    }
    
    if(fontSize != FONT_SIZE || isLangChanged || isModeChanged || searchChanged){
        

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:(fontSize != FONT_SIZE) ? @"YES" : @"NO", @"fontchanged",(isLangChanged) ? @"YES" : @"NO", @"langchanged",(isModeChanged) ? @"YES" : @"NO", @"modechanged", (searchChanged) ? @"YES" : @"NO", @"searchChanged", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:dict];
        
    }
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSDictionary *dict = [arraySettings objectAtIndex:section];
    return [dict valueForKey:@"header"];
    /*if(section == 0){
        return @"Languages";
    }else if(section == 1){
        return @"Malayalam Typing";
    }else if(section == 3){
        return @"Info";
    }else if(section == FontSizeRow){
        return @"Text Size";
    }
    return nil;*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [arraySettings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSDictionary *dict = [arraySettings objectAtIndex:section];
    NSArray *arry = [dict valueForKey:@"data"];
    if(arry){
        return [arry count];
    }
    else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [arraySettings objectAtIndex:indexPath.section];
    NSInteger indexconst = [[dict valueForKey:@"sectionindex"] integerValue];
    if(indexconst == FontSizeRow || (indexconst == 4 && indexPath.row == 1)){
        return 72;
        
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dict = [arraySettings objectAtIndex:indexPath.section];
    NSInteger indexconst = [[dict valueForKey:@"sectionindex"] integerValue];
    
    NSString *celltype = @"";
    if(indexconst == FontSizeRow) {
        
        celltype = @"FONT";
        
    }else if (indexconst == 7){
        
        celltype = @"themecolor";
    }
    else if( (indexconst == 4 && indexPath.row == 0) || indexconst == 5 || (indexconst == 6 && indexPath.row == 0)) {
        
        celltype = @"autoscrollswitch";
    }else if(indexconst == 4 && indexPath.row == 1){
        celltype = @"scroll";
    }
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CEll%@", celltype];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if(indexconst == FontSizeRow) {
            cell = [[FontSizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier IsFontCell:YES];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ((FontSizeCell *)cell).lblSample.text = @"Sample Text";
            
            ((FontSizeCell *)cell).lblSample.backgroundColor = [UIColor clearColor];
            
        }else if(indexconst == 4) {
            if(indexPath.row == 0){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = self.switchScroll;
            }else{
                cell = [[FontSizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier IsFontCell:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSArray *arry = [dict valueForKey:@"data"];
                NSDictionary *dictData = [arry objectAtIndex:indexPath.row];
                
                if(dictData){
                    ((FontSizeCell *)cell).lblSample.text = [dictData valueForKey:@"label"];
                }
                
            }
            
        }else if(indexconst == 5) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = self.switchNightMode;
        }
        else if(indexconst == 6) {
            
            if(indexPath.row == 0){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = self.switchCustomKB;

            }else{
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }else if (indexconst == 7){
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 20, 20)];
            
            //NSString *color = [MBUtils getHighlightColorof:kStoreColor1];//
            //[button setBackgroundColor:[UIColor colorWithHexString:color]];
            
            cell.accessoryView = button;
        }
        else{
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        /*bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if (isdark ){
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor blackColor];
        }*/
        
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if (isdark ){
            cell.backgroundColor = [UIColor darkGrayColor];
        }
        
    }
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if (isdark ){
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if( !( (indexconst == 4 && indexPath.row == 1) || indexconst == FontSizeRow) ){
        
        NSArray *arry = [dict valueForKey:@"data"];
        NSDictionary *dictData = [arry objectAtIndex:indexPath.row];
        
        if(dictData){
            
            cell.textLabel.text = [dictData valueForKey:@"label"];
            cell.detailTextLabel.text = [dictData valueForKey:@"value"];
        }
    }
    if (indexconst == 7){
        
        //[[NSUserDefaults standardUserDefaults] setBool:[self.switchCustomKB isOn] forKey:kCustomKB];
        
        NSInteger colorr = [[NSUserDefaults standardUserDefaults] integerForKey:@"themecolor"];
        if(colorr == 0){
            colorr = 3;
        }
        
        [(UIButton *)cell.accessoryView setBackgroundColor:[[ColorViewController arrayColors] objectAtIndex:colorr-1]];
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
    
    NSDictionary *dict = [arraySettings objectAtIndex:indexPath.section];
    NSInteger indexconst = [[dict valueForKey:@"sectionindex"] integerValue];
    
    
    MBLog(@"indexconst = %li", (long)indexconst);
    
    // Navigation logic may go here. Create and push another view controller.
    if(indexconst == 0){
        
        /*LanguageViewController *detailViewController = [[LanguageViewController alloc] init];
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
         */
        // Navigation logic may go here. Create and push another view controller.
        NSMutableArray *options = [[NSMutableArray alloc] initWithCapacity:4];
        
        NSArray *arrayAllLangs = [NSArray arrayWithObjects:kLangNone, kLangPrimary, kLangEnglishASV, kLangEnglishKJV, nil];
        
        NSDictionary *dict = [arrayLangs objectAtIndex:indexPath.row];
        
        
        
        if([[dict valueForKey:@"label"] isEqualToString:NSLocalizedString(@"Primary", @"")]){
            
            for(NSString *langId in arrayAllLangs){
                
                if(![langId isEqualToString:kLangNone]){
                    
                    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(langId, @""),@"display_value",[ [dict valueForKey:@"languageid"] isEqualToString:langId] ? @"YES" : @"NO", @"isSelected", langId, @"languageid", nil];
                    
                    [options addObject:dict1];
                }
            }
            
            SelectionController *detailViewController = [[SelectionController alloc] initWithStyle:UITableViewStyleGrouped Options:options];
            detailViewController.optionType = 1;
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        }else if([[dict valueForKey:@"label"] isEqualToString:NSLocalizedString(@"Secondary", @"")]){
            
            NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
            NSString *primaryL = [dictPref valueForKey:@"primaryLanguage"];
            
            
            for(NSString *langId in arrayAllLangs){
                
                if(![langId isEqualToString:primaryL]){
                    
                    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(langId, @""),@"display_value",[ [dict valueForKey:@"languageid"] isEqualToString:langId] ? @"YES" : @"NO", @"isSelected", langId, @"languageid", nil];
                    
                    [options addObject:dict1];
                }
            }
            
            
            SelectionController *detailViewController = [[SelectionController alloc] initWithStyle:UITableViewStyleGrouped Options:options];
            detailViewController.optionType = 2;
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
        }

    }
    else if(indexconst == 1){
        WebViewController *webViewCtrlr = [[WebViewController alloc] init];
        //webViewCtrlr.title = NSLocalizedString(@"SearchHelp", @"");
        
        BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        CGRect r = self.navigationController.navigationBar.frame;
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
        
        lblTitle.text = NSLocalizedString(@"SearchHelp", @"");
        
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor clearColor];
        if (isdark || ![UIDeviceHardware isOS7Device]) {
            lblTitle.textColor = [UIColor whiteColor];
        }else{
            lblTitle.textColor = [UIColor blackColor];
        }
        webViewCtrlr.navigationItem.titleView = lblTitle;
        
        
        webViewCtrlr.requestURL = [[NSBundle mainBundle] pathForResource:@"lipi" ofType:@"png"];
        [self.navigationController pushViewController:webViewCtrlr animated:YES];
        /*
        //https://github.com/yuvipanda/indic-typing-tool
        WebViewController *webViewCtrlr = [[WebViewController alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = [paths objectAtIndex:0];
        NSString *path = [basePath stringByAppendingPathComponent:@"narayam"];
        
        
        path = [path stringByAppendingPathComponent:@"libs"];
        path = [path stringByAppendingPathComponent:@"jquery.ime"];
        path = [path stringByAppendingPathComponent:@"examples"];
        path = [path stringByAppendingPathComponent:@"index.html"];
        
        webViewCtrlr.requestURL = path;
        [self.navigationController pushViewController:webViewCtrlr animated:YES];
         */
    }else if(indexconst == FontSizeRow) {
        
        
    }else if(indexconst == 3){
        
        Information *infoViewController = [[Information  alloc] initWithNibName:@"Information" bundle:nil];
        //infoViewController.title = NSLocalizedString(@"AppInfo", @"");
        
        BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        CGRect r = self.navigationController.navigationBar.frame;
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
        
        lblTitle.text = NSLocalizedString(@"AppInfo", @"");
        
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor clearColor];
        if (isdark || ![UIDeviceHardware isOS7Device]) {
            lblTitle.textColor = [UIColor whiteColor];
        }else{
            lblTitle.textColor = [UIColor blackColor];
        }
        infoViewController.navigationItem.titleView = lblTitle;
        
        
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    else if(indexconst == 6){
        
        
        if(indexPath.row == 1){
            
            if(self.switchCustomKB.isOn){
                
                
                MBLog(@"open varamozhi");
                NSString *iTunesLink = @"itms://itunes.apple.com/app/id514987251";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                
            }else{
                WebViewController *webViewCtrlr = [[WebViewController alloc] init];
                //webViewCtrlr.title = NSLocalizedString(@"SearchHelp", @"");
                
                BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
                CGRect r = self.navigationController.navigationBar.frame;
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
                
                lblTitle.text = NSLocalizedString(@"SearchHelp", @"");
                
                lblTitle.textAlignment = NSTextAlignmentCenter;
                lblTitle.backgroundColor = [UIColor clearColor];
                if (isdark || ![UIDeviceHardware isOS7Device]) {
                    lblTitle.textColor = [UIColor whiteColor];
                }else{
                    lblTitle.textColor = [UIColor blackColor];
                }
                webViewCtrlr.navigationItem.titleView = lblTitle;
                
                
                webViewCtrlr.requestURL = [[NSBundle mainBundle] pathForResource:@"lipi" ofType:@"png"];
                [self.navigationController pushViewController:webViewCtrlr animated:YES];

            }
            
        }else if(indexPath.row == 2){
            
            MBLog(@"open easy malayalam");
            NSString *iTunesLink = @"itms://itunes.apple.com/app/id957578340";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
        
    }else if (indexconst == 7){
        
        //[[NSUserDefaults standardUserDefaults] setBool:[self.switchCustomKB isOn] forKey:kCustomKB];
        
        NSInteger colorr = [[NSUserDefaults standardUserDefaults] integerForKey:@"themecolor"];
        
        ColorViewController *controller = [[ColorViewController alloc] initWithStyle:UITableViewStylePlain SelectedColor:colorr-1 Delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
  
  
     
}

#pragma  mark MBColourSelectorDelegate
- (void)colorStringDidChange:(NSNumber *)newColor{
    
    NSInteger colorr = [[NSUserDefaults standardUserDefaults] integerForKey:@"themecolor"];
    
    if(colorr != [newColor integerValue]+1){
        
        [[NSUserDefaults standardUserDefaults] setInteger:[newColor integerValue]+1 forKey:@"themecolor"];
        
        MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
        if([UIDeviceHardware isOS7Device]){
            appDelegate.window.tintColor = [[ColorViewController arrayColors] objectAtIndex:[newColor integerValue]];
        }
        [appDelegate.window setNeedsDisplay];
        
        self.isThemeChanged = YES;
        
        [self.tableView reloadData];

    }
    
    
}

@end
