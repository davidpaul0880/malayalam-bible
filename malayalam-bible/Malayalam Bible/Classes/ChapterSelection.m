//
//  ChapterSelection.m
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "MalayalamBibleAppDelegate.h"
#import "ChapterSelection.h"
#import "BibleDao.h"
#import "UIDeviceHardware.h"
#import "MBConstants.h"

#define FONT_SIZE 17.0f


@interface ChapterSelection (Private)

- (void) openPageWithChapter:(NSUInteger)chapter;
- (void) mb_applyNightModeStyle;   //+20261123

@end

@implementation ChapterSelection

@synthesize scrollViewBar, lblChapter;
@synthesize selectedBook = _selectedBook;
@synthesize detailViewController = _detailViewController;
@synthesize delegate = _delegate;
@synthesize fromMaster = _fromMaster;
@synthesize selectedChapter = _selectedChapter;
@synthesize indexPath;
const CGFloat tagWidthOffset = 10.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.detailViewController = [[MalayalamBibleDetailViewController alloc] init];  
        
        scrollViewBar = [[UIScrollView alloc] init];
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
-(void) configureView:(BOOL)isFromMaster{
    
    

    self.fromMaster = isFromMaster;
    
    //+jjself.title = self.selectedBook.shortName;
    
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    CGRect r = self.navigationController.navigationBar.frame;
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, r.size.width - 120, r.size.height)];
    lblTitle.text = self.selectedBook.shortName;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    if (isdark) {
        
        
        if ([UIDeviceHardware isOS7Device]) {
            lblTitle.textColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }else{
            lblTitle.textColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            
        }
    }else{
       
        if ([UIDeviceHardware isOS7Device]) {
             lblTitle.textColor = [UIColor blackColor];
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        }else{
            lblTitle.textColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            
        }
    }
    lblTitle.textColor = [UIColor labelColor];//+20261123 follows the screen's Light / Night style (was white on a white bar in Night mode)
    self.navigationItem.titleView = lblTitle;
    
    /** Clear Screen
    NSArray *existingBtns = [scrollViewBar subviews];
    int i = 0;
    for(UIView *sView in existingBtns){
        if(i++ > 0) {
            [sView removeFromSuperview];
        }
    }
    
    [self.scrollViewBar removeFromSuperview];
    *****/
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];//+20261123 white in Light, black in Night (via overrideUserInterfaceStyle)
    [scrollViewBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    NSInteger yOffset = 15;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        self.lblChapter = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
        
        lblChapter.text = [BibleDao getTitleChapterButton];
        lblChapter.textColor = [UIColor secondaryLabelColor];//+20261123 readable heading in both modes
        lblChapter.backgroundColor = [UIColor clearColor];
        lblChapter.textAlignment = NSTextAlignmentCenter;
        lblChapter.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lblChapter.tag = 10;
        //[[scrollViewBar viewWithTag:10] removeFromSuperview];
        [scrollViewBar addSubview:lblChapter];

        yOffset = 50;
    }
    //scrollViewBar.backgroundColor = [UIColor redColor];
    //+20261123 (was darkGrayColor in Night mode; systemBackgroundColor above now covers both modes)
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollViewBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

         
    NSInteger width = 0;//scrollViewBar.frame.size.width;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        width = self.view.frame.size.width - 40;//320 +2080111
    }
    else {
        width = 460;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        width = 320;
    }
    
    NSInteger buttonWidth = 40;
    NSInteger buttonHeight = 40;
    NSInteger spacer = 10;
    NSInteger offsetStart = 16;//55;
    NSInteger xOffset = offsetStart;
    
    for (int i=0; i<self.selectedBook.numOfChapters; i++) {
        NSString *number = [NSString stringWithFormat:@"%d", i+1];
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if(xOffset+5 > width) {
            xOffset = offsetStart;
            yOffset = yOffset + buttonHeight + spacer;
        }
        
        tagButton.tag = i + 1;
        tagButton.frame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
        
        
        if( self.selectedChapter ==  (i+1)){
            tagButton.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE+1];
            //tagButton.titleLabel.textColor = [UIColor darkTextColor];
        }else{
            //tagButton.titleLabel.textColor = [UIColor darkGrayColor];
            tagButton.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        }
        if([UIDeviceHardware isOS7Device]){
            tagButton.tintColor = [UIColor defaultWindowColor];
        }
        //+20261123 Chapter numbers on rounded tiles: label-colour numbers on a grouped fill (strong contrast in both
        // modes); the current chapter is a theme-colour tile with black or white text, whichever reads better.
        tagButton.layer.cornerRadius = 10.0;
        tagButton.layer.cornerCurve = kCACornerCurveContinuous;
        if (self.selectedChapter == (i+1)) {
            UIColor *theme = [UIColor defaultWindowColor];
            tagButton.backgroundColor = theme;
            [tagButton setTitleColor:[ChapterSelection mb_textColorOnColor:theme] forState:UIControlStateNormal];
        } else {
            tagButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
            [tagButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        }
       
               
        [tagButton setTitle:number forState:UIControlStateNormal];
        [tagButton setTitle:number forState:UIControlStateHighlighted];
        [tagButton setTitle:number forState:UIControlStateSelected];
        [tagButton setTitle:number forState:UIControlStateDisabled];
        
        [tagButton addTarget: self 
                      action: @selector(buttonClicked:) 
            forControlEvents: UIControlEventTouchUpInside];
        
        [scrollViewBar addSubview:tagButton];
        
        xOffset += buttonWidth + spacer;
        
        
    }
          
    [scrollViewBar setContentSize:CGSizeMake(width, yOffset+150)];
    
    
    [self.view addSubview:scrollViewBar];
    [self mb_applyNightModeStyle];//+20261123
}

