//
//  FolderViewController.m
//  Malayalam Bible
//
//  Created by jijo on 3/13/13.
//
//

#import "FolderDetailController.h"
#import "MalayalamBibleAppDelegate.h"
#import "MBConstants.h"
#import "UIDeviceHardware.h"


@interface FolderDetailController ()

@property (nonatomic, retain) UITextField *activeTextField;
@property(nonatomic, assign) NSInteger viewMode;
@property (nonatomic) id <MBFolderEditDelegate> delegatee;

//+20261120 Redesign helpers (presentation only)
- (void) mb_applyFolderAppearance;
- (void) mb_installSaveButton;
- (UIImage *) mb_folderIconTile;
- (UIColor *) mb_textColorOnColor:(UIColor *)color;

@end

@implementation FolderDetailController

@synthesize viewMode= _viewMode;
@synthesize folderD = _folderD;
@synthesize activeTextField = _activeTextField;
@synthesize delegatee;

- (id)initWithStyle:(UITableViewStyle)style ViewMode:(NSInteger)vMode AndDelegate:(id)del
{
    //+20261120 Redesign: rounded inset cards (callers pass UITableViewStyleGrouped; only this screen's look changes).
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    if (self) {
        
        self.viewMode = vMode;
        self.delegatee = del;
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *changedcolor;
    if (isdark ){
        
        changedcolor = [UIColor blackColor];
        
        
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
        
        self.tableView.separatorColor = [UIColor separatorColor]; //+20261118 Night mode: system separator, not bright 30% white
        /*if([UIDeviceHardware isOS7Device]){
            NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   [UIColor blackColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        }
         */
        
    }else{
        changedcolor = [UIColor whiteColor];
    }
    self.view.backgroundColor = changedcolor;
    
    //+20261118 Night mode: follow the app's own Night mode (kNightTime) rather than the iOS appearance, so the
    // system colours this screen does not set itself (section headers, edit and delete controls, swipe actions,
    // text and keyboard) match it. Same convention as the Add Bookmark and Settings screens.
    self.overrideUserInterfaceStyle = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    if (isdark) {
        // iOS 15+ draws bars from UIBarAppearance; barTintColor alone leaves the bar transparent at the top of the
        // list. Set on this screen's navigationItem only, so other screens keep their own bar styling.
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        [barAppearance configureWithOpaqueBackground];
        barAppearance.backgroundColor = [UIColor blackColor];
        UINavigationBarAppearance *scrollEdgeAppearance = [barAppearance copy];
        scrollEdgeAppearance.shadowColor = [UIColor clearColor];
        self.navigationItem.standardAppearance = barAppearance;
        self.navigationItem.compactAppearance = barAppearance;
        self.navigationItem.scrollEdgeAppearance = scrollEdgeAppearance;
        self.navigationItem.compactScrollEdgeAppearance = scrollEdgeAppearance;
    }
    
    BOOL isos7 = NO;
    self.navigationController.navigationBar.translucent = NO;
     if([UIDeviceHardware isOS7Device]){
            isos7   = YES;
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
    
    if(self.viewMode == kModeNew){
        lblTitle.text = @"Add Folder";
    }else{
        lblTitle.text = @"Edit Folder";
    }
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    if (isdark || !isos7) {
        lblTitle.textColor = [UIColor whiteColor];
    }else{
        lblTitle.textColor = [UIColor blackColor];
    }
    lblTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];   //+20261120 standard iOS title weight
    lblTitle.textColor = [UIColor labelColor];   //+20261120 follows this screen's Night / Light override
    self.navigationItem.titleView = lblTitle;
    
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];

    //+20261120 Redesign: grouped surfaces, matching bar, and a prominent Save button below the card.
    [self mb_applyFolderAppearance];
    [self mb_installSaveButton];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//+20261120 New folder: start with the keyboard up in the name field. This also makes the field the active one,
// which saveClicked: reads the name from (tapping Save without ever focusing it reported an empty name).
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.viewMode == kModeNew && self.activeTextField == nil) {
        UITextField *field = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:1];
        if (field.enabled) {
            [field becomeFirstResponder];
        }
    }
}

