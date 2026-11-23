//
//  SearchViewController.m
//  Malayalam Bible
//
//  Created by jijo on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "mal_api.h"
#include "txt2html.h"
#import "BibleDao.h"
#import "MBConstants.h"
//#import "MalayalamBibleDetailViewController.h"
#import "MalayalamBibleAppDelegate.h"
#import "WebViewController.h"
#import "MBUtils.h"
//#import "UIButtonGlossy.h"
#import "UIDeviceHardware.h"
#import "mozhi_unicode_default.h"

#define tagLabelCount 8

@interface SearchViewController(Private)

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope AndBookid:(int)bookid;
-(NSUInteger) getResultDataCount;    

@end

//+20261120 Search redesign: presentation-only state (no change to search logic or stored data).
static const NSInteger kTagSearchLabelBorder = 9901;
static const CGFloat kSearchMaxContentWidth = 720.0;   // iPad: centred, readable result column
static const CGFloat kSearchMaxFieldWidth = 640.0;     // iPad: search field never spans the whole bar

//+20261120 Scope bar above the keyboard. A plain view (not a UIToolbar): on iOS 26 a toolbar no longer paints
// barTintColor and puts every button on a white glass capsule, which made the white titles invisible.
// It grows by the bottom safe area, so with a hardware keyboard (bar at the screen's bottom edge) the buttons
// stay clear of the home indicator and the rounded corners.
@interface MBSearchScopeBar : UIView
@end

@implementation MBSearchScopeBar
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 52.0 + self.safeAreaInsets.bottom);
}
- (void)safeAreaInsetsDidChange
{
    [super safeAreaInsetsDidChange];
    [self invalidateIntrinsicContentSize];
}
@end

@interface SearchViewController ()
@property (nonatomic, copy) NSString *mbHighlightQuery;   // the text that was searched for, to highlight it
@property (nonatomic, assign) BOOL mbHasSearched;         // a search finished for the current text
@property (nonatomic, strong) UILabel *mbStateLabel;      // empty / no-results message
- (void) mb_applySearchAppearance;
- (void) mb_updateStateView;
- (NSAttributedString *) mb_attributedVerse:(NSString *)verse font:(UIFont *)font;
- (UIColor *) mb_scopeTitleColorOnColor:(UIColor *)color;
@end

@implementation SearchViewController