#pragma mark Light / Night style (+20261123)

// White or black text, whichever has the stronger contrast on the given colour (WCAG relative luminance).
+ (UIColor *) mb_textColorOnColor:(UIColor *)color{

    CGFloat r = 0, g = 0, b = 0, a = 0;
    if (![color getRed:&r green:&g blue:&b alpha:&a]) return [UIColor whiteColor];
    CGFloat (^lin)(CGFloat) = ^CGFloat(CGFloat c){ return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4); };
    CGFloat luminance = 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b);
    CGFloat contrastWithWhite = 1.05 / (luminance + 0.05);
    return contrastWithWhite >= 3.5 ? [UIColor whiteColor] : [UIColor blackColor];
}

// The app's Night setting (kNightTime) decides the style of this screen and of its navigation bar, so every
// dynamic colour above (background, heading, tiles, title, back / Cancel button) resolves to the same mode.
// The bar gets an opaque background in the page colour: no white block above a dark page, no grey patches.
- (void) mb_applyNightModeStyle{

    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIUserInterfaceStyle style = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    self.overrideUserInterfaceStyle = style;

    UINavigationBar *bar = self.navigationController.navigationBar;
    bar.overrideUserInterfaceStyle = style;   // the bar's material and back / Cancel button follow the same mode

    UITraitCollection *traits = [UITraitCollection traitCollectionWithUserInterfaceStyle:style];
    UIColor *page = [[UIColor systemBackgroundColor] resolvedColorWithTraitCollection:traits];
    UIColor *title = [[UIColor labelColor] resolvedColorWithTraitCollection:traits];

    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = page;
    appearance.shadowColor = [UIColor clearColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName: title};

    // Item-level, so the book list underneath keeps its own bar when this screen is popped.
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
    self.navigationItem.compactAppearance = appearance;
    self.navigationItem.compactScrollEdgeAppearance = appearance;

    // The presenting sheet / navigation controller behind the bar uses the same page colour.
    self.navigationController.view.backgroundColor = page;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     
       
    if(self.fromMaster){
        
       /*
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];   
        temporaryBarButtonItem.title = [BibleDao getTitleChapterButton];//@"അദ്ധ്യായങ്ങൾ"
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        */
    }else{
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMe:)];
            
        }
    }
    
    
    [self configureView:self.fromMaster];
    
}
- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self mb_applyNightModeStyle];//+20261123 pick up a Night / Light change made while away
    if([UIDeviceHardware isOS7Device]){
        
    }else{
        //+20150823self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
}
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
 
   
    //+20120809MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:-1]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray{
    
    NSInteger chapterid = [[selectionArray objectAtIndex:1] integerValue];
	if (chapterid != -1)
	{
        [self openPageWithChapter:chapterid];
    }
    
}
- (void) buttonClicked: (id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.delegate dismissWithChapter:btn.tag];
        
    }else{
        
        
        MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        
        if (indexPath){
            
            NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:0];//+20140929
            
            
            [dict setObject:[NSNumber numberWithInteger:indexPath.section] forKey:bmBookSection];

            
            [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:-1]];
            [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSMutableDictionary dictionary]];
        }
        
        appDelegate.detailViewController.selectedBook = self.selectedBook;
        appDelegate.detailViewController.chapterId = btn.tag;
        [appDelegate.detailViewController configureView];
        //[self.navigationController pushViewController:self.detailViewController animated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        self.delegate = nil;
    }
    
}

- (void) openPageWithChapter:(NSUInteger)chapter{
    
    self.detailViewController.isActionClicked = NO;
    self.detailViewController.selectedBook = self.selectedBook;
    self.detailViewController.chapterId = chapter;
    [self.detailViewController configureView];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
       
    NSArray *viewsToRemove = [scrollViewBar subviews];
    int i = 0;
    for (UIView *v in viewsToRemove) {
        if(i++ > 0) {
            [v removeFromSuperview];
        }
    }
    
    [self configureView:self.fromMaster];
     
}
#pragma mark @selector methods
//for iPhone only
- (void) cancelMe:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.delegate = nil;
}
 
@end
