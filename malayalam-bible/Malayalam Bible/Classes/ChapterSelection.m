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
    
    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    self.fromMaster = isFromMaster;
    
    self.title = self.selectedBook.shortName;
    
    /** Clear Screen ***/
    NSArray *existingBtns = [scrollViewBar subviews];
    int i = 0;
    for(UIView *sView in existingBtns){
        if(i++ > 0) {
            [sView removeFromSuperview];
        }
    }
    
    [self.scrollViewBar removeFromSuperview];
    /******/
    
    self.view.backgroundColor = [UIColor whiteColor];
    [scrollViewBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    NSInteger yOffset = 15;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        self.lblChapter = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
        
        lblChapter.text = [BibleDao getTitleChapterButton];
        
        if(isdark){
            lblChapter.textColor = [UIColor whiteColor];
        }
        lblChapter.textAlignment = NSTextAlignmentCenter;
        lblChapter.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lblChapter.tag = 10;
        [[scrollViewBar viewWithTag:10] removeFromSuperview];
        [scrollViewBar addSubview:lblChapter];

        yOffset = 50;
    }
    //scrollViewBar.backgroundColor = [UIColor redColor];
    if(isdark){
        self.view.backgroundColor = [UIColor blackColor];
    }
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollViewBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

         
    NSInteger width = scrollViewBar.frame.size.width;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        width = 320;
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
        
        tagButton.tintColor = [UIColor defaultWindowColor];
       
               
        [tagButton setTitle:number forState:UIControlStateNormal];
        [tagButton setTitle:number forState:UIControlStateHighlighted];
        [tagButton setTitle:number forState:UIControlStateSelected];
        [tagButton setTitle:number forState:UIControlStateDisabled];
        
        [tagButton addTarget: self 
                      action: @selector(buttonClicked:) 
            forControlEvents: UIControlEventTouchDown];
        
        [scrollViewBar addSubview:tagButton];
        
        xOffset += buttonWidth + spacer;
        
        
    }
          
    [scrollViewBar setContentSize:CGSizeMake(width, yOffset+150)];
    
    
    [self.view addSubview:scrollViewBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     
       
    if(self.fromMaster){
        
       
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];   
        temporaryBarButtonItem.title = [BibleDao getTitleChapterButton];//@"അദ്ധ്യായങ്ങൾ"
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        
    }else{
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMe:)];
            
        }
    }
    
    
    [self configureView:self.fromMaster];
    
}
- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if([UIDeviceHardware isOS7Device]){
        
    }else{
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