//+20261120 iPad: a centred, readable column instead of a card stretched across the whole screen.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat width = self.tableView.bounds.size.width;
    CGFloat side = (width < 375.0) ? 16.0 : 20.0;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && width > 640.0 + 2 * side) {
        side = floor((width - 640.0) / 2.0);
    }
    UIEdgeInsets margins = self.tableView.layoutMargins;
    if (fabs(margins.left - side) > 0.5 || fabs(margins.right - side) > 0.5) {
        self.tableView.preservesSuperviewLayoutMargins = NO;
        self.tableView.layoutMargins = UIEdgeInsetsMake(margins.top, side, margins.bottom, side);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Selector methods

- (void) saveClicked:(id)sender{
    
    
    [self.activeTextField resignFirstResponder];
    
    if ([@"Bookmarks" isEqualToString:self.activeTextField.text] || [@"Notes" isEqualToString:self.activeTextField.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bible"
                                                        message:@"Entered folder name is reserved. Please enter other name!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{
        
        if(self.viewMode == kModeNew){
            
            MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            NSManagedObjectContext *context =  [appDelegate managedObjectContext];
            MBLog(@"here 0");
            self.folderD = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
            
            self.folderD.folder_label = self.activeTextField.text;
        }
        MBLog(@"here");
        if(self.folderD.folder_label.length > 0){
            MBLog(@"here insert");
            [delegatee upsertedFolder:self.folderD AndMode:self.viewMode];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bible"
                                                            message:@"Folder name should not be empty!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

    }
    
    
    
}
#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return dateFormatter;
}
#pragma mark - Table view data source

 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
     if(section == 0){
         return NSLocalizedString(@"Folder Name:", @"");
     }/*else if(section == 1){
        return NSLocalizedString(@"Highlight Color:", @"");
     }*/else if(section == 1){
         return NSLocalizedString(@"Created Time:", @"");
     }else{
         return @"";//NSLocalizedString(@"interview_comments", @"");
     }
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    if(self.viewMode == kModeNew){
        return 1;
    }else{
        return 1;
    }
    
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
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //+20261120 Card surface: white in Light, raised dark grey (#1C1C1E) in Night through this screen's override.
        cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.section == 0){
            //+20261120 Name card: folder icon tile in the theme colour, then the name field filling the row.
            UIImageView *icon = [[UIImageView alloc] initWithImage:[self mb_folderIconTile]];
            icon.translatesAutoresizingMaskIntoConstraints = NO;
            icon.isAccessibilityElement = NO;
            [[cell contentView] addSubview:icon];

            UITextField *tfiled = [[UITextField alloc] initWithFrame:CGRectZero];
            tfiled.delegate = self;
            tfiled.tag = 1+indexPath.section;
            tfiled.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            tfiled.adjustsFontForContentSizeCategory = YES;
            tfiled.textColor = [UIColor labelColor];
            tfiled.tintColor = [UIColor defaultWindowColor];   // cursor in the theme colour
            tfiled.placeholder = NSLocalizedString(@"Folder name", @"");
            tfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            tfiled.returnKeyType = UIReturnKeyDone;
            tfiled.autocapitalizationType = UITextAutocapitalizationTypeWords;
            tfiled.accessibilityLabel = NSLocalizedString(@"Folder Name:", @"");
            [[cell contentView] addSubview:tfiled];
            //+20261118 Layout: pinned to the row's margins (no fixed 320 pt-based frame).
            tfiled.translatesAutoresizingMaskIntoConstraints = NO;
            UILayoutGuide *margins = cell.contentView.layoutMarginsGuide;
            NSLayoutConstraint *minHeight = [cell.contentView.heightAnchor constraintGreaterThanOrEqualToConstant:56.0];
            minHeight.priority = UILayoutPriorityDefaultHigh;
            [NSLayoutConstraint activateConstraints:@[
                [icon.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
                [icon.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                [icon.widthAnchor constraintEqualToConstant:29.0],
                [icon.heightAnchor constraintEqualToConstant:29.0],
                [tfiled.leadingAnchor constraintEqualToAnchor:icon.trailingAnchor constant:14.0],
                [tfiled.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
                [tfiled.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
                [tfiled.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
                [tfiled.heightAnchor constraintGreaterThanOrEqualToConstant:44.0],
                minHeight
            ]];

        }
                
    }
    
    if (isdark ){
        //cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor labelColor]; //+20261118 Night mode
        
    }
    
    if(indexPath.section == 0){
        
        UITextField *field = (UITextField *)[[cell contentView] viewWithTag:1+indexPath.section];
        if(self.viewMode == kModeNew){
            field.enabled = YES;
        }else if(self.viewMode == kModeEdit){
            
            if([@"Bookmarks" isEqualToString:self.folderD.folder_label]){
                field.enabled = NO;
            }else{
                field.enabled = YES;
            }
            field.text = self.folderD.folder_label;
        }else{
            field.enabled = NO;
            field.text = self.folderD.folder_label;
        }
        
        field.textColor = field.enabled ? [UIColor labelColor] : [UIColor secondaryLabelColor];   //+20261120 read-only name
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }/*else if(indexPath.section == 1){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        MBLog(@"cellll  self.folderD.folder_color = %@", self.folderD.folder_color);
        if(self.folderD.folder_color){
            cell.textLabel.text = @"";
            
             MBLog(@"cellll1  self.folderD.folder_color = %@", self.folderD.folder_color);
        }else{
            cell.textLabel.text = @"None";
             MBLog(@"cellll2  self.folderD.folder_color = %@", self.folderD.folder_color);
        }
        
    }*/else{
        cell.textLabel.text = [self.dateFormatter stringFromDate:self.folderD.createddate];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
   
    // Configure the cell...
    
    return cell;
}

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
       
        if(self.folderD.folder_color.length > 0){
            cell.backgroundColor = [self colorFromHexString:self.folderD.folder_color];
        }else{
            cell.backgroundColor = [self colorFromHexString:@"#FFFFFF"];
        }
    }
	
}
 */
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
    
    /*if(indexPath.section == 1 && (self.viewMode == kModeNew || self.viewMode == kModeEdit)){
        
        ColorViewController *controller = [[ColorViewController alloc] initWithStyle:UITableViewStyleGrouped SelectedColor:self.folderD.folder_color Delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }*/
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	self.activeTextField = textField;
    return YES;
}
//+20261120 The keyboard's Done key closes the keyboard; the name is handled exactly as before (Edit mode stores
// it in textFieldDidEndEditing:, Save reads the field).
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   if(self.viewMode != kModeNew){
       self.folderD.folder_label = textField.text;
   }
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

#pragma mark MBColourSelectorDelegate
- (void)colorStringDidChange:(NSString *)newColor{
    
    
    [self.folderD setFolder_color:newColor];
    
	[self.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Appearance (+20261120 Add Folder redesign)
//
// Presentation only. Night or Light follows the app's own Night mode (kNightTime); the accent is the existing
// theme colour, [UIColor defaultWindowColor]. Saving, validation, persistence and the delegate are unchanged.

- (void) mb_applyFolderAppearance{

    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIUserInterfaceStyle style = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    UITraitCollection *traits = [UITraitCollection traitCollectionWithUserInterfaceStyle:style];
    UIColor *background = [[UIColor systemGroupedBackgroundColor] resolvedColorWithTraitCollection:traits];

    self.overrideUserInterfaceStyle = style;
    // Grouped surfaces, as on Settings, Add Bookmark and Search: Light #F2F2F7 page with white cards,
    // Night black page with #1C1C1E cards.
    self.view.backgroundColor = background;
    self.tableView.backgroundColor = background;
    self.tableView.separatorColor = [UIColor separatorColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 56.0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    // This screen's own bar, on its navigationItem (the screens around it keep theirs): the page surface,
    // a hairline once content scrolls under it, and the title in the label colour.
    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    [barAppearance configureWithOpaqueBackground];
    barAppearance.backgroundColor = background;
    barAppearance.shadowColor = [[UIColor separatorColor] resolvedColorWithTraitCollection:traits];
    barAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [[UIColor labelColor] resolvedColorWithTraitCollection:traits]};
    UINavigationBarAppearance *edgeAppearance = [barAppearance copy];
    edgeAppearance.shadowColor = [UIColor clearColor];
    self.navigationItem.standardAppearance = barAppearance;
    self.navigationItem.compactAppearance = barAppearance;
    self.navigationItem.scrollEdgeAppearance = edgeAppearance;
    self.navigationItem.compactScrollEdgeAppearance = edgeAppearance;
}

// Full-width rounded button in the theme colour below the card. It calls the existing saveClicked:, so the
// reserved-name and empty-name checks, saving and the delegate call are exactly those of the bar's Save button.
- (void) mb_installSaveButton{

    UIColor *accent = [UIColor defaultWindowColor];
    UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
    config.title = NSLocalizedString(@"Save", @"");
    config.image = [UIImage systemImageNamed:@"folder.badge.plus"];
    config.imagePadding = 8.0;
    config.baseBackgroundColor = accent;
    config.baseForegroundColor = [self mb_textColorOnColor:accent];
    config.cornerStyle = UIButtonConfigurationCornerStyleLarge;
    config.contentInsets = NSDirectionalEdgeInsetsMake(14.0, 20.0, 14.0, 20.0);
    config.titleTextAttributesTransformer = ^NSDictionary<NSAttributedStringKey, id> *(NSDictionary<NSAttributedStringKey, id> *incoming) {
        NSMutableDictionary *outgoing = [incoming mutableCopy];
        outgoing[NSFontAttributeName] = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        return outgoing;
    };

    UIButton *button = [UIButton buttonWithConfiguration:config primaryAction:nil];
    [button addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    // Footer with the table's margins, so the button lines up with the card on iPhone and iPad.
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100.0)];
    footer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footer.preservesSuperviewLayoutMargins = YES;
    [footer addSubview:button];
    [NSLayoutConstraint activateConstraints:@[
        [button.leadingAnchor constraintEqualToAnchor:footer.layoutMarginsGuide.leadingAnchor],
        [button.trailingAnchor constraintEqualToAnchor:footer.layoutMarginsGuide.trailingAnchor],
        [button.topAnchor constraintEqualToAnchor:footer.topAnchor constant:24.0],
        [button.heightAnchor constraintGreaterThanOrEqualToConstant:50.0]
    ]];
    self.tableView.tableFooterView = footer;
}

// 29 pt rounded tile in the theme colour with a folder glyph, the same row-icon style as Settings and Add Bookmark.
- (UIImage *) mb_folderIconTile{

    UIColor *accent = [UIColor defaultWindowColor];
    UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:15 weight:UIImageSymbolWeightSemibold];
    UIImage *glyph = [[UIImage systemImageNamed:@"folder.fill" withConfiguration:symbolConfig] imageWithTintColor:[self mb_textColorOnColor:accent] renderingMode:UIImageRenderingModeAlwaysOriginal];
    CGSize tileSize = CGSizeMake(29.0, 29.0);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:tileSize];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [accent setFill];
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, tileSize.width, tileSize.height) cornerRadius:7.0] fill];
        CGSize glyphSize = glyph.size;
        [glyph drawInRect:CGRectMake((tileSize.width - glyphSize.width) / 2.0, (tileSize.height - glyphSize.height) / 2.0, glyphSize.width, glyphSize.height)];
    }];
}

// White when it reaches 3.5:1 on the colour (WCAG contrast), otherwise black — the rule used for the Search
// scope buttons: white on red, Light green, blue, purple and brown; black on cyan, yellow, magenta, orange and
// the Night palette's bright green.
- (UIColor *) mb_textColorOnColor:(UIColor *)color{

    CGFloat rgb[3] = {0, 0, 0};
    CGFloat alpha = 0;
    if (![color getRed:&rgb[0] green:&rgb[1] blue:&rgb[2] alpha:&alpha]) {
        CGFloat white = 0;
        [color getWhite:&white alpha:&alpha];
        rgb[0] = rgb[1] = rgb[2] = white;
    }
    for (int i = 0; i < 3; i++) {
        rgb[i] = (rgb[i] <= 0.03928) ? rgb[i] / 12.92 : pow((rgb[i] + 0.055) / 1.055, 2.4);
    }
    CGFloat luminance = 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2];
    return (1.05 / (luminance + 0.05) >= 3.5) ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
