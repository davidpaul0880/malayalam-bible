//
//  BookmarkAddViewController.m
//  Malayalam Bible
//
//  Created by jijo on 11/6/12.
//
//

#import "BookmarkAddViewController.h"
#import "FolderSelectController.h"
#import "MalayalamBibleAppDelegate.h"

#import "Folders.h"
#import "BookMarks.h"
#import "UIDeviceHardware.h"
#import "MBConstants.h"

//+20261118 TEMPORARY DIAGNOSTICS (MBDIAG) — remove after the redesign is confirmed on screen.
// The marker is a string in the compiled binary (`strings ... | grep MBDIAG-ADDBOOKMARK`), and every log line
// carries the time this file was compiled, so the running build can be matched to this source.
static NSString * const kMBDiagMarker = @"MBDIAG-ADDBOOKMARK-REDESIGN-v2-20261118";


@interface BookmarkAddViewController ()


@property (nonatomic, retain) UITextField *activeTextField;

//+20261118 Redesign helpers (visual only)
- (UIImage *) mb_iconTileForSymbol:(NSString *)symbolName;
- (BOOL) mb_isLightColor:(UIColor *)color;
- (void) mb_installAddBookmarkButton;

@end


@implementation BookmarkAddViewController

@synthesize activeTextField = _activeTextField;
@synthesize defaultFolder = _defaultFolder;
@synthesize bookMark, delegate, verseText;