@synthesize  labelSearch, arrayResults, primaryL, isFirstTime, tableViewSearch, selectedBook, scopeValue, searchBarr;
@synthesize detailViewController = _detailViewController;
@synthesize activityView = _activityView;
@synthesize allBtn, oldBtn, newwBtn, bookBtn;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.scopeValue = 3;
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
    
    CGFloat yValue = 0;
    CGFloat xValue = 0;
    if([UIDeviceHardware isOS7Device]){
        
        
        yValue = 0;//statusBarHeight;
        xValue = 20;
    }
    

    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UISearchBar *mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(xValue, yValue, self.view.frame.size.width-xValue*2, 45)];
	//[mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:kBookAll, kBookOldTestament, kBookNewTestament, nil]];
	mySearchBar.delegate = self;
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if([UIDeviceHardware isOS7Device]){
        
        mySearchBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        
        if(isdark)
        {
            [mySearchBar setBarTintColor:[UIColor blackColor]];
            [mySearchBar setBackgroundColor:[UIColor blackColor]];//jijo
        }else{
            [mySearchBar setBarTintColor:[UIColor whiteColor]];
            [mySearchBar setBackgroundColor:[UIColor whiteColor]];//jijo
        }
        mySearchBar.showsCancelButton = NO;
        mySearchBar.frame = CGRectMake(0, yValue, self.view.frame.size.width-70, 45);
        
        
        
        //+rollyValue += 60;
        
    }else{
        
        mySearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        mySearchBar.showsCancelButton = YES;
       
        if (isdark) {
            [mySearchBar setBarStyle:UIBarStyleBlack];
            
        }else{
            [mySearchBar setBarStyle:UIBarStyleDefault];
        }
        
        yValue += 45;
       
    }
    
    
    [self.view setBackgroundColor:mySearchBar.backgroundColor];
    
    
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.searchBarr = mySearchBar;
        
    //self.view.backgroundColor = [UIColor whiteColor];
	//[mySearchBar sizeToFit];
    
    if([UIDeviceHardware isOS7Device]){
        self.navigationItem.titleView = mySearchBar;
    }else{
        [self.view addSubview:mySearchBar];
    }
	
	
   
    
    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
    
    
    self.primaryL = kLangPrimary;
        
    if(dictPref !=nil ){
        
        self.primaryL = [dictPref valueForKey:@"primaryLanguage"];
               
    }
    
    
    bool isCustomkb = [[NSUserDefaults standardUserDefaults] boolForKey:kCustomKB];
    self.labelSearch = [[UILabel alloc] initWithFrame:CGRectMake(0, yValue, self.view.frame.size.width, 45)];
    self.labelSearch.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    if([self.primaryL isEqualToString:kLangPrimary]){//!isCustomkb &&
        
        
        self.labelSearch.textAlignment = NSTextAlignmentCenter;
        
        if([UIDeviceHardware isOS7Device]){
            self.labelSearch.textColor = [UIColor blackColor];
            self.labelSearch.backgroundColor = [UIColor whiteColor];
            
            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.labelSearch.frame.size.height-1, self.labelSearch.frame.size.width, 1)];
            borderView.backgroundColor = [UIColor lightGrayColor];
            borderView.tag = kTagSearchLabelBorder;   //+20261120 recoloured in mb_applySearchAppearance
            borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
            [self.labelSearch addSubview:borderView];
            
        }else{
            self.labelSearch.textColor = [UIColor whiteColor];
            self.labelSearch.backgroundColor = [UIColor blackColor];
            
        }
        self.labelSearch.numberOfLines = 2;
        //self.labelSearch.textAlignment = UITextAlignmentCenter;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            self.labelSearch.frame = CGRectMake(0, 0+yValue, self.view.frame.size.width, 45);
            
        }
        
        [self.view addSubview:self.labelSearch];
       
        yValue += 45;
    }else{
        
        if([UIDeviceHardware isOS7Device]){
            yValue = 0;
        }
    }
    
    //(@"yValue = %f", yValue);
    
    //+20261120 Redesign: results as rounded cards grouped by book (was a plain full-width list).
    self.tableViewSearch = [[UITableView alloc] initWithFrame:CGRectMake(0, yValue, self.view.frame.size.width, self.view.frame.size.height-yValue) style:UITableViewStyleInsetGrouped];
    self.tableViewSearch.rowHeight = UITableViewAutomaticDimension;   // Malayalam verses size to their text (no clipping)
    self.tableViewSearch.estimatedRowHeight = 88.0;
    self.tableViewSearch.preservesSuperviewLayoutMargins = NO;
    self.tableViewSearch.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableViewSearch.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    self.tableViewSearch.delegate = self;
    self.tableViewSearch.dataSource = self;
    //+20150217
   
    if (isdark ){
        self.tableViewSearch.backgroundColor = [UIColor blackColor];
        self.tableViewSearch.backgroundView.backgroundColor = [UIColor blackColor];
        self.tableViewSearch.sectionIndexColor = [UIColor defaultWindowColor];
        if ([UIDeviceHardware isOS7Device]) self.tableViewSearch.sectionIndexBackgroundColor = [UIColor blackColor];
        self.tableViewSearch.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
        
        
    }else{
        self.tableViewSearch.backgroundColor = [UIColor whiteColor];
        self.tableViewSearch.backgroundView.backgroundColor = [UIColor whiteColor];
        self.tableViewSearch.sectionIndexColor = [UIColor defaultWindowColor];
        if ([UIDeviceHardware isOS7Device])  self.tableViewSearch.sectionIndexBackgroundColor = [UIColor whiteColor];
        self.tableViewSearch.separatorColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    }
    
    
    self.tableViewSearch.allowsMultipleSelection = YES;
    
     /*if([self.primaryL isEqualToString:kLangMalayalam]){
         
         UIButton *buttonHelp = [UIButton buttonWithType:UIButtonTypeCustom];
         UIImage *imgHelp = [UIImage imageNamed:@"help.png"];
         [buttonHelp setImage:imgHelp forState:UIControlStateNormal];
         //[buttonHelp setTitle:@"T" forState:UIControlStateNormal];
         buttonHelp.frame = CGRectMake(self.labelSearch.frame.size.width - 30, self.labelSearch.frame.size.height-30, 20, 20);
         [buttonHelp addTarget:self action:@selector(showHelp:) forControlEvents:UIControlEventTouchUpInside];
         
         buttonHelp.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;UIViewAutoresizingFlexibleBottomMargin
         
         [self.labelSearch addSubview:buttonHelp];

         self.labelSearch.userInteractionEnabled = NO;
     }*/
         
    
         [self.view addSubview:tableViewSearch];
  
	
	//[self.searchDisplayController.searchResultsTableView reloadData];
	//self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
    
    if(![UIDeviceHardware isOS7Device]){
    [self performSelector:@selector(enableCancelButton:) withObject:self.searchBarr afterDelay:0.5];
    }
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    
    
	CGRect cgRect = self.tableViewSearch.frame;
	CGSize cgSize = cgRect.size;
    self.activityView.frame=CGRectMake(cgSize.width/2 - 25, cgSize.height/3, 50, 50);
    //self.activityView.frame=CGRectMake(cgSize.width/2, cgSize.height/3, 50, 50);
	
	self.activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	self.activityView.tag  = 1;
    
    [self.view addSubview:self.activityView];
    
    self.activityView.hidesWhenStopped = YES;

    //+20261120 Empty / no-results message, shown behind the results.
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stateLabel.numberOfLines = 0;
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.adjustsFontForContentSizeCategory = YES;
    self.mbStateLabel = stateLabel;
    self.tableViewSearch.backgroundView = stateLabel;

    [self mb_applySearchAppearance];
}

//+20261120 iPad: a centred, readable result column and a search field of comfortable width.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.bounds.size.width;
    CGFloat side = 20.0;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular && width > kSearchMaxContentWidth + 2 * side) {
        side = floor((width - kSearchMaxContentWidth) / 2.0);
    } else if (width < 375.0) {
        side = 16.0;
    }
    UIEdgeInsets margins = self.tableViewSearch.layoutMargins;
    if (fabs(margins.left - side) > 0.5 || fabs(margins.right - side) > 0.5) {
        self.tableViewSearch.layoutMargins = UIEdgeInsetsMake(margins.top, side, margins.bottom, side);
    }
    if ([UIDeviceHardware isOS7Device] && self.navigationItem.titleView == self.searchBarr) {
        CGRect frame = self.searchBarr.frame;
        CGFloat fieldWidth = MIN(width - 70, kSearchMaxFieldWidth);
        if (fabs(frame.size.width - fieldWidth) > 0.5) {
            frame.size.width = fieldWidth;
            self.searchBarr.frame = frame;
        }
    }
    self.mbStateLabel.preferredMaxLayoutWidth = MIN(width - 64.0, 420.0);
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
    if(![UIDeviceHardware isOS7Device]){
    self.navigationController.navigationBarHidden = YES;
    }
    //+20261120 The reading screen reuses this controller, so viewDidLoad runs once: re-apply the look each time
    // so a Night mode or theme change made since is picked up.
    [self mb_applySearchAppearance];
    
    /*
	 Hide the search bar
	 */
	//[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:NO];
	
	
	//NSIndexPath *tableSelection = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
	//[self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:tableSelection animated:NO];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!isFirstTime){
        
        isFirstTime = YES;
        
    }
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //self.navigationController.toolbarHidden = YES;
    if(searchBarr.text == nil || [searchBarr.text isEqualToString:@""]){
        [searchBarr becomeFirstResponder];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    //[self.searchDisplayController.searchResultsTableView reloadData];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
            
            
            
            
            
           // [self.searchDisplayController.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:kBookAll, @"Old", @"New", nil]];
            //self.labelSearch.frame = CGRectMake(2, 0, 480-2, 100);
            
            
            
        }else{
            
            
            
           // self.labelSearch.frame = CGRectMake(2, 0, 320-2, 160);
          //  [self.searchDisplayController.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:kBookAll, kBookOldTestament, kBookNewTestament, nil]];
            
            
        }
    }
    
	    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //+20261120 Self-sizing: the old fixed-width estimate no longer matched the inset cards and could clip
    // Malayalam lines. The cell's label wraps to its real width.
    return UITableViewAutomaticDimension;
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
    NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
	   
    MBLog(@"dictVerse = %@", dictVerse);
    //Book *selectBook = [dictVerse valueForKey:@"book_details"];
      
    NSNumber *verseidNum = [NSNumber numberWithInteger:[[dictVerse valueForKey:@"verse_id"] integerValue]];
    NSMutableDictionary *dictVerseid = [NSMutableDictionary dictionaryWithObject:verseidNum forKey:@"verse_id"];
    
     MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:dictVerseid];
    
    
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
                
        self.detailViewController.selectedBook = [dictVerse valueForKey:@"book_details"];
        self.detailViewController.chapterId = [[dictVerse valueForKey:@"chapter"] integerValue];
        [self.detailViewController configureView];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else{
        
        
        MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Book *selectBook = [dictVerse valueForKey:@"book_details"];
        
        /**set select book*** +20121006 **/
        NSUInteger bookindex= selectBook.bookId;
        NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:0];//+20140929
        MBLog(@"123");
        [dict setObject:[NSNumber numberWithInteger:bookindex-1] forKey:bmBookSection];//+20121017
        
        
        [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:[[dictVerse valueForKey:@"chapter"] integerValue]]];
        
        
        NSMutableDictionary *dictthird = [NSMutableDictionary dictionaryWithCapacity:1];
               
        NSNumber *verseid =  [NSNumber numberWithInteger:[[dictVerse valueForKey:@"verse_id"] integerValue]];
        [dictthird setValue:verseid forKey:@"verse_id"];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        [appDelegate openVerseForiPadSavedLocation];
    }
    
    
    	
}
-(void)copy:(id)sender{
    
    NSArray *arraySelectedIndesPath = [self.tableViewSearch indexPathsForSelectedRows];
    
    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
    NSString *secondaryL = kLangNone;
    if(dictPref !=nil ){
        secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
    }
    
    
    NSMutableString *verseStr = [[NSMutableString alloc] init ];
    //(@"arrayResults = %@", arrayResults);
    
    
   // NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
    //[verseStr appendFormat:@"%@", self.selectedBook.shortName];
    //[verseStr appendFormat:@" %i", self.chapterId];
    
    NSUInteger countV = [arraySelectedIndesPath count];
    
    if(countV == 0){
        
        
    }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
        
        NSIndexPath *indexPath = [arraySelectedIndesPath objectAtIndex:0];
        
        NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        
        [verseStr appendFormat:@"%@ %@\n", [[arrayResults objectAtIndex:indexPath.section] objectForKey:@"headerTitle"], [dictVerse valueForKey:@"verse_text"]];
        
    }else{
        
        [verseStr appendFormat:@"\n"];
        for(NSUInteger i=0; i<countV ; i++ ){
            
            NSIndexPath *indexPath = [arraySelectedIndesPath objectAtIndex:i];
            
            NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
            
            [verseStr appendFormat:@"%@ %@\n", [[arrayResults objectAtIndex:indexPath.section] objectForKey:@"headerTitle"], [dictVerse valueForKey:@"verse_text"]];
        }
    }
    MBLog(@"verseStr = %@", verseStr);
    
    [[UIPasteboard generalPasteboard] setString:verseStr];
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if(![searchBarr isFirstResponder]){
        if (action == @selector(copy:)){
             return YES;
        }
        
    }
    return NO;
}
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(![searchBarr isFirstResponder]){
        
        
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        
        CGRect selectionRect = cell.frame;//CGRectMake(currentSelection.x, currentSelection.y, SIDE, SIDE);
        
        [theMenu setTargetRect:selectionRect inView:tableView];
        [theMenu setMenuVisible:YES animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [searchBarr resignFirstResponder];
        [self.tableViewSearch becomeFirstResponder];
        
    }
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

   
    return [arrayResults count];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.// 
    //return [arrayResults count];;
   
    return [[[arrayResults objectAtIndex:section] objectForKey:@"rowValues"] count] ;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    return [[arrayResults objectAtIndex:section] objectForKey:@"headerTitle"];
}
/*
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //http://stackoverflow.com/questions/2955354/showing-custom-menu-on-selection-in-uiwebview-in-iphone
    if (webView.superview != nil && ![urlTextField isFirstResponder]) {
        if (action == @selector(customAction1:) || action == @selector(customAction2:)) {
            return YES;
        }
    }
    ////(@"clicked me action...sender = %@", sender);
    return NO;//[super canPerformAction:action withSender:sender];
}
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    /*VerseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[VerseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    NSString *versee = [dictVerse valueForKey:@"verse_html"];
    
    cell.tag = indexPath.row;
    
    NSLog(@"ssss = %@", versee);
    
    [cell.webView loadHTMLString:versee  baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
    
    cell.verseText = [dictVerse valueForKey:@"verse_text"];
    // Configure the cell...
    */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIFont *cellFont = [UIFont fontWithName:kFontName size:FONT_SIZE];
        cell.textLabel.font = cellFont;
    }
    //+20261120 Redesign: card rows with the app's own Night mode colours (via this screen's override), selected
    // rows (for Copy) tinted with the theme colour, and the searched text highlighted.
    cell.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.highlightedTextColor = [UIColor labelColor];
    cell.tintColor = [UIColor defaultWindowColor];   // detail (open verse) button
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = [[UIColor defaultWindowColor] colorWithAlphaComponent:0.16];
    cell.selectedBackgroundView = selectedBackground;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    NSDictionary *dictVerse = [[[arrayResults objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.textLabel.numberOfLines = 0;
    UIFont *cellFont = [UIFont fontWithName:kFontName size:FONT_SIZE] ?: [UIFont systemFontOfSize:FONT_SIZE];
    cell.textLabel.font = cellFont;
    cell.textLabel.attributedText = [self mb_attributedVerse:[dictVerse valueForKey:@"verse_text"] font:cellFont];
    cell.accessibilityLabel = [dictVerse valueForKey:@"verse_text"];
    
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [arrayResults valueForKey:@"headerTitleIndex"];
    
}
/*
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    NSDictionary *dict = [self.bVerses objectAtIndex:index];
    
    NSString *divid = [NSString stringWithFormat:@"Verse-%@",[dict valueForKey:@"verseid"]];
    
    NSMutableString *command = [NSMutableString stringWithFormat:@"scrollToDivId('%@", divid];
    
    [command appendString:@"')"];
    
    //(@"command = %@", command);
    
    [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    
    
    return [self.bVersesIndexArray indexOfObject:title];
    
    
    
    
}
 */
#pragma mark UISearchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([arrayResults count] > 0){
        self.arrayResults = nil;
        [tableViewSearch reloadData];
    }
    self.mbHasSearched = NO;            //+20261120
    [self mb_updateStateView];          //+20261120
    
    BOOL isCustomkb = [[NSUserDefaults standardUserDefaults] boolForKey:kCustomKB];
    
    
    if(!isCustomkb && [self.primaryL isEqualToString:kLangPrimary]){
        
        long flags = FL_DEFAULT;
        char *output = mozhi_unicode_parse([searchText UTF8String], flags);
        NSString *outputStr = [NSString stringWithUTF8String:output];
        
        
        labelSearch.text = outputStr;
    }else{
        
        labelSearch.text = searchText;
    }
       
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    if([@"mbediton***" isEqualToString:searchBar.text]){
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setValue:@"mbediton***" forKey:@"easteregg"];
        [def synchronize];
         
        return;
    }else if([@"mbeditoff***" isEqualToString:searchBar.text]){
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def removeObjectForKey:@"easteregg"];
        [def synchronize];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"queries"];
        BOOL isDire = YES;
        
        if(![fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDire]){
            
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        NSString *localStringPath = [documentsDirectory stringByAppendingPathComponent:@"myedit.sql"];
        
        if([fileManager fileExistsAtPath:localStringPath]){
            
            [fileManager removeItemAtPath:localStringPath error:NULL];
        }
        
        return;
    }
    
    if([arrayResults count] > 0){
        
        self.arrayResults = nil;
        [tableViewSearch reloadData];
        
        
    }
    if([self.primaryL isEqualToString:kLangPrimary]){
        
        long flags = FL_DEFAULT;
        char *output = mozhi_unicode_parse([searchBar.text UTF8String], flags);
        NSString *outputStr = [NSString stringWithUTF8String:output];
        
        
        labelSearch.text = outputStr;
    }else{
        
        labelSearch.text = searchBar.text;
    }
    
    
    //+20261120 Remember exactly what is searched for (the same text BibleDao receives), to highlight it.
    self.mbHighlightQuery = [self.primaryL isEqualToString:kLangPrimary] ? labelSearch.text : searchBar.text;
    self.mbHasSearched = NO;
    self.mbStateLabel.hidden = YES;
    [self.activityView startAnimating];
    [self performSelector:@selector(showResult) withObject:nil afterDelay:.1];
    
    [self.searchBarr resignFirstResponder];
    if([UIDeviceHardware isOS7Device]){//+20131114
        [self becomeFirstResponder];//+20101003
    }
    
}
- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    UIImage *selectedBackgroundImage = [self imageFromColor:[UIColor whiteColor]];
    //UIImage *normalBackgroundImage = [self imageFromColor:[UIColor whiteColor]];
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    [all setTitle:@"All" forState:UIControlStateNormal];
    [all setTitleColor:[UIColor defaultWindowColor] forState:UIControlStateSelected];
    [all setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    all.tag = 0;
    [all addTarget:self action:@selector(segementClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.allBtn = all;
    CGRect frame = all.frame;
    frame.size = CGSizeMake(50, 38);
    all.frame = frame;
    all.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    //all.frame = CGRectMake(1, 1, 50, 38);
    
    [all setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [all setBackgroundImage:nil forState:UIControlStateNormal];
    
    

    
    UIButton *old = [UIButton buttonWithType:UIButtonTypeCustom];
    [old setTitle:@"Old" forState:UIControlStateNormal];
    [old setTitleColor:[UIColor defaultWindowColor] forState:UIControlStateSelected];
    [old setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    old.tag = 1;
    [old addTarget:self action:@selector(segementClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.oldBtn = old;
    
    CGRect frame2 = old.frame;
    frame2.size = CGSizeMake(50, 38);
    old.frame = frame2;
    old.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    //old.frame = CGRectMake(52, 1, 50, 38);
    
    [old setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [old setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    
    UIButton *new = [UIButton buttonWithType:UIButtonTypeCustom];
    [new setTitle:@"New" forState:UIControlStateNormal];
    [new setTitleColor:[UIColor defaultWindowColor] forState:UIControlStateSelected];
    [new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    new.tag = 2;
    [new addTarget:self action:@selector(segementClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.newwBtn = new;
    
    CGRect frame3 = new.frame;
    frame3.size = CGSizeMake(50, 38);
    new.frame = frame3;
    new.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    //new.frame = CGRectMake(104, 1, 50, 38);
    
    [new setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [new setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    
    
    UIButton *book = [UIButton buttonWithType:UIButtonTypeCustom];
    [book setTitle:selectedBook.shortName forState:UIControlStateNormal];
    [book setTitleColor:[UIColor defaultWindowColor] forState:UIControlStateSelected];
    [book setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    book.tag = 3;
    [book addTarget:self action:@selector(segementClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.bookBtn = book;
    book.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    
    
    CGRect frame4 = book.frame;
    frame4.size.height = 38;
    book.frame = frame4;
    //book.frame = CGRectMake(156, 1, self.view.frame.size.width - 158 - 20, 38);
    
    [book setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
    [book setBackgroundImage:nil forState:UIControlStateNormal];
    
    //UIBarButtonItem *flexx1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    //+20261120 Scope bar: a plain view instead of the UIToolbar (see MBSearchScopeBar). Same four buttons, same
    // properties, same segementClicked: and scope values; only the container and the colours changed.
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIUserInterfaceStyle style = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    UITraitCollection *traits = [UITraitCollection traitCollectionWithUserInterfaceStyle:style];

    // Colours: bar #F2F2F7 / #1C1C1E, unselected chip #FFFFFF / #2C2C2E with #000000 / #FFFFFF titles,
    // selected chip in the theme colour with white or black text, whichever reads better on it.
    UIColor *barColor = isdark ? [UIColor colorWithRed:28/255.0 green:28/255.0 blue:30/255.0 alpha:1.0]
                               : [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0];
    UIColor *chipColor = isdark ? [UIColor colorWithRed:44/255.0 green:44/255.0 blue:46/255.0 alpha:1.0] : [UIColor whiteColor];
    UIColor *chipTitleColor = isdark ? [UIColor whiteColor] : [UIColor blackColor];
    UIColor *accent = [UIColor defaultWindowColor];
    UIColor *selectedTitleColor = [self mb_scopeTitleColorOnColor:accent];
    UIImage *chipImage = [self imageFromColor:chipColor];
    UIImage *accentImage = [self imageFromColor:accent];

    MBSearchScopeBar *scopeBar = [[MBSearchScopeBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 52.0)];
    scopeBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scopeBar.overrideUserInterfaceStyle = style;
    scopeBar.backgroundColor = barColor;
    UIView *hairline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scopeBar.bounds.size.width, 1.0 / MAX(1.0, self.view.traitCollection.displayScale))];
    hairline.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    hairline.backgroundColor = [[UIColor separatorColor] resolvedColorWithTraitCollection:traits];
    [scopeBar addSubview:hairline];

    for (UIButton *scopeButton in @[all, old, new, book]) {
        [scopeButton setBackgroundImage:chipImage forState:UIControlStateNormal];
        [scopeButton setBackgroundImage:accentImage forState:UIControlStateSelected];
        [scopeButton setBackgroundImage:accentImage forState:UIControlStateSelected | UIControlStateHighlighted];
        [scopeButton setTitleColor:chipTitleColor forState:UIControlStateNormal];
        [scopeButton setTitleColor:selectedTitleColor forState:UIControlStateSelected];
        [scopeButton setTitleColor:selectedTitleColor forState:UIControlStateSelected | UIControlStateHighlighted];
        scopeButton.layer.cornerRadius = 10.0;
        scopeButton.layer.cornerCurve = kCACornerCurveContinuous;
        scopeButton.clipsToBounds = YES;
        scopeButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        scopeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        scopeButton.titleLabel.minimumScaleFactor = 0.75;
        scopeButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        scopeButton.accessibilityTraits |= UIAccessibilityTraitButton;
    }

    // Four equal buttons, 44 pt tall (at least 44 pt wide on every iPhone), centred and capped at 560 pt on iPad.
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[all, old, new, book]];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.distribution = UIStackViewDistributionFillEqually;
    stack.spacing = 8.0;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [scopeBar addSubview:stack];
    NSLayoutConstraint *preferredWidth = [stack.widthAnchor constraintEqualToAnchor:scopeBar.widthAnchor constant:-24.0];
    preferredWidth.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:scopeBar.topAnchor constant:4.0],
        [stack.heightAnchor constraintEqualToConstant:44.0],
        [stack.centerXAnchor constraintEqualToAnchor:scopeBar.centerXAnchor],
        [stack.leadingAnchor constraintGreaterThanOrEqualToAnchor:scopeBar.safeAreaLayoutGuide.leadingAnchor constant:12.0],
        [stack.trailingAnchor constraintLessThanOrEqualToAnchor:scopeBar.safeAreaLayoutGuide.trailingAnchor constant:-12.0],
        [stack.widthAnchor constraintLessThanOrEqualToConstant:560.0],
        preferredWidth
    ]];

    searchBar.inputAccessoryView = scopeBar;
    [searchBar reloadInputViews];

    if (self.scopeValue == 0) {
        all.selected = true;
    } else if (self.scopeValue == 1) {
        old.selected = true;
    } else if (self.scopeValue == 2) {
        new.selected = true;
    } else if (self.scopeValue == 3) {
        book.selected = true;
    }
    
    
//    segmentControl.selectedSegmentIndex = self.scopeValue;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.navigationController popViewControllerAnimated:YES];
    /*[self.searchDisplayController setActive:NO];
    
    
    for (UIView *subview in self.searchDisplayController.searchBar.subviews) { 
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) { 
            
            UITextField *fieldSearch = (UITextField *)subview;
            UILabel *lblCount = (UILabel *)[fieldSearch viewWithTag:tagLabelCount];
            [lblCount removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    */
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    /*self.arrayResults = nil;
    
    [self.tableViewSearch setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
    [self.tableViewSearch setRowHeight:1200];
    [self.tableViewSearch setScrollEnabled:NO];
    [self.tableViewSearch reloadData];
    //if([self.primaryL isEqualToString:kLangMalayalam]){
        [self.tableViewSearch addSubview:labelSearch];
    //}
    
    for (UIView *subview in self.searchDisplayController.searchBar.subviews) { 
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) { 
            
            UITextField *fieldSearch = (UITextField *)subview;
            UILabel *lblCount = (UILabel *)[fieldSearch viewWithTag:tagLabelCount];
            [lblCount removeFromSuperview];
        }
    }*/
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    if([UIDeviceHardware isOS7Device]){//+20131114
        [self becomeFirstResponder];//+20101003
    }
    if(![UIDeviceHardware isOS7Device]){
        [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.5];
    }
    
}


#pragma mark @selector method
- (void)enableCancelButton:(UISearchBar *)aSearchBar {
    for (id subview in [aSearchBar subviews]) {
        
        MBLog(@"klydiaaa %@", NSStringFromClass([subview class]));
        for (id subview1 in [subview subviews]) {
            
            MBLog(@"klydiaaa 11 %@", NSStringFromClass([subview1 class]));
        }
        //if ([subview isKindOfClass:[UIControl class]]) {
            
            MBLog(@"enabling..");
            [subview setEnabled:TRUE];
        //}
    }
}

- (void) segementClicked:(UIButton *)sender{
    
    allBtn.selected = false;
    oldBtn.selected = false;
    newwBtn.selected = false;
    bookBtn.selected = false;
    
    sender.selected = true;
    self.scopeValue = sender.tag;
}
- (void) cancelClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) showHelp:(id)sender{
    //(@"clicked help");
    /*WebViewController *webViewCtrlr = [[WebViewController alloc] init];
    webViewCtrlr.requestURL = [[NSBundle mainBundle] pathForResource:@"lipi" ofType:@"png"];
    [self.navigationController pushViewController:webViewCtrlr animated:YES];*/
    
    /*WebViewController *webViewCtrlr = [[WebViewController alloc] init];
    
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
}

#pragma mark -
#pragma mark private method


-(void)threadStartAnimating
{
   
    [self.activityView startAnimating];
}
-(void)threadStopAnimating
{
    [self.activityView stopAnimating];
    self.mbHasSearched = YES;           //+20261120 results are already set; show the no-results message if none
    [self mb_updateStateView];          //+20261120
    
    //[self.activityView removeFromSuperview];
    
    
    [self.tableViewSearch reloadData];
   
}

- (void)showIndicator{
    
    
    [self performSelectorOnMainThread:@selector(threadStartAnimating) withObject:nil waitUntilDone:NO];
    
}
- (void) showResult{
    
    [self performSelectorOnMainThread:@selector(showResultset) withObject:nil waitUntilDone:NO];
    
    
}
- (void) showResultset{
    
   
    [self filterContentForSearchText:labelSearch.text scope:self.scopeValue AndBookid:self.selectedBook.bookId];
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope AndBookid:(int)bookid
{
    
    
    
    
	BibleDao *bdao = [[BibleDao alloc] init];
    
    
    self.arrayResults = nil;
    if([self.primaryL isEqualToString:kLangPrimary]){
        self.arrayResults = [bdao getSerachResultWithText:labelSearch.text InScope:scope AndBookId:bookid];
    }else{
        self.arrayResults = [bdao getSerachResultWithText:searchText InScope:scope AndBookId:bookid];
    }
    
    //(@"arrayResults = %@", arrayResults);
    //[labelSearch removeFromSuperview];
    
    

    NSUInteger cont = [self getResultDataCount];
    NSString *countStr = [NSString stringWithFormat:@"%lu", (unsigned long)cont];
    
    if([UIDeviceHardware isOS7Device]){
        
        NSString *existStr = self.labelSearch.text;
        self.labelSearch.text = [NSString stringWithFormat:@"%@ matches - %@", countStr, existStr];
    }else{
    
    for (UIView *subview in self.searchBarr.subviews) {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)]) { 

            UITextField *fieldSearch = (UITextField *)subview;
            
            UILabel *lblCount = (UILabel *)[fieldSearch viewWithTag:tagLabelCount];
            if(lblCount == nil){
                
                lblCount = [[UILabel alloc] init];
                lblCount.backgroundColor = [UIColor clearColor];
                lblCount.textColor = [UIColor grayColor];
                lblCount.tag = tagLabelCount;
            }else{
                [lblCount removeFromSuperview];
            }
            
            lblCount.text = countStr;
            CGSize sizeCount = [countStr sizeWithFont:lblCount.font];
            
            lblCount.frame = CGRectMake(fieldSearch.frame.size.width - sizeCount.width - 28, 0, sizeCount.width, fieldSearch.frame.size.height);
            [fieldSearch addSubview:lblCount];
            break;
        } 
    } 
    }
    
    [self threadStopAnimating];
    //UIActivityIndicatorView *tempActivityView = (UIActivityIndicatorView *)[self.searchDisplayController.searchResultsTableView viewWithTag:1];
	
    //[tempActivityView stopAnimating];
	//[tempActivityView removeFromSuperview];
}
-(NSUInteger) getResultDataCount{
	
	NSUInteger sum = 0;
	for(NSDictionary *dict in arrayResults){
		
		sum += [[dict objectForKey:@"rowValues"] count];
	}
	return sum;
}



#pragma mark - Appearance (+20261120 Search redesign)
//
// Presentation only. Night or Light follows the app's own Night mode (kNightTime), as on the other screens;
// the accent is the existing theme colour, [UIColor defaultWindowColor]. No search logic or data changes.

- (void) mb_applySearchAppearance{

    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIUserInterfaceStyle style = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    UITraitCollection *traits = [UITraitCollection traitCollectionWithUserInterfaceStyle:style];
    UIColor *accent = [UIColor defaultWindowColor];
    UIColor *background = [[UIColor systemGroupedBackgroundColor] resolvedColorWithTraitCollection:traits];
    UIColor *separator = [[UIColor separatorColor] resolvedColorWithTraitCollection:traits];

    self.overrideUserInterfaceStyle = style;
    self.view.backgroundColor = background;

    // Navigation bar: same surface as the screen, so bar, search field and results read as one page.
    // The reading screen re-applies its own bar appearance in its viewWillAppear: when it reappears.
    if (self.navigationController != nil) {
        UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
        [barAppearance configureWithOpaqueBackground];
        barAppearance.backgroundColor = background;
        barAppearance.shadowColor = separator;
        barAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [[UIColor labelColor] resolvedColorWithTraitCollection:traits]};
        UINavigationBarAppearance *edgeAppearance = [barAppearance copy];
        edgeAppearance.shadowColor = [UIColor clearColor];
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.standardAppearance = barAppearance;
        navigationBar.compactAppearance = barAppearance;
        navigationBar.scrollEdgeAppearance = edgeAppearance;
        navigationBar.compactScrollEdgeAppearance = edgeAppearance;
    }

    // Search field: a rounded, softly raised field (white with a hairline on grey in Light, dark grey on
    // black in Night), magnifier and placeholder in secondary colours, cursor in the theme colour.
    UISearchBar *searchBar = self.searchBarr;
    searchBar.overrideUserInterfaceStyle = style;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.barTintColor = nil;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.tintColor = accent;
    UITextField *field = searchBar.searchTextField;
    field.backgroundColor = isdark ? [UIColor colorWithWhite:0.17 alpha:1.0] : [UIColor whiteColor];
    field.textColor = [[UIColor labelColor] resolvedColorWithTraitCollection:traits];
    field.font = [UIFont systemFontOfSize:17];
    field.layer.cornerRadius = 10.0;
    field.layer.cornerCurve = kCACornerCurveContinuous;
    field.layer.borderWidth = isdark ? 0.0 : 0.5;
    field.layer.borderColor = separator.CGColor;
    field.clipsToBounds = YES;
    field.keyboardAppearance = isdark ? UIKeyboardAppearanceDark : UIKeyboardAppearanceLight;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.leftView.tintColor = [[UIColor secondaryLabelColor] resolvedColorWithTraitCollection:traits];
    field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", @"")
                                                                  attributes:@{NSForegroundColorAttributeName: [[UIColor placeholderTextColor] resolvedColorWithTraitCollection:traits]}];

    // Malayalam preview / match-count band under the bar (shown when Malayalam is the primary language).
    UILabel *band = self.labelSearch;
    band.backgroundColor = background;
    band.textColor = [[UIColor labelColor] resolvedColorWithTraitCollection:traits];
    band.font = [UIFont fontWithName:kFontName size:17] ?: [UIFont systemFontOfSize:17];
    [band viewWithTag:kTagSearchLabelBorder].backgroundColor = separator;

    // Results.
    UITableView *table = self.tableViewSearch;
    table.backgroundColor = background;
    table.separatorColor = [UIColor separatorColor];
    table.sectionIndexColor = accent;
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];

    self.activityView.color = [[UIColor secondaryLabelColor] resolvedColorWithTraitCollection:traits];

    [self mb_updateStateView];
    [table reloadData];
}

// White text when it reaches 3.5:1 on the colour (WCAG contrast), otherwise black: white on red, green (Light),
// blue, purple and brown; black on cyan, yellow, magenta, orange and the Night palette's bright green.
- (UIColor *) mb_scopeTitleColorOnColor:(UIColor *)color{

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
    CGFloat whiteContrast = 1.05 / (luminance + 0.05);
    return (whiteContrast >= 3.5) ? [UIColor whiteColor] : [UIColor blackColor];
}

// Empty and no-results messages behind the results (hidden while results or the spinner are showing).
- (void) mb_updateStateView{

    UILabel *label = self.mbStateLabel;
    if (label == nil) return;
    if ([self getResultDataCount] > 0 || self.activityView.isAnimating) {
        label.hidden = YES;
        return;
    }
    NSString *title;
    NSString *detail;
    if (self.mbHasSearched) {
        title = NSLocalizedString(@"No matches found", @"");
        detail = NSLocalizedString(@"Try a different word, or search All instead of one book.", @"");
    } else {
        title = NSLocalizedString(@"Search the Bible", @"");
        detail = NSLocalizedString(@"Type a word, then tap Search.", @"");
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.paragraphSpacing = 6.0;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[title stringByAppendingString:@"\n"]
                                                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                                                                                          NSForegroundColorAttributeName: [UIColor secondaryLabelColor],
                                                                                          NSParagraphStyleAttributeName: paragraph}];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:detail
                                                                 attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                                                                              NSForegroundColorAttributeName: [UIColor tertiaryLabelColor],
                                                                              NSParagraphStyleAttributeName: paragraph}]];
    label.attributedText = text;
    label.hidden = NO;
}

// The verse with every occurrence of the searched text highlighted (the same substring match the search uses).
- (NSAttributedString *) mb_attributedVerse:(NSString *)verse font:(UIFont *)font{

    if (verse == nil) verse = @"";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:verse
                                                                             attributes:@{NSFontAttributeName: font,
                                                                                          NSForegroundColorAttributeName: [UIColor labelColor]}];
    NSString *query = [self.mbHighlightQuery stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (query.length == 0 || verse.length == 0) return text;

    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *mark = [[UIColor defaultWindowColor] colorWithAlphaComponent:(isdark ? 0.38 : 0.22)];
    NSRange searchRange = NSMakeRange(0, verse.length);
    while (searchRange.length > 0) {
        NSRange found = [verse rangeOfString:query options:NSCaseInsensitiveSearch range:searchRange];
        if (found.location == NSNotFound || found.length == 0) break;
        [text addAttribute:NSBackgroundColorAttributeName value:mark range:found];
        NSUInteger next = NSMaxRange(found);
        searchRange = NSMakeRange(next, verse.length - next);
    }
    return text;
}

@end