- (id)initWithStyle:(UITableViewStyle)style
{
    //+20261118 Redesign: rounded inset cards instead of full-width rows, like the Settings screen. The caller
    // still passes UITableViewStyleGrouped; only this screen's look changes.
    self = [super initWithStyle:UITableViewStyleInsetGrouped];
    NSLog(@"[%@] initWithStyle: requested=%ld compiled=%s %s instance=%p class=%@", kMBDiagMarker, (long)style, __DATE__, __TIME__, self, NSStringFromClass([self class]));
    if (self) {
        // Custom initialization
        //MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    BOOL isos7 = NO;
    if([UIDeviceHardware isOS7Device]){
        
        isos7 = YES;
        
        
        UIColor *changedcolor;
        if (isdark ){
            
            changedcolor = [UIColor blackColor];
            
            
            self.tableView.backgroundColor = [UIColor blackColor];
            self.tableView.backgroundView.backgroundColor = [UIColor blackColor];
            
            //+20261118 Night mode: the system separator colour for the dark surfaces below, instead of 30% white,
            // which read as bright lines between the rows.
            self.tableView.separatorColor = [UIColor separatorColor];
            
            /*NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor],UITextAttributeTextColor,
                                                       [UIColor blackColor], UITextAttributeTextShadowColor,
                                                       [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
            [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
            */
        }else{
            changedcolor = [UIColor whiteColor];
        }
        self.view.backgroundColor = changedcolor;
        
        
        
        self.navigationController.navigationBar.barTintColor = changedcolor;
        self.navigationController.navigationBar.translucent = NO;
        
        
        
        self.navigationController.navigationBar.tintColor = [UIColor defaultWindowColor];
        
    }else{
     
        if (isdark) {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            
        }else{
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            
        }
        //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }

    //+20261117 Night mode: this screen follows the app's own Night mode (kNightTime) instead of the iOS
    // appearance, so the system colours it does not set itself (section headers, description field text and
    // placeholder, keyboard, disclosure arrow) match it.
    self.overrideUserInterfaceStyle = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;

    //+20261118 Redesign: iOS grouped surfaces, the same as the Settings screen. Light: soft grey background
    // with white cards. Night: black background with raised dark grey (#1C1C1E) cards. Replaces the white table
    // (Light) and the black table set above (Night) on this screen only.
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    //+20261117 Navigation bar: iOS 15+ draws bars from UIBarAppearance objects. barTintColor (set above) only
    // reaches the scrolled state. Set on this screen's navigationItem only, so the shared bar and other
    // screens in this navigation controller keep their own styling.
    //+20261118 Redesign: the bar uses the same grouped background as the screen, so bar and content read as
    // one surface (as in Settings).
    UITraitCollection *barTraits = [UITraitCollection traitCollectionWithUserInterfaceStyle:(isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight)];
    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    [barAppearance configureWithOpaqueBackground];
    barAppearance.backgroundColor = [[UIColor systemGroupedBackgroundColor] resolvedColorWithTraitCollection:barTraits];
    barAppearance.shadowColor = isdark ? [UIColor colorWithWhite:1.0 alpha:0.25] : [[UIColor separatorColor] resolvedColorWithTraitCollection:barTraits];
    UINavigationBarAppearance *scrollEdgeAppearance = [barAppearance copy];
    scrollEdgeAppearance.shadowColor = [UIColor clearColor];   // no divider at the top of the list, as before
    self.navigationItem.standardAppearance = barAppearance;
    self.navigationItem.compactAppearance = barAppearance;
    self.navigationItem.scrollEdgeAppearance = scrollEdgeAppearance;
    self.navigationItem.compactScrollEdgeAppearance = scrollEdgeAppearance;
        

    

    //self.title =
    //BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    CGRect r = self.navigationController.navigationBar.frame;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
    lblTitle.text = NSLocalizedString(@"add.bookmark", @"");
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    if (isdark || !isos7) {
        lblTitle.textColor = [UIColor whiteColor];
    }else{
        lblTitle.textColor = [UIColor blackColor];
    }
    lblTitle.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];   //+20261118 Redesign: standard iOS title weight
    self.navigationItem.titleView = lblTitle;
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];

    //+20261118 Redesign: a prominent primary button below the cards (the Save button above stays).
    [self mb_installAddBookmarkButton];
    NSLog(@"[%@] viewDidLoad: instance=%p tableStyle=%ld (2=insetGrouped) footer=%@ nav=%@", kMBDiagMarker, self, (long)self.tableView.style, self.tableView.tableFooterView, self.navigationController);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//+20261118 TEMPORARY DIAGNOSTICS (MBDIAG): what is on screen once the view is about to appear and has appeared.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"[%@] viewWillAppear: instance=%p view=%@ tableView=%@ style=%ld", kMBDiagMarker, self, self.view, self.tableView, (long)self.tableView.style);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"[%@] viewDidAppear: instance=%p presentedBy=%@ visibleCells=%lu footerFrame=%@ superviewOfTable=%@", kMBDiagMarker, self, self.presentingViewController, (unsigned long)self.tableView.visibleCells.count, NSStringFromCGRect(self.tableView.tableFooterView.frame), self.tableView.superview);
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        NSLog(@"[%@]   cell %@ contentConfiguration=%@ subviews=%lu", kMBDiagMarker, cell.reuseIdentifier, NSStringFromClass([cell.contentConfiguration class]), (unsigned long)cell.contentView.subviews.count);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark selector methods

- (void) saveClicked:(UIBarButtonItem *)btn{
    
    [self.activeTextField resignFirstResponder];
    
       
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    
    
    
    BookMarks *bookMarktoSave = [NSEntityDescription insertNewObjectForEntityForName:@"BookMarks" inManagedObjectContext:context];
    [bookMarktoSave setVersetitle:self.bookMark.versetitle];
    [bookMarktoSave setBookid:self.bookMark.bookid];
    [bookMarktoSave setChapter:self.bookMark.chapter];
    [bookMarktoSave setVerseid:self.bookMark.verseid];

    
    
    bookMarktoSave.createddate = [NSDate date]; ///setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"createddate"];
    if(!self.bookMark.bmdescription){
        bookMarktoSave.bmdescription = self.verseText;
    }else{
        bookMarktoSave.bmdescription = self.bookMark.bmdescription;
    }
    
    [bookMarktoSave setFolder:self.defaultFolder];
            
    NSError *error;
    [context save:&error];
    MBLog(@"ggggg");
    [delegate setBookMarkForIds:self.bookMark];
    MBLog(@"ggggg2");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) cancelClicked:(UIBarButtonItem *)btn{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    [context rollback];
}

//+20131114
- (BOOL)shouldAutorotate {
    
    
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if([UIDeviceHardware isOS6Device]){
        return YES;
    }else{
        
    }
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)){
        
        if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
           (interfaceOrientation == UIInterfaceOrientationLandscapeRight))  {
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 3;//[self.arrayBookmarkDetails count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //+20261118 Redesign: same three rows and the same data as before (verse title, description field, group),
    // presented as cards. One reuse identifier per row type, because only the description row has a field.
    NSString *CellIdentifier = (indexPath.section == 1) ? @"DescriptionCell" : ((indexPath.section == 0) ? @"VerseCell" : @"GroupCell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Card surface: white in Light, raised dark grey (#1C1C1E) in Night through this screen's override.
        cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        
        if(indexPath.section == 1){
            UITextField *tfiled = [[UITextField alloc] initWithFrame:CGRectZero];
            tfiled.delegate = self;
            tfiled.tag = 1+indexPath.section;
            tfiled.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            tfiled.adjustsFontForContentSizeCategory = YES;
            tfiled.textColor = [UIColor labelColor];
            tfiled.tintColor = [UIColor defaultWindowColor];                 // cursor in the theme colour
            tfiled.clearButtonMode = UITextFieldViewModeWhileEditing;
            tfiled.returnKeyType = UIReturnKeyDone;
            [[cell contentView] addSubview:tfiled];
            // Pinned to the card's margins so it fills the card on any width and lines up with the other rows.
            tfiled.translatesAutoresizingMaskIntoConstraints = NO;
            UILayoutGuide *margins = cell.contentView.layoutMarginsGuide;
            NSLayoutConstraint *minHeight = [tfiled.heightAnchor constraintGreaterThanOrEqualToConstant:52.0];
            [NSLayoutConstraint activateConstraints:@[
                [tfiled.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
                [tfiled.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
                [tfiled.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
                [tfiled.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
                minHeight
            ]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if(indexPath.section == 2){
        Folders *foldrs = self.defaultFolder;//[self.arrayBookmarkDetails objectAtIndex:indexPath.section];
        UIListContentConfiguration *content = [UIListContentConfiguration cellConfiguration];
        content.text = foldrs.folder_label;
        content.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        content.textProperties.adjustsFontForContentSizeCategory = YES;
        content.textProperties.color = [UIColor labelColor];
        content.image = [self mb_iconTileForSymbol:@"folder.fill"];
        content.imageProperties.reservedLayoutSize = CGSizeMake(29.0, 29.0);
        content.imageToTextPadding = 14.0;
        NSDirectionalEdgeInsets margins = content.directionalLayoutMargins;
        margins.top = 11.5;
        margins.bottom = 11.5;
        content.directionalLayoutMargins = margins;
        cell.contentConfiguration = content;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if(indexPath.section == 0){
        
        // Verse card: the reference as the heading and the verse itself below it, wrapped, so the user sees
        // what is being bookmarked (before, the verse only appeared as a cut-off placeholder).
        UIListContentConfiguration *content = [UIListContentConfiguration subtitleCellConfiguration];
        content.text = self.bookMark.versetitle;
        content.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        content.textProperties.adjustsFontForContentSizeCategory = YES;
        content.textProperties.color = [UIColor labelColor];
        content.textProperties.numberOfLines = 0;
        if (self.verseText.length > 0) {
            content.secondaryText = self.verseText;
            content.secondaryTextProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            content.secondaryTextProperties.adjustsFontForContentSizeCategory = YES;
            content.secondaryTextProperties.color = [UIColor secondaryLabelColor];
            content.secondaryTextProperties.numberOfLines = 4;
            content.secondaryTextProperties.lineBreakMode = NSLineBreakByTruncatingTail;
            content.textToSecondaryTextVerticalPadding = 6.0;
        }
        content.image = [self mb_iconTileForSymbol:@"book.closed.fill"];
        content.imageProperties.reservedLayoutSize = CGSizeMake(29.0, 29.0);
        content.imageToTextPadding = 14.0;
        NSDirectionalEdgeInsets margins = content.directionalLayoutMargins;
        margins.top = 14.0;
        margins.bottom = 14.0;
        content.directionalLayoutMargins = margins;
        cell.contentConfiguration = content;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        
        UITextField *field = (UITextField *)[[cell contentView] viewWithTag:1+indexPath.section];
        if(self.bookMark.bmdescription){
            field.text = self.bookMark.bmdescription;
        }else{
            field.placeholder = verseText;//self.bookMark.versetitle;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;

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
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    
    
    if(section == 2){
        return NSLocalizedString(@"bookmark.group", @"");
    }else if(section == 0){
        
        return NSLocalizedString(@"bookmark.verse", @"");
    }else{
        return NSLocalizedString(@"bookmark.description", @"");
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 2){
        
        FolderSelectController *controller = [[FolderSelectController alloc] initWithStyle:UITableViewStyleGrouped Delegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	self.activeTextField = textField;
    return YES;
}
//+20261118 Redesign: the keyboard's Done key closes the keyboard; the text is stored in
// textFieldDidEndEditing: exactly as when the field loses focus any other way.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   // NSInteger section = textField.tag;
   
    self.bookMark.bmdescription = textField.text;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    return YES;
}

#pragma mark  MBFolderSelectDelegate 

- (void)selectedFolder:(Folders *)folder{
    
    self.defaultFolder = folder;
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Appearance (+20261118 Add Bookmark redesign)
//
// Visual only. The accent everywhere is the app's existing theme colour, [UIColor defaultWindowColor]
// (themecolor from the 9-colour palette, default blue), the same colour as the navigation buttons. No colour
// values, preference keys or stored data change.

- (BOOL) mb_isLightColor:(UIColor *)color{

    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) {
        CGFloat w = 0;
        if (![color getWhite:&w alpha:&a]) return NO;
        r = g = b = w;
    }
    return (0.299 * r + 0.587 * g + 0.114 * b) > 0.7;
}

// A 29 pt rounded tile in the theme colour with a white symbol (black on very light theme colours such as
// Night mode yellow or cyan), the same style as the Settings screen's row icons.
- (UIImage *) mb_iconTileForSymbol:(NSString *)symbolName{

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:15 weight:UIImageSymbolWeightSemibold];
    UIImage *symbol = [UIImage systemImageNamed:symbolName withConfiguration:config];
    if (symbol == nil) return nil;
    UIColor *accent = [UIColor defaultWindowColor];
    UIColor *glyphColor = [self mb_isLightColor:accent] ? [UIColor blackColor] : [UIColor whiteColor];
    UIImage *glyph = [symbol imageWithTintColor:glyphColor renderingMode:UIImageRenderingModeAlwaysOriginal];

    CGSize tileSize = CGSizeMake(29.0, 29.0);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:tileSize];
    UIImage *tile = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [accent setFill];
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, tileSize.width, tileSize.height) cornerRadius:7.0] fill];
        CGSize glyphSize = glyph.size;
        [glyph drawInRect:CGRectMake((tileSize.width - glyphSize.width) / 2.0, (tileSize.height - glyphSize.height) / 2.0, glyphSize.width, glyphSize.height)];
    }];
    return [tile imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

// Full-width rounded button in the theme colour below the cards. It calls the existing saveClicked:, so saving,
// the stored values and dismissal are exactly the same as with the Save button in the navigation bar.
- (void) mb_installAddBookmarkButton{

    UIColor *accent = [UIColor defaultWindowColor];
    UIColor *foreground = [self mb_isLightColor:accent] ? [UIColor blackColor] : [UIColor whiteColor];

    UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
    config.title = NSLocalizedString(@"add.bookmark", @"");
    config.image = [UIImage systemImageNamed:@"bookmark.fill"];
    config.imagePadding = 8.0;
    config.baseBackgroundColor = accent;
    config.baseForegroundColor = foreground;
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

    // Footer with the table's own margins, so the button lines up with the cards on iPhone and iPad.
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

@end
