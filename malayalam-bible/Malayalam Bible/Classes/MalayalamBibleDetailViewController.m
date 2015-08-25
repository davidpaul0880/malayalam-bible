//
//  MalayalamBibleDetailViewController.m
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "MalayalamBibleAppDelegate.h"
#import "MalayalamBibleDetailViewController.h"
#import "ChapterSelection.h"
#import "UIToolbarCustom.h"
#import "BibleDao.h"
#import "MBConstants.h"
#import "VerseCell.h"
#import "MalayalamBibleMasterViewController.h"
#import "SettingsViewController.h"
#import "UIDeviceHardware.h"
#import "SearchViewController.h"
#import "NotesViewController.h"
#import "BookmarkAddViewController.h"
#import "BookMarkViewController.h"
#import "Notes.h"
#import "QuartzCore/QuartzCore.h"
#import "UIDeviceHardware.h"
#import <Social/Social.h>
#import "MBUtils.h"
#import "ActionViewController.h"
#import "ColordVerses.h"
#import "NotesAddViewController.h"
#import  "TintedImageView.h"
#import "VerseEditViewController.h"
#import "Toast+UIView.h"
#import "HighlightTableViewController.h"


#define kActionHelp 7

#define kActionMore 9

#define kTagFullScreenTitle 48
#define kTagFullScreenView  54

#define kTagShareToolbar    49
#define kTagTrasparentView  50
#define kTagNavBarTrasparentView    51
#define kTagActionToolbar   52
#define kTagShareLabelCount    53

CGFloat tableWidth = 25;

//#import "SelectableCell.h"

//#import "MEDropDown.h"

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_5_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_5_0 675.000000
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0 //50000

#define IF_IOS5_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_5_0) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS5_OR_GREATER(...)
#endif

@interface MalayalamBibleDetailViewController ()

@property (strong, nonatomic) NSTimer *timerScroll;
@property (assign) BOOL isValidateTimer;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSMutableArray *arrayToMookmark;
@property(nonatomic, assign) BOOL isautoscrollling;
@property(nonatomic, assign) CGFloat yoffsetPrevious;
@property(nonatomic, assign) CGFloat lastContentOffset;

- (void) resetBottomToolbar;
//-(void)displayComposerSheet:(NSArray *)arraySelectedIndesPath;
- (void) scrollToVerseId;
- (void) moveToNext:(BOOL)isNext;
- (void) loadSelections;
- (void) removeColorsFromDB;
- (void) scrollToTop:(UITapGestureRecognizer *)recognizer;
-(void) presentMessageComposeViewController:(NSString *)text;//+20130905


- (void) modeChangeDynamically;

@end

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@implementation MalayalamBibleDetailViewController

@synthesize imgArrowbooks, imgArrowChapter, imgArrowNext, imgArrowPrevious, isLoaded;

@synthesize masterPopoverController = _masterPopoverController;
@synthesize selectedBook = _selectedBook;
@synthesize chapterId = _chapterId;
@synthesize popoverChapterController = _popoverChapterController;
@synthesize popoverActionController = _popoverActionController;
@synthesize tableViewVerses = _tableViewVerses;
@synthesize tableViewVersesLeft = _tableViewVersesLeft;
@synthesize tableViewVersesRight = _tableViewVersesRight;
@synthesize isActionClicked = _isActionClicked;
@synthesize isFromSeachController = _isFromSeachController;
@synthesize bVerses = _bVerses;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize bVersesIndexArray = _bVersesIndexArray;
@synthesize searchController = _searchController;
@synthesize arrayToMookmark = _arrayToMookmark;
@synthesize webViewVerses = _webViewVerses;
@synthesize versesLeft = _versesLeft;
@synthesize versesRight = _versesRight;
@synthesize versesCurrent = _versesCurrent;
@synthesize isWebViewLoaded;
@synthesize colordObjs = _colordObjs;
@synthesize bookMarkedObjs = _bookMarkedObjs;
@synthesize isLoadViewSET;
//@synthesize tableWebViewVerses = _tableWebViewVerses;

#pragma mark - Managing the detail item
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/** To configure iPhone detail view each time **/
- (void)configureView
{
    self.isLoaded = NO;
    // Update the user interface for the detail item.
    if (self.selectedBook) {
        
        if (self.chapterId < 1 || self.chapterId > self.selectedBook.numOfChapters) {
            self.chapterId = 1;
        }
        
        UIView *viewTitle = [[UIView alloc] init];
        //viewTitle.backgroundColor = [UIColor greenColor];
        
        UIFont *fontt = [UIFont boldSystemFontOfSize:17.0];
        if([UIDeviceHardware isOS7Device]){
            
            fontt = [UIFont boldSystemFontOfSize:18.0];
        }
        
        UIView *referenceBtn = [[UIView alloc] init];//+20130417//[UIButton buttonWithType:UIButtonTypeCustom];
        //referenceBtn.backgroundColor = [UIColor blueColor];
        
        
        CGFloat booknameWidth = 125;
        CGFloat middle = 2.5;
        CGFloat iconwidth = 15;
        NSString *titleNew = [NSString stringWithFormat:@"%@" ,[self.selectedBook shortName]];
        
        if([UIDeviceHardware isIpad]){
            
            titleNew = [NSString stringWithFormat:@"%@ - %li of %i" ,[self.selectedBook shortName], (long)self.chapterId, self.selectedBook.numOfChapters];
            booknameWidth = 220;
            
        }
        
        NSString *titleNew1 = [NSString stringWithFormat:@"%@." ,titleNew];//+20140312 to fix the issue with os7.1
        CGSize titlesize = [titleNew1 sizeWithFont:fontt constrainedToSize:CGSizeMake(booknameWidth, 45) lineBreakMode:NSLineBreakByTruncatingTail];
        
        booknameWidth  = titlesize.width;
        //viewTitle.backgroundColor = [UIColor redColor];
        
        
        
        [referenceBtn setFrame:CGRectMake(0, 0, booknameWidth+middle+ iconwidth, 45)];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, booknameWidth, 45)];
        //lblTitle.font = [UIFont boldSystemFontOfSize:8];
        lblTitle.font = fontt;
        
        if([UIDeviceHardware isIpad]){
        }else{
            lblTitle.minimumScaleFactor = 12.0/lblTitle.font.pointSize;
            lblTitle.adjustsFontSizeToFitWidth = YES;
        }
        
        lblTitle.text = titleNew;
        if([UIDeviceHardware isIpad]){
            
            lblTitle.textAlignment = NSTextAlignmentCenter;
        }else{
            
            lblTitle.textAlignment = NSTextAlignmentCenter;//+20140312ITextAlignmentRight;
        }
        
        
        lblTitle.numberOfLines  = 1;
        lblTitle.backgroundColor = [UIColor clearColor];
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        
        if([UIDeviceHardware isOS7Device] && !isdark){
            lblTitle.textColor = [UIColor blackColor];
        }else{
            lblTitle.textColor = [UIColor whiteColor];
        }
        
        
        
        [referenceBtn addSubview:lblTitle];
        
        UIImage *img = [UIImage imageWithImage:[UIImage imageNamed:@"down-arrow.png"] scaledToSize:CGSizeMake(iconwidth, 28)];//(10, 13
        
        
        if([UIDeviceHardware isOS7Device]){
            
            imgArrowbooks = [[TintedImageView alloc] initWithImage:img];
            //bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
            imgArrowbooks.tintColor = [UIColor defaultWindowColor];
            
            
            
            [imgArrowbooks setFrame:CGRectMake(booknameWidth + middle, (45-img.size.height)/2, img.size.width, img.size.height)];
            [referenceBtn addSubview:imgArrowbooks];
        }else{
            UIImageView *iviewt = [[UIImageView alloc] initWithImage:img];
            [iviewt setFrame:CGRectMake(booknameWidth + middle, (45-img.size.height)/2, img.size.width, img.size.height)];
            [referenceBtn addSubview:iviewt];
        }
        
        if([UIDeviceHardware isIpad]){
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(handleChapterTap:)];
            
            
            [referenceBtn addGestureRecognizer:singleFingerTap];
        }else{
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(handleBookTap:)];
            
            
            [referenceBtn addGestureRecognizer:singleFingerTap];
        }
        
        
        
        [viewTitle addSubview:referenceBtn];
        
        
        CGFloat gapBnBC = 0.0;
        
        
        CGFloat chapterwidth = 0;
        CGFloat middleC = 0.0;
        CGFloat chIconWidth = 0.0;
        
        if(![UIDeviceHardware isIpad]){
            gapBnBC = 10.0;
            
            
            chapterwidth = 25;
            middleC = 1.0;
            chIconWidth = 15;
            
            UIView *chapterBtn = [[UIView alloc] init];
            //chapterBtn.backgroundColor = [UIColor redColor];
            
            CGSize chatsize = [[NSString stringWithFormat:@" %li of %i" ,(long)self.chapterId, self.selectedBook.numOfChapters] sizeWithFont:fontt constrainedToSize:CGSizeMake(50, 45)];
            
            chapterwidth = chatsize.width;
            
            [chapterBtn setFrame:CGRectMake(booknameWidth+middle+iconwidth+gapBnBC, 0, chapterwidth+ middleC + chIconWidth, 45)];
            
            
            
            UILabel *lblChap = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chapterwidth, 45)];
            //lblTitle.font = [UIFont boldSystemFontOfSize:8];
            lblChap.font = [UIFont boldSystemFontOfSize:14.0];
            lblChap.minimumScaleFactor = 8.0/lblChap.font.pointSize;
            lblChap.text = [NSString stringWithFormat:@" %li of %i" ,(long)self.chapterId, self.selectedBook.numOfChapters];
            lblChap.textAlignment = NSTextAlignmentRight;
            lblChap.numberOfLines  = 1;
            lblChap.backgroundColor = [UIColor clearColor];
            bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
            if([UIDeviceHardware isOS7Device] && !isdark){
                lblChap.textColor = [UIColor blackColor];
            }else{
                lblChap.textColor = [UIColor whiteColor];
            }
            
            //lblTitle.font;
            lblChap.adjustsFontSizeToFitWidth = YES;
            
            [chapterBtn addSubview:lblChap];
            
            
            img = [UIImage imageWithImage:[UIImage imageNamed:@"down-arrow.png"] scaledToSize:CGSizeMake(chIconWidth, 28)];
            if([UIDeviceHardware isOS7Device]){
                
                imgArrowChapter = [[TintedImageView alloc] initWithImage:img];
                imgArrowChapter.tintColor = [UIColor defaultWindowColor];
                
                
                
                [imgArrowChapter setFrame:CGRectMake(chapterwidth+middleC, (45-img.size.height)/2, img.size.width, img.size.height)];
                
                /*if(1 == self.selectedBook.numOfChapters){
                 iviewc.alpha = .3;
                 }else{
                 iviewc.alpha = 1.0;
                 }*/
                
                [chapterBtn addSubview:imgArrowChapter];
                
            }else{
                UIImageView *iviewc = [[UIImageView alloc] initWithImage:img];
                [iviewc setFrame:CGRectMake(chapterwidth+middleC, (45-img.size.height)/2, img.size.width, img.size.height)];
                /*if(1 == self.selectedBook.numOfChapters){
                 iviewc.alpha = .3;
                 }else{
                 iviewc.alpha = 1.0;
                 }*/
                [chapterBtn addSubview:iviewc];
            }
            
            
            
            
            
            UITapGestureRecognizer *singleFingerTapChapter = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(handleChapterTap:)];
            
            
            [chapterBtn addGestureRecognizer:singleFingerTapChapter];
            
            [viewTitle addSubview:chapterBtn];
        }
        
        CGFloat nextPrevgap = 5.0;
        if([UIDeviceHardware isOS7Device]){
            nextPrevgap = 25.0;
        }
        
        UIView *alltitleView = [[UIView alloc] init];
        
        
        UIImage *prev = [UIImage imageWithImage:[UIImage imageNamed:@"left-arrow.png"] scaledToSize:CGSizeMake(35, 25)];
        CGRect previewframe;
        if([UIDeviceHardware isOS7Device]){
            
            imgArrowPrevious = [[TintedImageView alloc] initWithImage:prev];
            imgArrowPrevious.tintColor = [UIColor defaultWindowColor];
            
            if(self.chapterId-1 < 1 && self.selectedBook.bookId == 1){
                imgArrowPrevious.alpha = .3;
            }else{
                imgArrowPrevious.alpha = 1.0;
            }
            
            
            previewframe = CGRectMake(0, (45-prev.size.height)/2.+3, prev.size.width, prev.size.height);
            [imgArrowPrevious setFrame:previewframe];
            imgArrowPrevious.tag = 0;
            
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(nextPreviousTap:)];
            
            
            [imgArrowPrevious addGestureRecognizer:singleFingerTap];
            
            //[preView addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            [alltitleView addSubview:imgArrowPrevious];
        }else{
            
            
            UIButton *preView = [UIButton buttonWithType:UIButtonTypeCustom];
            
            //[preView setBackgroundImage:prev forState:UIControlStateNormal];
            [preView setImage:prev forState:UIControlStateNormal];
            previewframe = CGRectMake(0, (45-prev.size.height)/2.+3, prev.size.width+30, prev.size.height);
            [preView setFrame:previewframe];
            preView.tag = 0;
            [preView addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if(self.chapterId-1 < 1){//bookindex == 1 &&
                preView.enabled = NO;
            }
            [alltitleView addSubview:preView];
        }
        
        [viewTitle setFrame:CGRectMake(previewframe.size.width+nextPrevgap, 0, booknameWidth+middle+iconwidth+gapBnBC+chapterwidth+middleC+chIconWidth, 45)];
        
        
        UIImage  *next = [UIImage imageWithImage:[UIImage imageNamed:@"right-arrow.png"] scaledToSize:CGSizeMake(35, 25)];
        
        CGRect nexviewframe;
        if([UIDeviceHardware isOS7Device]){
            
            imgArrowNext = [[TintedImageView alloc] initWithImage:next];
            imgArrowNext.tintColor = [UIColor defaultWindowColor];
            
            if(self.chapterId+1 > self.selectedBook.numOfChapters && self.selectedBook.bookId == 66){//bookindex == 66 &&
                imgArrowNext.alpha = .3;
            }else{
                imgArrowNext.alpha = 1.0;
            }
            nexviewframe =CGRectMake(previewframe.size.width+nextPrevgap+viewTitle.frame.size.width+nextPrevgap, (45-next.size.height)/2. +3, next.size.width, next.size.height);
            [imgArrowNext setFrame:nexviewframe];
            imgArrowNext.tag = 1;
            //[nextView addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(nextPreviousTap:)];
            
            
            [imgArrowNext addGestureRecognizer:singleFingerTap];
            
            
            
            [alltitleView addSubview:imgArrowNext];
            
        }else{
            
            //UIImageView *nextView = [[UIImageView alloc] initWithImage:next];
            UIButton *nextView = [UIButton buttonWithType:UIButtonTypeCustom];
            //[nextView setBackgroundImage:next forState:UIControlStateNormal];
            [nextView setImage:next forState:UIControlStateNormal];
            nexviewframe =CGRectMake(previewframe.size.width+nextPrevgap+viewTitle.frame.size.width+nextPrevgap, (45-next.size.height)/2. +3, next.size.width+30, next.size.height);
            [nextView setFrame:nexviewframe];
            nextView.tag = 1;
            [nextView addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventTouchUpInside];
            
            if(self.chapterId+1 > self.selectedBook.numOfChapters){//bookindex == 66 &&
                nextView.enabled = NO;
            }
            
            [alltitleView addSubview:nextView];
        }
        
        
        
        
        [alltitleView addSubview:viewTitle];
        
        
        [alltitleView setFrame:CGRectMake(0, 0, previewframe.size.width+nextPrevgap+viewTitle.frame.size.width+nextPrevgap+nexviewframe.size.width, 45)];
        
        self.navigationItem.titleView = alltitleView;
        
        // save off this level's selection to our AppDelegate
        MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        /**set select book*** +20121006 **/
        NSUInteger bookindex= self.selectedBook.bookId;
        
        NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:0];//+20140929
        [dict setObject:[NSNumber numberWithInteger:bookindex-1] forKey:bmBookSection];//+20121017
        
        
        MBLog(@"dict = %@", dict);
        
        
        
        [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:self.chapterId]];
        //[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSDictionary dictionary]];
        
        BibleDao *bDao = [[BibleDao alloc] init];
        NSDictionary *ddict = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
        self.bVerses = [ddict valueForKey:@"verse_array"];
        NSString *fullverse = [ddict valueForKey:@"fullverse"];
        
        //(@"fullverse = %@", fullverse);
        
        self.isWebViewLoaded = NO;
        [self.webViewVerses loadHTMLString:fullverse  baseURL:[MBUtils getBaseURL]];
        
        
        
        [self resetBottomToolbar];
        
        [self.tableViewVerses reloadData];
        
        while(!isWebViewLoaded) {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        if(isFullScreen){
            UILabel *ttitlelabel = (UILabel *)[self.view viewWithTag:kTagFullScreenTitle];
            ttitlelabel.text = [NSString stringWithFormat:@"%@ - %li", self.selectedBook.shortName, (long)self.chapterId];
        }
        
        
        //[self scrollToVerseId];
        //[self loadSelections];
    }
    if([UIDeviceHardware isIpad]){//+20131231
        if (self.masterPopoverController != nil) {
            [self.masterPopoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark User Swipe Handiling
- (void) toggleFullScreen {
    
    //[self stopAutoScroll];
    
    isFullScreen = !isFullScreen;
    
    [UIView beginAnimations:@"fullscreen" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    
    CGFloat yValue = 0;
    
    
    if([UIDeviceHardware isOS7Device]){
        //+rollyValue += 64;
    }
    
    if(!isFullScreen){
        MBLog(@"hide bars");
        CGRect rectToolbar = self.bottomToolBar.frame;
        [[self.view viewWithTag:kTagFullScreenView] removeFromSuperview];
        
        CGRect tableRect =  self.webViewVerses.frame;
        tableRect.origin.y = 0;
        tableRect.size.height = self.view.frame.size.height-45;
        
        self.webViewVerses.frame = tableRect;
        
        
        CGRect tableRect2 =  self.tableViewVerses.frame;
        tableRect2.origin.y = yValue;
        tableRect2.size.height = self.view.frame.size.height-45-yValue;
        //tableRect2.size.height -= 45;
        self.tableViewVerses.frame = tableRect2;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        
        rectToolbar.origin.y = self.view.frame.size.height-rectToolbar.size.height+1;
        self.bottomToolBar.frame = rectToolbar;
        
        self.navigationController.navigationBarHidden = NO;
        
        [UIView commitAnimations];
        //[self.navigationController setNavigationBarHidden:isFullScreen animated:YES];
    }else{
        MBLog(@"show bars");
        UIView *titleLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  20)];
        UILabel *titleVieww = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  20)];
        
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        titleVieww.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        titleVieww.text = [NSString stringWithFormat:@"%@ - %li", self.selectedBook.shortName, (long)self.chapterId];
        [titleVieww setBackgroundColor:[UIColor blackColor]];
        [titleVieww setTextAlignment:NSTextAlignmentCenter];
        [titleVieww setTextColor:[UIColor whiteColor]];
        [titleVieww setFont:[UIFont boldSystemFontOfSize:12]];
        titleVieww.tag = kTagFullScreenTitle;
        titleLabel.tag = kTagFullScreenView;
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(scrollToTop:)];
        
        
        [titleLabel addGestureRecognizer:singleFingerTap];
        [titleLabel addSubview:titleVieww];
        
        
        CGRect tableRect =  self.webViewVerses.frame;
        tableRect.origin.y += 20;
        tableRect.size.height -= 20;
        tableRect.size.height += 45;
        self.webViewVerses.frame = tableRect;
        
        
        CGRect tableRect1 =  self.tableViewVerses.frame;
        tableRect1.origin.y = 20;
        tableRect1.size.height = self.view.frame.size.height - 20;
        //tableRect1.size.height += 45;
        self.tableViewVerses.frame = tableRect1;
        
        
        CGRect navbarfr = self.navigationController.navigationBar.frame;
        navbarfr.origin.y -= navbarfr.size.height;
        self.navigationController.navigationBar.frame = navbarfr;
        
        
        
        
        CGRect rectToolbar = self.bottomToolBar.frame;
        rectToolbar.origin.y = self.view.frame.size.height;
        self.bottomToolBar.frame = rectToolbar;
        
        [self.view addSubview:titleLabel];
        
        
        
        
        
        [UIView commitAnimations];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [self.navigationController setNavigationBarHidden:isFullScreen animated:NO];
    }
    
    
    
    
    //[self.tableViewVerses reloadData];
    // [self viewDidLoad];
    // [self prefersStatusBarHidden];
    
}
/*
 - (void) dismissTranparent:(UISwipeGestureRecognizer *)recognizer {
 
 [[self.view viewWithTag:kTagTrasparentView] removeFromSuperview];
 
 [[self.navigationController.navigationBar viewWithTag:kTagNavBarTrasparentView] removeFromSuperview];
 
 [[self.view viewWithTag:kTagActionToolbar] removeFromSuperview];
 
 self.bottomToolBar.hidden = NO;
 
 
 }
 **/
- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    MBLog(@"move n");
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        
        
        [self moveToNext:YES];
        
    }else{
        
        [self moveToNext:NO];
    }
    
    
}

#pragma mark UITouch Delegates

- (void)toucheBegan:(UITouch *)toucch{
    //(@"began");
    //mSwipeStart = [toucch locationInView:self.view];
}
- (void)toucheMoved:(UITouch *)toucch{
    //NSLog(@"moved");
    /* CGPoint location = [toucch locationInView:self.view];
     CGFloat swipeDistance = location.x - mSwipeStart.x;
     
     NSLog(@"swipe distance = %f", swipeDistance);
     
     if (fabsf(swipeDistance) > 20 ) {
     
     CGSize contentSize = [[UIScreen mainScreen] bounds].size;
     
     if ( ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
     {
     self.versesLeft.frame = CGRectMake(swipeDistance - contentSize.height, 0, contentSize.height, contentSize.width);
     self.webViewVerses.frame = CGRectMake(swipeDistance, 0, contentSize.height, contentSize.width);
     self.versesRight.frame = CGRectMake(swipeDistance + contentSize.height, 0, contentSize.height, contentSize.width);
     }
     else
     {
     self.versesLeft.frame = CGRectMake(swipeDistance - contentSize.width, 0, contentSize.width, contentSize.height);
     self.webViewVerses.frame = CGRectMake(swipeDistance, 0, contentSize.width, contentSize.height);
     self.versesRight.frame = CGRectMake(swipeDistance + contentSize.width, 0, contentSize.width, contentSize.height);
     }
     }
     
     */
}
- (void)toucheEnded:(UITouch *)toucch{
    //(@"ended");
    /* CGPoint location = [toucch locationInView:self.view];
     CGFloat swipeDistance = location.x - mSwipeStart.x;
     
     BOOL isMoveLeft = (swipeDistance > 50.0f);
     BOOL isMoveRight = (swipeDistance < -50.0f);
     
     if(isMoveLeft || isMoveRight){
     
     if(isMoveLeft){
     
     self.versesRight = self.webViewVerses;
     self.webViewVerses = self.versesLeft;
     
     }else{
     
     self.versesLeft = self.webViewVerses;
     self.webViewVerses = self.versesRight;
     }
     
     CGSize contentSize = [[UIScreen mainScreen] bounds].size;
     
     [UIView beginAnimations:@"swipe" context:NULL];//[UIView beginAnimations:nil context:nil];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
     [UIView setAnimationDuration:0.3f];
     
     if ( ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
     {   //+JR 20110817
     self.versesLeft.frame = CGRectMake(-contentSize.height, 0, contentSize.height, contentSize.width);
     self.webViewVerses.frame = CGRectMake(0.0f, 0, contentSize.height, contentSize.width);
     self.versesRight.frame = CGRectMake(contentSize.height, 0, contentSize.height, contentSize.width);
     }
     else
     {
     self.versesLeft.frame = CGRectMake(-contentSize.width, 0, contentSize.width, contentSize.height);
     self.webViewVerses.frame = CGRectMake(0.0f, 0, contentSize.width, contentSize.height);
     self.versesRight.frame = CGRectMake(contentSize.width, 0, contentSize.width, contentSize.height);
     }
     
     
     
     [UIView commitAnimations];
     
     }
     */
}

#pragma mark iPad Specific



/**
 - (void)configureiPadView{
 
 
 
 if (self.selectedBook) {
 
 
 if (self.chapterId < 1 || self.chapterId > self.selectedBook.numOfChapters) {
 self.chapterId = 1;
 }
 self.title = [NSString stringWithFormat:@"%@ - %i" ,[self.selectedBook shortName], self.chapterId];
 
 // save off this level's selection to our AppDelegate
 MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
 [appDelegate.savedLocation replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:self.chapterId]];
 //[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSDictionary dictionary]];
 
 
 
 BibleDao *bDao = [[BibleDao alloc] init];
 NSDictionary *ddict = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
 self.bVerses = [ddict valueForKey:@"verse_array"];
 NSString *fullverse = [ddict valueForKey:@"fullverse"];
 //(@"fullverse = %@", fullverse);
 self.isWebViewLoaded = NO;
 [self.webViewVerses loadHTMLString:fullverse  baseURL:[MBUtils getBaseURL]];
 
 
 //UIToolbarCustom* tools = [[UIToolbarCustom alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
 //[tools setBackgroundColor:[UIColor clearColor]];
 if(self.selectedBook.numOfChapters > 1){
 
 UIBarButtonItem* chapterItem =[[UIBarButtonItem alloc] initWithTitle:[BibleDao getTitleChapterButton] style:UIBarButtonItemStyleBordered target:self action:@selector(showChapters:)];
 self.navigationItem.rightBarButtonItem = chapterItem;
 }
 
 
 
 
 [self resetBottomToolbar];
 //}
 [self.tableViewVerses reloadData];
 
 while(!isWebViewLoaded) {
 
 [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
 }
 
 if(isFullScreen){
 UILabel *ttitlelabel = (UILabel *)[self.view viewWithTag:kTagFullScreenTitle];
 ttitlelabel.text = [NSString stringWithFormat:@"%@ - %i", self.selectedBook.shortName, self.chapterId];
 }
 
 [self scrollToVerseId];
 
 [self loadSelections];
 
 }
 if (self.masterPopoverController != nil) {
 [self.masterPopoverController dismissPopoverAnimated:YES];
 }
 }
 
 **/

#pragma mark PopOverDelegate

-(void)dismissWithChapter:(NSUInteger)chapterId{
    
    
    self.chapterId = chapterId;
    
    [self.popoverChapterController dismissPopoverAnimated:YES];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureView];
    }
    else {
        [self configureView];
    }
    
}

#pragma mark - iPad UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = [BibleDao getTitleBooks];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma Mark UITableDataSource
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return [NSString stringWithFormat:@"%@ %d",[BibleDao getTitleChapter], self.chapterId];
 }
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.bVerses) {
        
        return [self.bVerses count];
    }
    else {
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if (isdark ){
        cell.backgroundColor = [UIColor blackColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}

#pragma  mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
//+20121017
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    //(@"[self.bVerses count] = %i", [self.bVerses count]);
    
    //(@"self.bVerses  = %@", self.bVerses);
    
    self.bVersesIndexArray = [NSMutableArray arrayWithCapacity:[self.bVerses count]];
    //for(NSUInteger i=1; i<=[self.bVerses count] ; i++){
    for(NSUInteger i=0; i<[self.bVerses count] ; i++){
        
        NSDictionary *dict = [self.bVerses objectAtIndex:i];
        [self.bVersesIndexArray addObject:[NSString stringWithFormat:@"%@", [dict valueForKey:@"verseid"]]];
        //[self.bVersesIndexArray addObject:[NSString stringWithFormat:@"%i", i]];
    }
    //(@"self.bVersesIndexArray = %@", self.bVersesIndexArray);
    return  self.bVersesIndexArray;
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    self.isLoaded = NO;
    NSDictionary *dict = [self.bVerses objectAtIndex:index];
    
    NSString *divid = [NSString stringWithFormat:@"Verse-%@",[dict valueForKey:@"verseid"]];
    
    NSMutableString *command = [NSMutableString stringWithFormat:@"scrollToDivId('%@", divid];
    
    [command appendString:@"')"];
    
    //(@"command = %@", command);
    
    [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    
    MBLog(@"scrolled");
    
    return [self.bVersesIndexArray indexOfObject:title];
    
    
    
    
}
/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 
 //IF_IOS5_OR_GREATER(
 if(isFullScreen){
 return nil;
 }else{
 UIView *fview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewVerses.frame.size.width, 45)];
 [fview setBackgroundColor:[UIColor clearColor]];
 return  fview;
 }
 //)
 //return nil;
 }*/
/*- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return YES;
 }*/
/*
 //No use after implement tablewebview
 - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
 {
 return (action == @selector(copy:));
 }
 
 - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
 {
 if (action == @selector(copy:)){
 
 UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
 
 NSMutableString *copiedVerse = [[NSMutableString alloc] init ];
 [copiedVerse appendFormat:@"%@", self.selectedBook.shortName];
 [copiedVerse appendFormat:@" %i", self.chapterId];
 
 
 NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
 NSString *secondaryL = kLangNone;
 if(dictPref !=nil ){
 secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
 }
 
 NSDictionary *dictVerse = [self.bVerses objectAtIndex:indexPath.row];
 
 if(secondaryL == kLangNone) {
 [copiedVerse appendFormat:@":%@\n", [dictVerse valueForKey:@"verse_text"]];
 }
 else {
 [copiedVerse appendFormat:@"\n%@\n", [dictVerse valueForKey:@"verse_text"]];
 }
 
 pasteboard.string = copiedVerse;
 
 }
 }
 */

#pragma mark MemoryHandling


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (BOOL)prefersStatusBarHidden
{
    if(isFullScreen){
        MBLog(@"full screen");
        return YES;
    }else{
        MBLog(@"not full screen");
        return NO;
    }
    
}
- (void) loadView{
    
    [super loadView];
    
    
    
    CGFloat yValue = 0;
    
    
    if([UIDeviceHardware isOS7Device]){
        yValue += 64;
    }
    
    
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    
    self.tableViewVerses = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-tableWidth, yValue, tableWidth, self.view.frame.size.height-(45+yValue)) style:UITableViewStylePlain];
    self.tableViewVerses.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    self.tableViewVerses.delegate = self;
    
    self.tableViewVerses.dataSource = self;
    self.tableViewVerses.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //CGRect rect = self.view.frame;
    self.webViewVerses = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-tableWidth, self.view.frame.size.height-(45))];
    
    self.webViewVerses.backgroundColor = [UIColor whiteColor];
    
    if([UIDeviceHardware isOS5Device]){
        
        UIScrollView *zview = self.webViewVerses.scrollView;
        [zview setShowsVerticalScrollIndicator:NO];
        zview.delegate = self;//+20131111
        for (UIView* shadowView in [zview subviews])
        {
            if ([shadowView isKindOfClass:[UIImageView class]]) {
                [shadowView setHidden:YES];
                
            }
        }
        
        
    }else{
        
        for (UIView* subView in [self.webViewVerses subviews])
        {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                
                //[(UIScrollView*)[webview.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
                UIScrollView *sView = (UIScrollView *)subView;
                [sView setShowsVerticalScrollIndicator:NO];
                
                for (UIView* shadowView in [subView subviews])
                {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
                break;
            }
        }
    }
    
    self.webViewVerses.opaque = false;
    
    self.webViewVerses.delegate = self;
    self.webViewVerses.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    //self.webViewVerses.scalesPageToFit = YES;
    self.webViewVerses.autoresizesSubviews = YES;
    self.webViewVerses.userInteractionEnabled = YES;//+20140617
    
    [self.view addSubview:self.webViewVerses];
    
    
    
    
    /*CGSize contentSize = [[UIScreen mainScreen] bounds].size;
     
     
     self.versesLeft = [[UIWebView alloc] init];
     self.versesRight = [[UIWebView alloc] init];
     
     if ( ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft) || ([self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) )
     {
     
     
     self.versesLeft.frame = CGRectMake(-contentSize.width, 0, contentSize.width, contentSize.height);
     
     self.versesRight.frame = CGRectMake(contentSize.height, 0, contentSize.width, contentSize.height);
     }
     else
     {
     self.versesLeft.frame = CGRectMake(-contentSize.width, 0, contentSize.width, contentSize.height);
     
     self.versesRight.frame = CGRectMake(contentSize.width, 0, contentSize.width, contentSize.height);
     }
     [self.view addSubview:self.versesLeft];
     [self.view addSubview:self.versesRight];
     */
    
    
    self.bottomToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 45)];
    self.bottomToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    if([UIDeviceHardware isOS7Device]){
        
        [self.bottomToolBar setBarTintColor:[UIColor whiteColor]];
        
    }else{
        self.bottomToolBar.barStyle =  UIBarStyleBlack;
        self.bottomToolBar.translucent = YES;
        
    }
    
    
    [self.view addSubview:self.bottomToolBar];
    [self.view addSubview:self.tableViewVerses];
    
    //[self.view bringSubviewToFront:self.bottomToolBar];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableViewVerses.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewVerses.allowsSelection = NO;
    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
    NSString *secondaryL = kLangNone;
    if(dictPref !=nil ){
        secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
        
    }
    
    
    //+20131114
    if([UIDeviceHardware isOS7Device]){
        
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if(isdark){
            self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        }else{
            
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        }
        
        
        //noneed[self setEdgesForExtendedLayout:UIRectEdgeNone];
    }else{
        
        //+20150823self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    
    
    
    //+20140617
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    //recognizer.delegate = self; //+20140617
    
    
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    //swipeLeftRecognizer.delegate = self;
    
    [self.webViewVerses.scrollView.panGestureRecognizer requireGestureRecognizerToFail:recognizer];
    [self.webViewVerses.scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeLeftRecognizer];
    
    [self.view addGestureRecognizer:recognizer];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    
    //[self.webViewVerses.scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipeLeftRecognizer];
    
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // Do any additional setup after loading the view, typically from a nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
        
        [self configureView];
        
    }else{
        
        //+20140929
        //+20150820
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (UIDeviceOrientationIsLandscape(orientation)) {
            
            UIBarButtonItem* expand = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"resize_full.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(expand:)];
            
            self.navigationItem.rightBarButtonItem = expand;
        }
        
        
        //Adding observer to notify the language changes
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"NotifyTableReload" object:nil];
        //+20131114
        if(isLoadViewSET){
            [self configureView];
            self.isLoadViewSET = NO;
        }
    }
    if(!isFromSeachController){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"NotifyTableReload" object:nil];
    }
    //[self.tableView allowsMultipleSelection];
    
    
    [self resetBottomToolbar];
    [self modeChangeDynamically];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //scroll to selected verse from search or from saved point
    //[self scrollToVerseId];
    
    isDetailControllerVisible = YES;
    
    [self resetLayout];
}


- (void)viewDidUnload{
    
    self.webViewVerses.delegate = nil;
    [self.timerScroll invalidate];
    [super viewDidUnload];
}
- (void)statusBarTappedAction:(NSNotification*)notification {
    
    
    [self scrollToTop:nil];
    
    //handle StatusBar tap here.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:kStatusBarTappedNotification
                                               object:nil];
    
    [super viewWillAppear:animated];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStatusBarTappedNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    isDetailControllerVisible = NO;
}

#pragma Rotation Support
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    //+20140929
    if([UIDeviceHardware isIpad]){
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
            
            UIBarButtonItem* expand = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"resize_full.png"] landscapeImagePhone:[UIImage imageNamed:@"fullscreen.png"] style:UIBarButtonItemStylePlain target:self action:@selector(expand:)];
            
            self.navigationItem.rightBarButtonItem = expand;
            
        }else{
            
            
            MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
            [appDelegate showMasterController];

            
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}

//+roll
/*
 - (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 // Allow the animation to complete
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 [self.webViewVerses.scrollView setZoomScale:0 animated:YES];
 });
 }*/
//+20131114
- (BOOL)shouldAutorotate {
    
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    
    return YES;
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
     } else {
     return YES;
     }*/
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    MBLog(@"rotate");
    /*[self.webViewVerses stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",(int)self.webViewVerses.frame.size.width]];
     
     CGFloat fll_width = self.view.frame.size.width-tableWidth;
     NSString* adsl_javascript_string = [NSString stringWithFormat:@"var setViewPortScript = document.createElement('meta');\
     setViewPortScript.setAttribute('name', 'viewport');\
     setViewPortScript.setAttribute('content', 'width = %f');\
     document.getElementsByTagName('head')[0].appendChild(setViewPortScript);", fll_width];
     [self.webViewVerses stringByEvaluatingJavaScriptFromString:adsl_javascript_string];
     */
    //+20150409
        //[self.webViewVerses reload];
    
    [self resetLayout];
}
#pragma mark Private methods

- (void) resetLayout{
    
    CGRect frme = self.webViewVerses.frame;
    frme.size.width = self.view.frame.size.width-tableWidth;
    self.webViewVerses.frame = frme;
    [self.webViewVerses setNeedsLayout];
    
    CGRect frmet = self.tableViewVerses.frame;
    frmet.origin.x = self.view.frame.size.width-tableWidth;
    self.tableViewVerses.frame = frmet;
    [self.tableViewVerses setNeedsLayout];
    
    [self.webViewVerses stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
      (int)self.webViewVerses.frame.size.width]];

}

- (void) modeChangeDynamically{
    
    BOOL isos7 = NO;
    if ([UIDeviceHardware isOS7Device]) {
        
        isos7 = YES;
    }
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    if (isos7){
        appDelegate.window.tintColor = [UIColor defaultWindowColor];
        //+20150823
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor defaultWindowColor];
    }
    
    UIColor *changedColor;
    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if (isdark ){
        
        changedColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],UITextAttributeTextColor,
                                                   [UIColor blackColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
    }else{
        
        changedColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor blackColor],UITextAttributeTextColor,
                                                   [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
    }
    
    if (isos7) [[UIToolbar appearance] setBarTintColor:changedColor];
    
    [self.view setBackgroundColor:changedColor];//+20150216
    
    self.tableViewVerses.backgroundColor = changedColor;
    self.tableViewVerses.backgroundView.backgroundColor = changedColor;
    self.tableViewVerses.sectionIndexColor = [UIColor defaultWindowColor];
    
    if (isos7) {
    
        self.tableViewVerses.sectionIndexBackgroundColor = changedColor;
    }else{
        self.tableViewVerses.sectionIndexTrackingBackgroundColor = changedColor;
    }
    
    
    
    if (isos7) self.navigationController.navigationBar.barTintColor = changedColor;
    self.navigationController.navigationBar.translucent = NO;
    self.webViewVerses.scrollView.backgroundColor = changedColor;
    
    
    if (isos7) self.bottomToolBar.barTintColor = changedColor;
    
    [self.tableViewVerses.backgroundView setNeedsDisplay];
    [self.tableViewVerses setNeedsDisplay];
    [self.webViewVerses setNeedsDisplay];
    [self.bottomToolBar setNeedsDisplay];
}


//+20130905
-(void) presentMessageComposeViewController:(NSString *)text{
    id smsViewController = [[NSClassFromString(@"MFMessageComposeViewController") alloc] init];
    [smsViewController setTitle:NSLocalizedString(@"MailFooter", @"footer message")];
    [smsViewController setBody:NSLocalizedString(text,nil)];
    [smsViewController setMessageComposeDelegate: (id)self];
    [self presentViewController:smsViewController animated:YES completion:nil];
}
- (NSString *)getSelectedVerseTitle{
    
    NSMutableArray *arrayVerseIds = [NSMutableArray arrayWithCapacity:[self.arrayToMookmark count]];
    for(int i=0; i < [self.arrayToMookmark count] ; i++){
        
        NSString *vIndex = [self.arrayToMookmark objectAtIndex:i];
        NSDictionary *dict = [self.bVerses objectAtIndex:[vIndex integerValue]];
        
        [arrayVerseIds addObject:[NSNumber numberWithInteger:[[dict valueForKey:@"verseid"] integerValue]]];
    }
    
    MBLog(@"arrayVerseIds = %@", arrayVerseIds);
    
    NSMutableString *ttitle = [NSMutableString string];
    
    
    
    
    NSInteger k = 0;
    BOOL isseries = NO;
    NSInteger start = 0;
    
    for(int i=0 ; i<[arrayVerseIds count]; i++){
        
        NSInteger nextvid = [[arrayVerseIds objectAtIndex:i] integerValue];
        
        
        if(k > 0){
            
            if(k+1 == nextvid){
                
                if(!isseries){
                    start = k;
                }
                isseries = YES;
                if(i+1  == [arrayVerseIds count]){
                    if(ttitle.length > 0){
                        [ttitle appendString:@","];
                    }
                    
                    [ttitle appendFormat:@"%li-%li", (long)start, (long)nextvid];
                }
                k = nextvid;
                
            }else{
                
                if(isseries){
                    if(ttitle.length > 0){
                        [ttitle appendString:@","];
                    }
                    [ttitle appendFormat:@"%li-%li", (long)start, (long)k];
                }else{
                    if(ttitle.length == 0){
                        [ttitle appendFormat:@"%li", (long)k];
                    }else{
                        [ttitle appendFormat:@",%li", (long)k];
                    }
                }
                isseries = NO;
                start = 0;
                k=nextvid;
                if(i+1  == [arrayVerseIds count]){
                    [ttitle appendFormat:@",%li", (long)k];
                }
                
            }
            
        }
        if(k == 0){
            k = nextvid;
            if(i+1  == [arrayVerseIds count]){
                [ttitle appendFormat:@"%li", (long)k];
            }
        }
        
    }
    
    NSMutableString *fullTitle = [NSMutableString stringWithFormat:@"%@ %li:%@", self.selectedBook.shortName, (long)self.chapterId, ttitle];
    
    return fullTitle;
    
}

- (void) loadSelections{
    
    
    [[self.view viewWithTag:kTagShareToolbar] removeFromSuperview];
    [self.arrayToMookmark removeAllObjects];
    
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"BookMarks" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    //self.chapterId >= self.selectedBook
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(bookid = %i and chapter = %i)", self.selectedBook.bookId, self.chapterId];
    [request setPredicate:pred];
    BookMarks *bookmark = nil;
    
    NSError *error;
    self.bookMarkedObjs = [context executeFetchRequest:request error:&error];
    
    
    if ([self.bookMarkedObjs count] == 0) {
        MBLog(@"No matches");
    } else {
        
        for(int i=0; i< [self.bookMarkedObjs count] ; i++){
            
            bookmark = self.bookMarkedObjs[i];
            
            NSArray  *bmids = [bookmark.verseid componentsSeparatedByString:@","];
            for(NSString *bmid in bmids){
                
                NSString *divid = [NSString stringWithFormat:@"Font-%li",(long)[bmid integerValue]];
                Folders *folder = bookmark.folder;
                //NSMutableString *command = [NSMutableString stringWithFormat:@"toggleSelection('%@')", divid];
                NSMutableString *command = [NSMutableString stringWithFormat:@"selectBMVerse(\"%@\", \"%@\")", divid, folder.folder_color];
                
                MBLog(@"command = %@",command);
                
                [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
            }
            
            
            
        }
        
    }
    
    /*NSString *ss1 =[self.webViewVerses stringByEvaluatingJavaScriptFromString:@"testj1(\"A\")"];
     
     
     NSLog(@"ss1 = %@", ss1);
     
     NSString *ss2 =[self.webViewVerses stringByEvaluatingJavaScriptFromString:@"testj2(\"A\")"];
     NSLog(@"ss2 = %@", ss2);
     */
    
    BibleDao *bdao = [[BibleDao alloc] init];
    self.colordObjs = [bdao getAllColordVersesOfBook:self.selectedBook.bookId ChapterId:self.chapterId];
    
    
    for(int i=0; i< [self.colordObjs count] ; i++){
        
        ColordVerses *obj = self.colordObjs[i];
        
        
        NSString *divid = [NSString stringWithFormat:@"Font-%li",(long)[obj.verseid integerValue]];
        
        NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"%@\")", divid, [MBUtils getHighlightColorof:obj.colorcode]];
        
        MBLog(@"command = %@",command);
        
        [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
        
    }
    
}
- (void) moveToNext:(BOOL)isNext{
    
    MBLog(@"move ..");
    
    BOOL isContinue = YES;
    
    if(isNext){
        self.chapterId++;
        
        
        if(self.chapterId > self.selectedBook.numOfChapters){
            
            if (self.selectedBook.bookId < 66 ){
                
                BibleDao *daoo = [[BibleDao alloc] init];
                Book *bookdetails = [daoo getBookUsingId:self.selectedBook.bookId+1];
              
                self.selectedBook = bookdetails;
                self.chapterId = 0;
                
            }else{
                
                
                self.chapterId--;
                isContinue = NO;
                
                
                
                [UIView animateWithDuration:0.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     // Do your animations here.
                                     CGRect frame1 =  self.webViewVerses.frame;
                                     frame1.origin.x = -100;
                                     self.webViewVerses.frame = frame1;
                                     
                                     
                                     CGRect framet1 =  self.tableViewVerses.frame;
                                     framet1.origin.x = self.webViewVerses.frame.size.width-100;
                                     self.tableViewVerses.frame = framet1;
                                     
                                 }
                                 completion:^(BOOL finished){
                                     if (finished) {
                                         // Do your method here after your animation.
                                         [UIView beginAnimations:nil context:nil];
                                         [UIView setAnimationDuration:0.6];
                                         
                                         CGRect frame2 =  self.webViewVerses.frame;
                                         frame2.origin.x = 0;
                                         self.webViewVerses.frame = frame2;
                                         
                                         CGRect framet2 =  self.tableViewVerses.frame;
                                         framet2.origin.x = self.view.frame.size.width-tableWidth;
                                         self.tableViewVerses.frame = framet2;
                                         
                                         
                                         [UIView commitAnimations];
                                         
                                     }
                                 }
                 ];

            }
            
            
            
        }else{
            
            
            
            [UIView animateWithDuration:0.0f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 // Do your animations here.
                                 CGRect frame1 =  self.webViewVerses.frame;
                                 frame1.origin.x = 	frame1.size.width;
                                 self.webViewVerses.frame = frame1;
                                 
                                 
                                 CGRect framet1 =  self.tableViewVerses.frame;
                                 framet1.origin.x += 	framet1.size.width;
                                 self.tableViewVerses.frame = framet1;
                                 
                             }
                             completion:^(BOOL finished){
                                 if (finished) {
                                     // Do your method here after your animation.
                                     
                                     [UIView beginAnimations:nil context:nil];
                                     [UIView setAnimationDuration:0.6];
                                     
                                     CGRect frame2 =  self.webViewVerses.frame;
                                     frame2.origin.x = 0;
                                     self.webViewVerses.frame = frame2;
                                     
                                     CGRect framet2 =  self.tableViewVerses.frame;
                                     framet2.origin.x = self.view.frame.size.width-tableWidth;
                                     self.tableViewVerses.frame = framet2;
                                     
                                     
                                     [UIView commitAnimations];
                                     
                                     
                                 }
                             }
             ];
            /*
             
             
             [UIView beginAnimations:nil context:nil];
             [UIView setAnimationDuration:0.3];
             
             
             
             
             [UIView commitAnimations];
             
             
             */
        }
        
        
        
    }else{
        self.chapterId--;
        
        
        if(self.chapterId < 1){
            
            
            if (self.selectedBook.bookId > 1){
                
                BibleDao *daoo = [[BibleDao alloc] init];
                Book *bookdetails = [daoo getBookUsingId:self.selectedBook.bookId-1];
                
                self.selectedBook = bookdetails;
                self.chapterId = self.selectedBook.numOfChapters;
                
            }else{
                self.chapterId++;
                isContinue = NO;
                
                
                [UIView animateWithDuration:0.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     // Do your animations here.
                                     CGRect frame1 =  self.webViewVerses.frame;
                                     frame1.origin.x = 100;
                                     self.webViewVerses.frame = frame1;
                                     
                                     CGRect framet1 =  self.tableViewVerses.frame;
                                     framet1.origin.x = self.webViewVerses.frame.size.width+100;
                                     self.tableViewVerses.frame = framet1;
                                     
                                 }
                                 completion:^(BOOL finished){
                                     if (finished) {
                                         // Do your method here after your animation.
                                         [UIView beginAnimations:nil context:nil];
                                         [UIView setAnimationDuration:0.6];
                                         
                                         CGRect frame2 =  self.webViewVerses.frame;
                                         frame2.origin.x = 0;
                                         self.webViewVerses.frame = frame2;
                                         
                                         CGRect framet2 =  self.tableViewVerses.frame;
                                         framet2.origin.x = self.view.frame.size.width-tableWidth;
                                         self.tableViewVerses.frame = framet2;
                                         
                                         
                                         [UIView commitAnimations];
                                         
                                     }
                                 }
                 ];

            }
            
            
        }else{
            
            
            [UIView animateWithDuration:0.0f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 // Do your animations here.
                                 CGRect frame1 =  self.webViewVerses.frame;
                                 frame1.origin.x -= 	frame1.size.width;
                                 self.webViewVerses.frame = frame1;
                                 
                                 CGRect framet1 =  self.tableViewVerses.frame;
                                 framet1.origin.x =  frame1.origin.x + frame1.size.width;
                                 self.tableViewVerses.frame = framet1;
                                 
                             }
                             completion:^(BOOL finished){
                                 if (finished) {
                                     // Do your method here after your animation.
                                     [UIView beginAnimations:nil context:nil];
                                     [UIView setAnimationDuration:0.6];
                                     
                                     CGRect frame2 =  self.webViewVerses.frame;
                                     frame2.origin.x = 0;
                                     self.webViewVerses.frame = frame2;
                                     
                                     CGRect framet2 =  self.tableViewVerses.frame;
                                     framet2.origin.x = self.view.frame.size.width-tableWidth;
                                     self.tableViewVerses.frame = framet2;
                                     
                                     
                                     [UIView commitAnimations];
                                 }
                             }]
            ;
            
            /*[UIView beginAnimations:nil context:nil];
             [UIView setAnimationDuration:0.3];
             
             
             
             [UIView commitAnimations];
             */
            
            
            
        }
        
    }
    
    if(isContinue){
        
        [self configureView];
        
        
        
        /*[UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.3];
         CGRect frame2 =  self.tableViewVerses.frame;
         
         frame2.origin.x = 	0;
         
         self.tableViewVerses.frame = frame2;
         [UIView commitAnimations];
         */
    }
    
    
}
- (void) scrollToTop:(UITapGestureRecognizer *)recognizer{
    
    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *command = @"scrollToTop()";
    
    MBLog(@"command = %@", command);
    
    [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSMutableDictionary dictionary]];
    
    [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    
    
}
- (void) scrollToVerseId{
    
    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.savedLocation objectAtIndex:2]];//+20140929
    
    
    NSNumber *verseid = [dict valueForKey:@"verse_id"];
    NSNumber *sPos = [dict valueForKey:@"scroll_position"];
    
    if(verseid){//this is for bookmark selection
        
        NSString *divid = [NSString stringWithFormat:@"Verse-%@",verseid];
        
        NSMutableString *command = [NSMutableString stringWithFormat:@"scrollToDivId('%@", divid];
        
        [command appendString:@"')"];
        
        MBLog(@"command = %@", command);
        
        [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSMutableDictionary dictionary]];
        
        [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
        
    }else if(sPos){
        
        if([UIDeviceHardware isOS5Device]){
            
            
            CGFloat yVal = MIN((self.webViewVerses.scrollView.contentSize.height - self.webViewVerses.scrollView.frame.size.height), [sPos floatValue]);
            
            [self.webViewVerses.scrollView setContentOffset:CGPointMake(0, yVal)];
        }
        
        
        [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSMutableDictionary dictionary]];
        MBLog(@"set yes");
        self.isLoaded = YES;
    }else{
        MBLog(@"set yes");
        self.isLoaded = YES;
    }
    
    
    /*
     MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
     NSMutableDictionary *dict = [appDelegate.savedLocation objectAtIndex:2];
     
     
     NSNumber *verseid = [dict valueForKey:@"verse_id"];
     if(verseid){
     
     //(@"verseid to %i", [verseid intValue]);
     NSUInteger rowid =  [verseid intValue];
     if(rowid > 0){
     --rowid;
     }
     
     
     if(rowid < [self.bVerses count]){
     
     
     [self.tableViewVerses scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rowid] atScrollPosition:UITableViewScrollPositionTop animated:NO];
     
     //[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSDictionary dictionary]];
     }else{
     [self.tableViewVerses scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([self.bVerses count] -1)] atScrollPosition:UITableViewScrollPositionTop animated:NO];
     
     //[appDelegate.savedLocation replaceObjectAtIndex:2 withObject:[NSDictionary dictionary]];
     }
     [dict removeObjectForKey:@"verse_id"];
     
     }else{
     CGPoint pointt = self.tableViewVerses.contentOffset;
     pointt.y = [[dict valueForKey:@"content_offset"] floatValue];
     //(@"scroll to %f", pointt.y);
     [self.tableViewVerses setContentOffset:pointt];
     
     }
     */
}
/*
 - (void) toggleItems:(NSInteger)mode{
 
 NSMutableArray *arrayOfTools = [NSMutableArray array];
 
 
 UIImage *imgin = [UIImage imageNamed:@"zoom_in.png"];
 
 
 UIBarButtonItem *btnZoomInnn = [[UIBarButtonItem alloc] initWithImage:imgin style:UIBarButtonItemStylePlain target:self action:@selector(zoominBtnClicked:)];
 
 
 [arrayOfTools addObject:btnZoomInnn];
 
 
 UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
 [arrayOfTools addObject:flex1];
 
 
 
 
 UIImage *imgout = [UIImage imageNamed:@"zoom_out.png"];
 
 UIBarButtonItem *btnZoomouttt = [[UIBarButtonItem alloc] initWithImage:imgout style:UIBarButtonItemStylePlain target:self action:@selector(zoomoutBtnClicked:)];
 [arrayOfTools addObject:btnZoomouttt];
 
 UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
 [arrayOfTools addObject:flex2];
 
 
 
 
 
 }
 **/
- (void) resetBottomToolbar{
    
    
    
    NSMutableArray *arrayOfTools = [[NSMutableArray alloc] initWithCapacity:2];
    
    
    /**UIImage *imgin = [UIImage imageNamed:@"zoom_in.png"];
     
     
     UIBarButtonItem *btnZoomInnn = [[UIBarButtonItem alloc] initWithImage:imgin style:UIBarButtonItemStylePlain target:self action:@selector(zoominBtnClicked:)];
     
     
     UIImage *imgout = [UIImage imageNamed:@"zoom_out.png"];
     
     UIBarButtonItem *btnZoomouttt = [[UIBarButtonItem alloc] initWithImage:imgout style:UIBarButtonItemStylePlain target:self action:@selector(zoomoutBtnClicked:)];
     
     
     if(FONT_SIZE <= kFontMinSize) {
     [btnZoomouttt setEnabled:NO];
     }
     
     if(FONT_SIZE >= kFontMaxSize) {
     [btnZoomInnn setEnabled:NO];
     }
     **/
    
    //UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace                           target:nil action:nil];
    UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                              target:nil action:nil];
    //+20130905UIBarButtonItem *flex4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    
    
    
    /*
     if(self.chapterId <= 1) {
     [barbtnPrevious setEnabled:NO];
     }
     
     if(self.chapterId >= self.selectedBook.numOfChapters) {
     [barbtnNext setEnabled:NO];
     }*/
    // if(![UIDeviceHardware isIpad]){
    
    UIImage *imgSettings = [UIImage imageNamed:@"Gear.png"] ;//+20130418 Gear
    UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithImage:imgSettings style:UIBarButtonItemStylePlain target:self action:@selector(showPreferences:)];
    
    UIBarButtonItem *flex0 = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                              target:nil action:nil];
    
    
    [arrayOfTools addObject:btnSettings];
    [arrayOfTools addObject:flex0];
    
    //}
    
    /*[arrayOfTools addObject:btnZoomouttt];
     [arrayOfTools addObject:flex1];
     [arrayOfTools addObject:btnZoomInnn];
     
     
     UIBarButtonItem *flex00 = [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
     target:nil action:nil];
     
     
     [arrayOfTools addObject:flex00];
     */
    
    
    
    
    
    UIBarButtonItem *barButtonItemNotes = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(openNotes)];
    
    
    [arrayOfTools addObject:barButtonItemNotes];
    
    UIBarButtonItem *flexnotes = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    [arrayOfTools addObject:flexnotes];
    
    
    UIBarButtonItem *barButtonItemColord = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openColordVerses)];
    
    [arrayOfTools addObject:barButtonItemColord];
    
    UIBarButtonItem *flexcolord = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                   target:nil action:nil];
    [arrayOfTools addObject:flexcolord];
    
    
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(openBookmarks)];
    
    
    [arrayOfTools addObject:barButtonItem];
    
    
    [arrayOfTools addObject:flex3];
    
    
    
    
    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                  target:self action:@selector(doSearch:)];
    [arrayOfTools addObject:btnSearch];
    
    //+20130905[arrayOfTools addObject:flex4];
    
    //self.toolBarBottom.items = arrayOfTools;
    self.bottomToolBar.items = arrayOfTools;
    //[self.bottomToolBar sizeToFit];
    if ([UIDeviceHardware isOS7Device]) {
        self.bottomToolBar.tintColor = [UIColor defaultWindowColor];
    }
}
- (void) removeColorsFromDB{
    NSMutableString *versidss = [NSMutableString string];
    for(int i=0; i<self.arrayToMookmark.count ; i++){
        
        NSString *row = [self.arrayToMookmark objectAtIndex:i];
        
        NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
        
        if(versidss.length == 0){
            [versidss appendFormat:@"verseid=%@",[dict valueForKey:@"verseid"]];
        }else{
            [versidss appendFormat:@" or verseid=%@ ",[dict valueForKey:@"verseid"]];
        }
        
    }
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ColordVerses" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSString *strpredicate = [NSString stringWithFormat:@"(bookid = %i and chapter = %li and (%@))", self.selectedBook.bookId, (long)self.chapterId, versidss];
    MBLog(@"strpredicate = %@", strpredicate);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:strpredicate];
    [request setPredicate:pred];
    
    
    
    NSError *error;
    NSArray *array1 = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *product in array1) {
        [context deleteObject:product];
    }
    
    [context save:&error];
}
#pragma mark MBProtocol delegate
- (void) setBookMarkForIds:(BookMarks *)bookMark;{
    
    NSArray  *bmids = [bookMark.verseid componentsSeparatedByString:@","];
    MBLog(@"bmids = %@",bmids);
    for(NSString *bmid in bmids){
        
        NSString *divid = [NSString stringWithFormat:@"Font-%li",(long)[bmid integerValue]];
        Folders *folder = bookMark.folder;
        //NSMutableString *command = [NSMutableString stringWithFormat:@"toggleSelection('%@')", divid];
        NSMutableString *command = [NSMutableString stringWithFormat:@"selectBMVerse(\"%@\", \"%@\")", divid, folder.folder_color];
        
        MBLog(@"command = %@",command);
        
        [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    }
    
    
}
- (void) setSelectedRow:(NSUInteger)roww IsPrimary:(BOOL)isPrimary{
    
    NSMutableDictionary *dictVerse = [self.bVerses objectAtIndex:roww];
    
    if(isPrimary){
        
        [dictVerse setValue:@"YES" forKey:@"isSelectedPrimary"];
    }else{
        
        [dictVerse setValue:@"NO" forKey:@"isSelectedPrimary"];
    }
    
    [self.tableViewVerses reloadData];
}

#pragma mark @selector methods
//+20140929
-(void)autoScroll
{
    
    CGFloat yOffset = [[[self webViewVerses] stringByEvaluatingJavaScriptFromString:@"pageYOffset"] floatValue];
    if(self.yoffsetPrevious == yOffset){
        
        MBLog(@"yOffset = %f", yOffset);
        [self stopAutoScroll];
        
    }else{
        
        self.yoffsetPrevious = yOffset;
        
        if(yOffset >= self.webViewVerses.scrollView.contentSize.height)
            yOffset = 0;
        else
            yOffset += 1;
        
        
        
        
        NSString* javascript = [NSString stringWithFormat:@"window.scrollTo(0, %f);",yOffset];
        //(@"javascript = %@", javascript);
        [self.webViewVerses stringByEvaluatingJavaScriptFromString:javascript];
        
        
        
        if(!self.isValidateTimer)
        {
            
            CGFloat speed = [[NSUserDefaults standardUserDefaults] floatForKey:kScrollSpeed];
            //[self.timerScroll invalidate];
            self.timerScroll = [NSTimer scheduledTimerWithTimeInterval:1/speed target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
            self.isValidateTimer = true;
        }
        
    }
    
    
    
}

-(void)stopAutoScroll
{
    self.isautoscrollling = NO;
    [self.timerScroll invalidate];
    self.isValidateTimer = false;
    //hidden.enabled = FALSE;
}
//+20140929
- (void) expand:(id)sender{
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    [appDelegate hideMasterController];
    
    
    //+20140929
    UIBarButtonItem* collapse = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"resize_small.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(resize:)];
    
    self.navigationItem.rightBarButtonItem = collapse;
}
- (void) resize:(id)sender{
    
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    [appDelegate showMasterController];
    
    //+20140929
    UIBarButtonItem* expand = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"resize_full.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(expand:)];
    
    self.navigationItem.rightBarButtonItem = expand;
}

- (void) openNotes{
    
    NotesViewController *controller = [[NotesViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    //controller.delegate = self;
    
    if([UIDeviceHardware isIpad]){//+20110407
        
        
        controller.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    
    //UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:controller];
    
    //[[self navigationController] presentModalViewController:temp animated:YES];
    
    [self.navigationController pushViewController:controller animated:YES];
}
- (void) handleBookTap:(UITapGestureRecognizer *)recognizer {
    
    
    
    MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.savedLocation objectAtIndex:0]];//
    
    MBLog(@"dict = %@", dict);
    
    
    
    MalayalamBibleMasterViewController *masterViewController = [[MalayalamBibleMasterViewController alloc] init];
    UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [self.navigationController presentViewController:temp animated:YES completion:nil];
    
}
- (void) handleChapterTap:(UITapGestureRecognizer *)recognizer {
    
    if([UIDeviceHardware isIpad]){
        ChapterSelection *picker = [[ChapterSelection alloc] init];
        picker.selectedBook = self.selectedBook;
        picker.selectedChapter = self.chapterId;
        [picker configureView:NO];
        picker.delegate = self;
        
        //if(self.popoverChapterController == nil){
        self.popoverChapterController = [[UIPopoverController alloc] initWithContentViewController:picker];
        
        NSUInteger modv = self.selectedBook.numOfChapters % 6;
        NSUInteger ht = (self.selectedBook.numOfChapters / 6) * 50 + 15;
        if(modv > 0) ht += 50;
        [self.popoverChapterController setPopoverContentSize:CGSizeMake(320, MAX(70, ht))];
        
        //[self.popoverChapterController presentPopoverFromBarButtonItem:barBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
        CGRect frame1 = self.navigationController.navigationBar.frame;
        
        frame1.origin.y = 0.0;
        frame1.size.height = 1.0;
        /*if(![UIDeviceHardware isOS7Device]){
         frame1.size.height = 1;
         }else{
         frame1.size.height += 20;
         }*/
        
        
        [self.popoverChapterController presentPopoverFromRect:frame1 inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        
        ChapterSelection *picker = [[ChapterSelection alloc] init];
        picker.selectedBook = self.selectedBook;
        picker.selectedChapter = self.chapterId;
        [picker configureView:NO];
        
        //picker.delegate = self;
        UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:picker];
        [self.navigationController presentViewController:temp animated:YES completion:nil];
        
    }
    
    
}

- (void) actionClicked:(id)sender{
    
    
    //sorting
    [self.arrayToMookmark sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
    
    
    UIToolbar *toolBarShare = (UIToolbar *)[self.view viewWithTag:kTagShareToolbar];
    //the view controller you want to present as popover
    ActionViewController *controller = [[ActionViewController alloc] initWithDelegate:self AndTitile:[self getSelectedVerseTitle]];
    
    //our popover
    //if(popover == nil){
    
    
    // }
    
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    BOOL isios7 = NO;
    if([UIDeviceHardware isOS7Device]){
        
        isios7 = YES;
        appDelegate.window.tintColor = [UIColor lightGrayColor];
        
        imgArrowNext.tintColor = [UIColor darkGrayColor];
        if(imgArrowNext.alpha != .3f){
            imgArrowNext.alpha = .5;
        }
        imgArrowPrevious.tintColor = [UIColor darkGrayColor];
        MBLog(@"imgArrowPrevious.alpha = %f", imgArrowPrevious.alpha);
        if(imgArrowPrevious.alpha != .3f){
            MBLog(@"setting .5");
            imgArrowPrevious.alpha = .5;
        }
        imgArrowbooks.tintColor = [UIColor darkGrayColor];
        imgArrowbooks.alpha = .5;
        
        
        if(imgArrowChapter){
            imgArrowChapter.tintColor = [UIColor darkGrayColor];
            imgArrowChapter.alpha = .5;
        }
        
        //self.navigationItem.titleView.alpha = .5;
        
    }
    
    
    
    if([UIDeviceHardware isIpad]){
        
        
        if(isios7){
            self.popoverActionController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }else{
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            self.popoverActionController = [[UIPopoverController alloc] initWithContentViewController:nav];
        }
        
        if(isios7){
            self.popoverActionController.delegate = self;
        }
        
        [self.popoverActionController setPopoverContentSize:CGSizeMake(kActionViewWidth+20, 220)];//195
        
        CGRect frame1 = toolBarShare.frame;
        
        
        
        
        
        
        if([UIDeviceHardware isOS5Device]){
            
            UIScrollView *zview = self.webViewVerses.scrollView;
            
            frame1.origin.y -= zview.bounds.origin.y;
            
        }else{
            
            for (UIView* subView in [self.webViewVerses subviews])
            {
                if ([subView isKindOfClass:[UIScrollView class]]) {
                    
                    frame1.origin.y -= subView.bounds.origin.y;
                    break;
                }
            }
        }
        
        
        [self.popoverActionController presentPopoverFromRect:frame1 inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        
    }else{
        
        if(isios7){
            self.view.alpha = .8;
            self.webViewVerses.alpha = .8;
            self.navigationController.navigationBar.alpha = .8;
            
            [self.tableViewVerses setNeedsDisplay];
        }
        
        popover = [[FPPopoverController alloc] initWithViewController:controller];
        if(isios7){
            popover.delegate = self;
        }
        [popover setContentSize:CGSizeMake(kActionViewWidth, 220)];
        
        [popover presentPopoverFromView:toolBarShare];
    }
    
    
    //the popover will be presented from the okButton view
    
    
    return;
    //self.bottomToolBar.hidden = YES;
    /*
     UIView *tranView = [[UIView alloc] initWithFrame:self.view.frame];
     tranView.backgroundColor = [UIColor lightGrayColor];
     tranView.alpha = 0.3;
     tranView.tag = kTagTrasparentView;
     
     UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(dismissTranparent:)];
     
     
     [tranView addGestureRecognizer:singleFingerTap];
     
     
     
     //self.navigationController.navigationBar.userInteractionEnabled = NO;
     
     UIView *tranView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
     tranView2.backgroundColor = [UIColor lightGrayColor];
     tranView2.alpha = 0.3;
     tranView2.tag = kTagNavBarTrasparentView;
     [self.navigationController.navigationBar addSubview:tranView2];
     
     */
    
    
    
    //[self.view addSubview:tranView];
    
    //[self.view bringSubviewToFront:toolbarAction];
}
- (void) showPreferences:(id)sender{
    
    SettingsViewController *ctrlr = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:ctrlr animated:YES];
    
    
    //SearchViewController *ctrlr = [[SearchViewController alloc] init];
    //ctrlr.detailViewController = self;
    //[self.navigationController pushViewController:ctrlr animated:YES];
}
- (void) doSearch:(id)sender{
    
    if(!self.searchController){
        
        self.searchController = [[SearchViewController alloc] init];
    }
    self.searchController.selectedBook = self.selectedBook;
    self.searchController.detailViewController = self;//CFBridgingRelease((__bridge void*)self);
    [self.navigationController pushViewController:self.searchController animated:YES];
}
/*
 - (void) zoominBtnClicked:(id)sender{
 
 if(FONT_SIZE < kFontMaxSize){
 
 ++FONT_SIZE;
 BibleDao *bDao = [[BibleDao alloc] init];
 //self.bVerses = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
 NSDictionary *ddict = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
 self.bVerses = [ddict valueForKey:@"verse_array"];
 [self.tableViewVerses reloadData];
 
 [[NSUserDefaults standardUserDefaults] setInteger:FONT_SIZE forKey:@"fontSize"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:nil];
 
 }
 //if(FONT_SIZE >= kFontMaxSize){
 
 [self resetBottomToolbar];
 //}
 }
 - (void) zoomoutBtnClicked:(id)sender{
 
 if(FONT_SIZE > kFontMinSize){
 
 --FONT_SIZE;
 BibleDao *bDao = [[BibleDao alloc] init];
 //self.bVerses = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
 NSDictionary *ddict = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
 self.bVerses = [ddict valueForKey:@"verse_array"];
 [self.tableViewVerses reloadData];
 
 [[NSUserDefaults standardUserDefaults] setInteger:FONT_SIZE forKey:@"fontSize"];
 [[NSUserDefaults standardUserDefaults] synchronize];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:nil];
 }
 //if(FONT_SIZE <= kFontMinSize){
 
 [self resetBottomToolbar];
 //}
 }
 **/
/*- (void) actionPerformed:(id)sender{
 
 self.isActionClicked = YES;
 NSMutableArray *arrayOfTools = [[NSMutableArray alloc] initWithCapacity:3];
 
 
 UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
 
 
 
 UIBarButtonItem *flex = [[UIBarButtonItem alloc]
 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
 target:nil action:nil];
 
 
 UIBarButtonItem *email = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"email", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(emailVerses:)];
 
 UIBarButtonItem *copyText = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"copy", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(copySelectedVerses:)];
 
 [arrayOfTools addObject:email];
 [arrayOfTools addObject:copyText];
 [arrayOfTools addObject:flex];
 [arrayOfTools addObject:cancel];
 
 self.bottomToolBar.items = arrayOfTools;
 
 
 self.tableViewVerses.editing = YES;
 IF_IOS5_OR_GREATER(
 self.tableViewVerses.allowsMultipleSelectionDuringEditing = YES;
 )
 [self.tableViewVerses reloadData];
 
 }
 */
- (void) nextPreviousTap:(UITapGestureRecognizer *)recognizer{
    
    UIView *vieww = recognizer.view;
    switch(vieww.tag) {
        case 0:
            //self.chapterId--;
            [self moveToNext:NO];
            break;
        case 1:
            //self.chapterId++;
            [self moveToNext:YES];
            break;
    }
}
- (void) nextPrevious:(id)sender
{
    
    switch(((UIButton *)sender).tag) {
        case 0:
            //self.chapterId--;
            [self moveToNext:NO];
            break;
        case 1:
            //self.chapterId++;
            [self moveToNext:YES];
            break;
    }
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     [self configureiPadView];
     }
     else {
     [self configureView];
     }*/
}
/**
 - (void) emailVerses:(id)sender{
 
 NSArray *arraySelectedIndesPath = [self.tableViewVerses indexPathsForSelectedRows];
 
 
 
 Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
 if (mailClass != nil)
 {
 // We must always check whether the current device is configured for sending emails
 if ([mailClass canSendMail])
 {
 [self displayComposerSheet:arraySelectedIndesPath];
 }
 
 }
 }
 - (void) copySelectedVerses:(id)sender{
 
 
 NSArray *arraySelectedIndesPath = [self.tableViewVerses indexPathsForSelectedRows];
 
 NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
 NSString *secondaryL = kLangNone;
 if(dictPref !=nil ){
 secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
 }
 
 
 NSMutableString *verseStr = [[NSMutableString alloc] init ];
 [verseStr appendFormat:@"%@", self.selectedBook.shortName];
 [verseStr appendFormat:@" %i", self.chapterId];
 
 NSUInteger countV = [arraySelectedIndesPath count];
 
 if(countV == 0){
 
 
 }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
 
 NSIndexPath *path = [arraySelectedIndesPath objectAtIndex:0];
 [verseStr appendFormat:@" : %@\n", [[self.bVerses objectAtIndex:path.row] valueForKey:@"verse_text"]];
 
 }else{
 
 [verseStr appendFormat:@"\n"];
 for(NSUInteger i=0; i<countV ; i++ ){
 
 NSIndexPath *path = [arraySelectedIndesPath objectAtIndex:i];
 [verseStr appendFormat:@"%@\n", [[self.bVerses objectAtIndex:path.row] valueForKey:@"verse_text"]];
 }
 }
 
 
 UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
 
 
 pasteboard.string = verseStr;
 }
 **/
/*
 - (void) cancelAction:(id)sender{
 
 self.isActionClicked = NO;
 
 [self resetBottomToolbar];
 
 self.tableViewVerses.editing = NO;
 IF_IOS5_OR_GREATER(
 self.tableViewVerses.allowsMultipleSelectionDuringEditing = NO;
 )
 [self.tableViewVerses reloadData];
 
 }
 */

- (void) openColordVerses{
    
    HighlightTableViewController *ctrlr = [[HighlightTableViewController alloc] init];
    [self.navigationController pushViewController:ctrlr animated:YES];
    
}
- (void) openBookmarks{
    
    
    
    BookMarkViewController *bmctrlr = [[BookMarkViewController alloc] initWithStyle:UITableViewStyleGrouped BMFolder:nil];
    bmctrlr.detailViewController = self;
    [self.navigationController pushViewController:bmctrlr animated:YES];
    
    
    
}
/*
 - (void) openChapters{
 
 ChapterSelection *picker = [[ChapterSelection alloc] init];
 picker.selectedBook = self.selectedBook;
 picker.selectedChapter = self.chapterId;
 [picker configureView:NO];
 
 //picker.delegate = self;
 UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:picker];
 [self.navigationController presentModalViewController:temp animated:YES];
 }
 */
/*
 - (void)showChapters:(UIBarButtonItem *)barBtn{
 
 ChapterSelection *picker = [[ChapterSelection alloc] init];
 picker.selectedBook = self.selectedBook;
 picker.selectedChapter = self.chapterId;
 [picker configureView:NO];
 picker.delegate = self;
 
 if(self.popoverChapterController == nil){
 self.popoverChapterController = [[UIPopoverController alloc] initWithContentViewController:picker];
 
 }else{
 
 [self.popoverChapterController setContentViewController:picker];
 }
 NSUInteger modv = self.selectedBook.numOfChapters % 6;
 NSUInteger ht = (self.selectedBook.numOfChapters / 6) * 50 + 15;
 if(modv > 0) ht += 50;
 [self.popoverChapterController setPopoverContentSize:CGSizeMake(320, MAX(70, ht))];
 
 [self.popoverChapterController presentPopoverFromBarButtonItem:barBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 
 }
 */
#pragma mark ButtonClickDelegate

- (void) clearSelections{
    
    [[self.view viewWithTag:kTagTrasparentView] removeFromSuperview];
    
    [[self.navigationController.navigationBar viewWithTag:kTagNavBarTrasparentView] removeFromSuperview];
    
    [[self.view viewWithTag:kTagActionToolbar] removeFromSuperview];
    
    [[self.view viewWithTag:kTagShareToolbar] removeFromSuperview];
    
    
    self.bottomToolBar.hidden = NO;
    
    
    for(int i=0; i<self.arrayToMookmark.count ; i++){
        
        NSString *row = [self.arrayToMookmark objectAtIndex:i];
        
        NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
        
        NSString *divid = [NSString stringWithFormat:@"Font-%@",[dict valueForKey:@"verseid"]];
        
        NSMutableString *command = [NSMutableString stringWithFormat:@"toggleSelection('%@')", divid];
        //NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"yellow\")", divid];
        
        MBLog(@"command = %@", command);
        
        [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    }
    
    [self.arrayToMookmark removeAllObjects];
    
    
}
- (void) buttonClicked:(UIButton *)sender{
    
    [self buttonClickedWithTag:sender.tag];
}
- (void) buttonClickedWithTag:(NSInteger)actionTag{
    
    //(@"dddd");
    if(popover){
        //(@"fbpop smsiss");
        [popover dismissPopoverAnimated:YES];
    }
    if(self.popoverActionController){
        
        //(@"popover dismsiss");
        [self.popoverActionController dismissPopoverAnimated:YES];
        [self.popoverActionController.delegate popoverControllerDidDismissPopover:self.popoverActionController];
    }
    
    if(actionTag == kActionClear){
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if([def valueForKey:@"easteregg"]){
            
            MBLog(@"self.arrayToMookmark = %@", self.arrayToMookmark);
            
            if(self.arrayToMookmark.count == 1 ){
                
                NSString *row = [self.arrayToMookmark objectAtIndex:0];
                NSDictionary *dict4 = [self.bVerses objectAtIndex:[row integerValue]];
                
                MBLog(@"dict4 = %@", dict4);
                
                if([dict4 valueForKey:@"versetoedit"]){
                    VerseEditViewController *cc = [[VerseEditViewController alloc] initWithVerse:dict4 BookId:self.selectedBook.bookId AndChapterId:self.chapterId];
                    [self.navigationController pushViewController:cc animated:YES];
                }
            }
            
            
        }else{
            
            [self removeColorsFromDB];
            /***/
            
            
            for(int i=0; i<self.arrayToMookmark.count ; i++){
                
                NSString *row = [self.arrayToMookmark objectAtIndex:i];
                
                NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
                
                NSString *divid = [NSString stringWithFormat:@"Font-%@",[dict valueForKey:@"verseid"]];
                
                NSMutableString *command = [NSMutableString stringWithFormat:@"deSelectVerse(\"%@\")", divid];
                //NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"yellow\")", divid];
                
                MBLog(@"command = %@", command);
                
                [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
            }
            
            [self.arrayToMookmark removeAllObjects];
        }
        
        
        
    }else if(actionTag == kActionColor1 || actionTag == kActionColor2 || actionTag == kActionColor3 || actionTag == kActionColor4 || actionTag == kActionColor5){
        
        
        [self removeColorsFromDB];
        
        
        
        NSString *colorClass = kStoreColor1;
        if(actionTag == kActionColor2){
            colorClass = kStoreColor2;
        }else if(actionTag == kActionColor3){
            colorClass = kStoreColor3;
        }else if(actionTag == kActionColor4){
            colorClass = kStoreColor4;
        }else if(actionTag == kActionColor5){
            colorClass = kStoreColor5;
        }
        MBLog(@"setting color %@", colorClass);
        /*********/
        MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context =  [appDelegate managedObjectContext];
        
        for(int i=0; i<self.arrayToMookmark.count ; i++){
            
            NSString *row = [self.arrayToMookmark objectAtIndex:i];
            
            NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
            
            NSNumber *verseid = [NSNumber numberWithInteger:[[dict valueForKey:@"verseid"] integerValue]];
            
            ColordVerses *bookMarktoSave = [NSEntityDescription insertNewObjectForEntityForName:@"ColordVerses" inManagedObjectContext:context];
            
            [bookMarktoSave setBookid:[NSNumber numberWithInteger:self.selectedBook.bookId]];
            [bookMarktoSave setChapter:[NSNumber numberWithInteger:self.chapterId]];
            [bookMarktoSave setVerseid:verseid];
            [bookMarktoSave setColorcode:colorClass];
            [bookMarktoSave setCreateddate:[NSDate date]];
            [bookMarktoSave setVersion:[dict valueForKey:@"verse_text"]];
            //[bookMarktoSave setColorindex:[NSNumber numberWithInt:actionTag]];
            
            NSError *error;
            [context save:&error];
            
            
        }
        
        
        /*********/
        
        
        [[self.view viewWithTag:kTagTrasparentView] removeFromSuperview];
        
        [[self.navigationController.navigationBar viewWithTag:kTagNavBarTrasparentView] removeFromSuperview];
        
        [[self.view viewWithTag:kTagActionToolbar] removeFromSuperview];
        
        [[self.view viewWithTag:kTagShareToolbar] removeFromSuperview];
        
        
        self.bottomToolBar.hidden = NO;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        for(int i=0; i<self.arrayToMookmark.count ; i++){
            
            NSString *row = [self.arrayToMookmark objectAtIndex:i];
            
            NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
            
            NSString *divid = [NSString stringWithFormat:@"Font-%@",[dict valueForKey:@"verseid"]];
            
            NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"%@\")", divid, [def valueForKey:colorClass]];
            //NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"yellow\")", divid];
            
            MBLog(@"command = %@", command);
            
            [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
        }
        
        [self.arrayToMookmark removeAllObjects];
        
        
    }else{
        if(actionTag == kActionCopy){
            
            
            //make objects as NSNumber and sort
            
            NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
            NSString *secondaryL = kLangNone;
            if(dictPref !=nil ){
                secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
            }
            
            
            NSMutableString *verseStr = [[NSMutableString alloc] init ];
            [verseStr appendFormat:@"%@", self.selectedBook.shortName];
            [verseStr appendFormat:@" %li", (long)self.chapterId];
            
            NSUInteger countV = [self.arrayToMookmark count];
            
            if(countV == 0){
                
                
            }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
                
                NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:0] integerValue]];
                [verseStr appendFormat:@" : %@\n", [dict valueForKey:@"verse_text"]];
                
            }else{
                
                [verseStr appendFormat:@"\n"];
                for(NSUInteger i=0; i<countV ; i++ ){
                    
                    NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                    [verseStr appendFormat:@"%@\n", [dict valueForKey:@"verse_text"]];
                }
            }
            
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            
            
            pasteboard.string = verseStr;
            
            [self.view makeToast:@"Verses copied. Paste anywhere." duration:1.5 position:@"center"];
            
        }else if(actionTag == kActionMail){
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass != nil)
            {
                // We must always check whether the current device is configured for sending emails
                if ([mailClass canSendMail])
                {
                    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
                    NSString *secondaryL = kLangNone;
                    if(dictPref !=nil ){
                        secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
                    }
                    
                    
                    NSMutableString *emailBody = [[NSMutableString alloc] init ];
                    [emailBody appendFormat:@"%@", self.selectedBook.shortName];
                    [emailBody appendFormat:@" %li", (long)self.chapterId];
                    
                    NSUInteger countV = [self.arrayToMookmark count];
                    
                    if(countV == 0){
                        
                        //return ? or mail entire chapter ?
                        
                    }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
                        
                        NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:0] integerValue]];
                        [emailBody appendFormat:@" : %@\n", [dict valueForKey:@"verse_text"]];
                        
                    }else{
                        
                        [emailBody appendFormat:@"\n"];
                        for(NSUInteger i=0; i<countV ; i++ ){
                            
                            NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                            [emailBody appendFormat:@"%@\n", [dict valueForKey:@"verse_text"]];
                        }
                    }
                    
                    
                    
                    [emailBody appendFormat:@"\n%@", NSLocalizedString(@"MailFooter", @"footer message")];
                    
                    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                    picker.mailComposeDelegate = self;
                    
                    [picker setSubject:@"Bible Verses"];
                    
                    [picker setMessageBody:emailBody isHTML:NO];
                    
                    [self.navigationController presentViewController:picker animated:YES completion:nil];
                    
                }
                
            }
        }else if(actionTag == kActionSMS){
            
            //+20130905
            Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
            if(smsClass != nil)
            {
                if ([smsClass canSendText])
                {
                    
                    NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
                    NSString *secondaryL = kLangNone;
                    if(dictPref !=nil ){
                        secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
                    }
                    
                    
                    NSMutableString *emailBody = [[NSMutableString alloc] init ];
                    [emailBody appendFormat:@"%@", self.selectedBook.shortName];
                    [emailBody appendFormat:@" %li", (long)self.chapterId];
                    
                    NSUInteger countV = [self.arrayToMookmark count];
                    
                    if(countV == 0){
                        
                        //return ? or mail entire chapter ?
                        
                    }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
                        
                        NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:0] integerValue]];
                        [emailBody appendFormat:@" : %@\n", [dict valueForKey:@"verse_text"]];
                        
                    }else{
                        
                        [emailBody appendFormat:@"\n"];
                        for(NSUInteger i=0; i<countV ; i++ ){
                            
                            NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                            [emailBody appendFormat:@"%@\n", [dict valueForKey:@"verse_text"]];
                        }
                    }
                    
                    [self presentMessageComposeViewController:emailBody];
                }
            }
            
        }else if(actionTag == kActionBookmark){
            
            //NSMutableString *versetitle = [NSMutableString stringWithFormat:@"%@ %i:", self.selectedBook.shortName, self.chapterId];
            NSString *versetext = nil;
            NSMutableString *verseid = [NSMutableString string];
            for(int i=0 ; i<[self.arrayToMookmark count]; i++){
                
                if(verseid.length > 0){
                    [verseid appendString:@","];
                }
                NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                [verseid appendFormat:@"%@",[dict valueForKey:@"verseid"]];
                
                if (versetext == nil ){
                    versetext = [dict valueForKey:@"verse_text"];
                }
            }
            //[versetitle appendString:verseid];
            
            
            
            //get default - bookmarkid=nil
            //Folder
            BibleDao *daoo = [[BibleDao alloc] init];
            
            Folders *folder = [daoo getDefaultFolder];
            
            
            MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =  [appDelegate managedObjectContext];
            //BookMarks *bookMark = [NSEntityDescription insertNewObjectForEntityForName:@"BookMarks" inManagedObjectContext:nil];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"BookMarks" inManagedObjectContext:context];
            BookMarks *bookMark = [[BookMarks alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
            
            [bookMark setVersetitle:[self getSelectedVerseTitle]];
            [bookMark setBookid:[NSNumber numberWithInteger:self.selectedBook.bookId]];
            [bookMark setChapter:[NSNumber numberWithInteger:self.chapterId]];
            [bookMark setVerseid:verseid];
            
            BookmarkAddViewController *controller = [[BookmarkAddViewController alloc] initWithStyle:UITableViewStyleGrouped];
            controller.bookMark = bookMark;
            controller.defaultFolder = folder;
            controller.delegate = self;
            controller.verseText = versetext;
            
            UINavigationController *navCtrlr = [[UINavigationController alloc] initWithRootViewController:controller];
            //controller.delegate = self;
            
            if([UIDeviceHardware isIpad]){//+20110407
                
                
                navCtrlr.modalPresentationStyle = UIModalPresentationPageSheet;
            }
            
            
            [[self navigationController] presentViewController:navCtrlr animated:YES completion:nil];
            
            
            
            
            
            
            
            
            
        }else if(actionTag == kActionFB){
            
            NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
            NSString *secondaryL = kLangNone;
            if(dictPref !=nil ){
                secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
            }
            
            
            NSMutableString *emailBody = [[NSMutableString alloc] init ];
            [emailBody appendFormat:@"%@", self.selectedBook.shortName];
            [emailBody appendFormat:@" %li", (long)self.chapterId];
            
            NSUInteger countV = [self.arrayToMookmark count];
            
            if(countV == 0){
                
                //return ? or mail entire chapter ?
                
            }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
                
                NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:0] integerValue]];
                [emailBody appendFormat:@" : %@\n", [dict valueForKey:@"verse_text"]];
                
            }else{
                
                [emailBody appendFormat:@"\n"];
                for(NSUInteger i=0; i<countV ; i++ ){
                    
                    NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                    [emailBody appendFormat:@"%@\n", [dict valueForKey:@"verse_text"]];
                }
            }
            
            SLComposeViewController *objvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            //setting the text to post
            [objvc setInitialText:emailBody];
            
            
            [self presentViewController:objvc animated:YES
                             completion:nil];
            
            objvc.completionHandler = ^(SLComposeViewControllerResult result)
            {
                if (result == SLComposeViewControllerResultDone) {
                    [self.view makeToast:@"Verses posted to Facebook" duration:1.5 position:@"center"];
                }
                /*
                 else if (result == SLComposeViewControllerResultCancelled)
                 {
                 UIAlertView *objresponseAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Action cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [objresponseAlert show];
                 }
                 */
                
            };
            
        }else if(actionTag == kActionTwitter){
            
            NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
            NSString *secondaryL = kLangNone;
            if(dictPref !=nil ){
                secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
            }
            
            
            NSMutableString *emailBody = [[NSMutableString alloc] init ];
            [emailBody appendFormat:@"%@", self.selectedBook.shortName];
            [emailBody appendFormat:@" %li", (long)self.chapterId];
            
            NSUInteger countV = [self.arrayToMookmark count];
            
            if(countV == 0){
                
                //return ? or mail entire chapter ?
                
            }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
                
                NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:0] integerValue]];
                [emailBody appendFormat:@" : %@\n", [dict valueForKey:@"verse_text"]];
                
            }else{
                
                [emailBody appendFormat:@"\n"];
                for(NSUInteger i=0; i<countV ; i++ ){
                    
                    NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] integerValue]];
                    [emailBody appendFormat:@"%@\n", [dict valueForKey:@"verse_text"]];
                }
            }
            
            
            SLComposeViewController *objvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            //setting the text to post
            [objvc setInitialText:emailBody];
            
            
            [self presentViewController:objvc animated:YES
                             completion:nil];
            
            objvc.completionHandler = ^(SLComposeViewControllerResult result)
            {
                if (result == SLComposeViewControllerResultDone) {
                    [self.view makeToast:@"Verses posted to Twitter" duration:1.5 position:@"center"];
                }
                /*
                 else if (result == SLComposeViewControllerResultCancelled)
                 {
                 UIAlertView *objresponseAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Action cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [objresponseAlert show];
                 }
                 */
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:NO completion:^{
                        
                    }];
                });
                
                //[self.editorView becomeFirstResponder];+20130909
            };
            
            
            
        }/*else if(actionTag == kActionNotes){
          
          NSMutableString *verseid = [NSMutableString string];
          for(int i=0 ; i<[self.arrayToMookmark count]; i++){
          
          if(verseid.length > 0){
          [verseid appendString:@","];
          }
          NSDictionary *dict = [self.bVerses objectAtIndex:[[self.arrayToMookmark objectAtIndex:i] intValue]];
          [verseid appendFormat:@"%@",[dict valueForKey:@"verseid"]];
          
          }
          
          
          
          
          //get default - bookmarkid=nil
          //Folder
          BibleDao *daoo = [[BibleDao alloc] init];
          
          Folders *folder = [daoo getDefaultFolderOfNotes];
          
          MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
          NSManagedObjectContext *context =  [appDelegate managedObjectContext];
          //BookMarks *bookMark = [NSEntityDescription insertNewObjectForEntityForName:@"BookMarks" inManagedObjectContext:nil];
          
          Notes *newNot = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext:context];
          //Notes *newNot = [[Notes alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
          
          
          [newNot setBookid:[NSNumber numberWithInt:self.selectedBook.bookId]];
          [newNot setChapter:[NSNumber numberWithInt:self.chapterId]];
          [newNot setVerseid:verseid];
          [newNot setFolder:folder];
          
          NotesAddViewController *contrlr = [[NotesAddViewController alloc] init];
          contrlr.notesNew = newNot;
          contrlr.verseTitle = [self getSelectedVerseTitle];
          UINavigationController *navCtrlr = [[UINavigationController alloc] initWithRootViewController:contrlr];
          //controller.delegate = self;
          
          if([UIDeviceHardware isIpad]){
          
          
          navCtrlr.modalPresentationStyle = UIModalPresentationPageSheet;
          }
          
          [[self navigationController] presentModalViewController:navCtrlr animated:YES];
          }*/
        
        
    }
    [self clearSelections];
    
}
#pragma mark mail actions
/**
 -(void)displayComposerSheet:(NSArray *)arraySelectedIndesPath{
	
 NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
 NSString *secondaryL = kLangNone;
 if(dictPref !=nil ){
 secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
 }
 
 
 NSMutableString *emailBody = [[NSMutableString alloc] init ];
 [emailBody appendFormat:@"%@", self.selectedBook.shortName];
 [emailBody appendFormat:@" %i", self.chapterId];
 
 NSUInteger countV = [arraySelectedIndesPath count];
 
 if(countV == 0){
 
 //return ? or mail entire chapter ?
 
 }else if(countV == 1 && [secondaryL isEqualToString:kLangNone]){
 
 NSIndexPath *path = [arraySelectedIndesPath objectAtIndex:0];
 [emailBody appendFormat:@" : %@\n", [[self.bVerses objectAtIndex:path.section] valueForKey:@"verse_text"]];
 
 }else{
 
 [emailBody appendFormat:@"\n"];
 for(NSUInteger i=0; i<countV ; i++ ){
 
 NSIndexPath *path = [arraySelectedIndesPath objectAtIndex:i];
 [emailBody appendFormat:@"%@\n", [[self.bVerses objectAtIndex:path.section] valueForKey:@"verse_text"]];
 }
 }
 
 
 
 [emailBody appendFormat:@"\n%@", NSLocalizedString(@"MailFooter", @"footer message")];
 
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Bible Verses"];
	
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self.navigationController presentModalViewController:picker animated:YES];
	
	
 }
 **/
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            //(@"Result: saved");
            //[self cancelAction:self];
            break;
        case MFMailComposeResultSent:
            //(@"Result: sent");
            //[self cancelAction:self];
            break;
        case MFMailComposeResultFailed:
            //(@"Result: failed");
            break;
        default:
            //(@"Result: not sent");
            break;
    }
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark NotifyTableReload

- (void)refreshList:(NSNotification *)note
{
    
    
    
    NSDictionary *dictInfo =  [note userInfo];
    
    self.searchController = nil;//+20131210
    
    BOOL isModeChanged = [[dictInfo valueForKey:@"modechanged"] boolValue];
    if(isModeChanged){
        
        [self modeChangeDynamically];
        [self configureView];
        
    }else{
        
        NSMutableDictionary *dictPref = [[NSUserDefaults standardUserDefaults] objectForKey:kStorePreference];
        NSString *secondaryL = kLangNone;
        if(dictPref !=nil ){
            secondaryL = [dictPref valueForKey:@"secondaryLanguage"];
            
        }
        
        BibleDao *bDao = [[BibleDao alloc] init];
        
        NSDictionary *ddict = [bDao getChapter:self.selectedBook.bookId Chapter:self.chapterId];
        self.bVerses = [ddict valueForKey:@"verse_array"];
        
        NSString *fullverse = [ddict valueForKey:@"fullverse"];
        
        
        self.isLoaded = NO;
        
        self.isWebViewLoaded = NO;
        [self.webViewVerses loadHTMLString:fullverse  baseURL:[MBUtils getBaseURL]];
        
        [self.tableViewVerses reloadData];
    }
    
}

#pragma mark UIWebviewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    //self.isJSWebViewLoaded = YES;
    ///+20131114
    
    self.isWebViewLoaded = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)wView {
    
    
    
    self.isWebViewLoaded = YES;
    //self.isJSWebViewLoaded = YES;
    //self.isLoaded = NO;
    MBLog(@"set no");
    [self scrollToVerseId];
    [self loadSelections];
    MBLog(@"set yes");
    //self.isLoaded = YES;
    
    //[self.webViewVerses stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",      (int)self.webViewVerses.frame.size.width]];
    
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSURL *meltUrl = [request URL];
    
    //NSString *url = [meltUrl absoluteString];
    
    NSString *scheme = [meltUrl scheme].lowercaseString;
    
    if ( [scheme isEqualToString:@"melt"]) {
        
        NSString *pathsegment = [meltUrl path];
        if (pathsegment.length > 0) {
            
            NSString *fnName = [[meltUrl host] stringByAppendingString:@":"];
            
            MBLog(@"fnName = %@", fnName);
            
            MBLog(@"pathsegment = %@", pathsegment);
            
            if ([@"chapterClicked:" isEqualToString:fnName] || [@"verseClicked:" isEqualToString:fnName] || [@"endscroll:" isEqualToString:fnName]) {
                
                NSString *parameter = [pathsegment substringFromIndex:1];
                [self performSelectorOnMainThread:NSSelectorFromString(fnName) withObject:parameter waitUntilDone:NO];
            }
        }
        
        
        
        return NO;
        
    }else{
        
        
    }
    
    return YES;
}
- (void) endscroll:(NSString *)row{
    
    MBLog(@"set yes");
    self.isLoaded = YES;
    
}
- (void) chapterClicked:(NSString *)row{
    MBLog(@"chapterClicked = %@", row);
    
}
- (void) verseClicked:(NSString *)row{
    
    [self stopAutoScroll];
    
    MBLog(@"verseClicked = %@", row);
    if(self.arrayToMookmark == nil){
        
        self.arrayToMookmark = [NSMutableArray array];
    }
    
    BOOL isSelecte = NO;
    
    if([self.arrayToMookmark containsObject:row]){
        
        [self.arrayToMookmark removeObject:row];
    }else{
        
        isSelecte = YES;
        [self.arrayToMookmark addObject:row];
    }
    
    
    
    
    MBLog(@"self.arrayToMookmark = %@", self.arrayToMookmark);
    
    NSDictionary *dict = [self.bVerses objectAtIndex:[row integerValue]];
    
    NSString *divid = [NSString stringWithFormat:@"Font-%@",[dict valueForKey:@"verseid"]];
    
    NSMutableString *command = [NSMutableString stringWithFormat:@"toggleSelection('%@')", divid];
    //NSMutableString *command = [NSMutableString stringWithFormat:@"selectVerse(\"%@\", \"yellow\")", divid];
    
    
    
    MBLog(@"command = %@", command);
    
    [self.webViewVerses stringByEvaluatingJavaScriptFromString:command];
    
    
    UIToolbar *toolBarShare = (UIToolbar *)[self.view viewWithTag:kTagShareToolbar];
    
    
    
    if(!toolBarShare && self.arrayToMookmark.count == 1){
        
        
        NSMutableString *command2 = [NSMutableString stringWithFormat:@"getPosition('Verse-%@')", [dict valueForKey:@"verseid"]];
        MBLog(@"command2 = %@", command2);
        NSString *ss = [self.webViewVerses stringByEvaluatingJavaScriptFromString:command2];
        
        CGRect frma2 = self.webViewVerses.frame;
        
        CGFloat ypos = [ss integerValue];
        
        toolBarShare = [[UIToolbar alloc] initWithFrame:CGRectMake(frma2.size.width-70, ypos, 70, 28)];
        if ([UIDeviceHardware isOS7Device]) {
            toolBarShare.tintColor = [UIColor defaultWindowColor];
        }
        if([UIDeviceHardware isOS7Device]){
            [toolBarShare setBarTintColor:[UIColor whiteColor]];
            
        }else{
            toolBarShare.barStyle = UIBarStyleBlackTranslucent;
        }
        
        
        UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionClicked:)];
        toolBarShare.tag = kTagShareToolbar;
        [toolBarShare.layer setMasksToBounds:YES];
        
        [toolBarShare.layer setCornerRadius:3.0];
        [toolBarShare.layer setBorderWidth:.01];
        
        toolBarShare.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        
        UILabel *lbl = [[UILabel alloc] init];
        if([UIDeviceHardware isOS7Device]){
            
            //MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            lbl.textColor = [UIColor blackColor];
            [toolBarShare.layer setBorderWidth:.7];
            [toolBarShare.layer setBorderColor:[UIColor defaultWindowColor].CGColor];//+20140312 appDelegate.window.tintColor.CGColor];
        }else{
            lbl.textColor = [UIColor whiteColor];
            //[toolBarShare.layer setBorderWidth:.01];
        }
        
        lbl.font = [UIFont systemFontOfSize:15];
        NSString *txtt = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrayToMookmark.count];
        CGSize sizee = [@"55" sizeWithFont:lbl.font];
        lbl.tag = kTagShareLabelCount;
        lbl.frame = CGRectMake(0, 0, sizee.width, 28);
        
        lbl.text = txtt;
        lbl.backgroundColor = [UIColor clearColor];
        UIBarButtonItem *itemspace = [[UIBarButtonItem alloc] initWithCustomView:lbl];

        
        UIBarButtonItem *flexx1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexx1.width = 1;
        UIBarButtonItem *flexx2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexx2.width = 1;
        UIBarButtonItem *flexx3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        flexx3.width = 1;
        
        toolBarShare.items = [NSArray arrayWithObjects: itemspace,itemShare,flexx3,nil];
        
        //+20150823
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(actionClicked:)];
        singleFingerTap.numberOfTapsRequired = 1;
        [toolBarShare addGestureRecognizer:singleFingerTap];
        
        if([UIDeviceHardware isOS5Device]){
            
            [self.webViewVerses.scrollView addSubview:toolBarShare];
            
        }else{
            
            for (UIView* subView in [self.webViewVerses subviews])
            {
                if ([subView isKindOfClass:[UIScrollView class]]) {
                    
                    [subView addSubview:toolBarShare];
                    break;
                }
            }
        }
        
    }else{
        
        if(self.arrayToMookmark.count > 0){
            
            NSString *rowInd = [self.arrayToMookmark lastObject];
            
            NSDictionary *dict = [self.bVerses objectAtIndex:[rowInd integerValue]];
            NSMutableString *command2 = [NSMutableString stringWithFormat:@"getPosition('Verse-%@')", [dict valueForKey:@"verseid"]];
            
            MBLog(@"command2 = %@", command2);
            
            NSString *ss = [self.webViewVerses stringByEvaluatingJavaScriptFromString:command2];
            
            
            UILabel *toolbarlabel = (UILabel *)[toolBarShare viewWithTag:kTagShareLabelCount];
            toolbarlabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrayToMookmark.count];
            
            
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.1];
            CGRect frme = toolBarShare.frame;
            frme.origin.y = [ss integerValue];
            
            toolBarShare.frame = frme;
            [UIView commitAnimations];
            
        }
        
    }
    
    
    
    
    
    
    
    if(self.arrayToMookmark.count == 0){
        
        [[self.view viewWithTag:kTagShareToolbar] removeFromSuperview];
    }
    
    /*
     
     NSMutableDictionary *dictt = [self.bVerses objectAtIndex:[row intValue]];
     
     NSMutableString *versehtml = [NSMutableString stringWithString:[dictt valueForKey:@"verse_html"]];
     
     //(@"versehtml = %@", versehtml);
     //text-decoration: none; border-bottom:1px dotted;
     NSRange rangeexist = [versehtml rangeOfString:@"class=\"underline\" "];
     if(rangeexist.length > 0){
     
     [self.arrayToMookmark removeObject:row];//[dictt valueForKey:@"verseid"]];
     
     [versehtml deleteCharactersInRange:rangeexist];
     
     [dictt setValue:versehtml forKey:@"verse_html"];
     
     if(self.arrayToMookmark.count == 0){
     
     [[self.view viewWithTag:kTagShareToolbar] removeFromSuperview];
     }
     
     }else{
     
     if(self.arrayToMookmark == nil){
     
     self.arrayToMookmark = [NSMutableArray array];
     }
     
     [self.arrayToMookmark addObject:row];//[dictt valueForKey:@"verseid"]];
     
     NSRange range = [versehtml rangeOfString:@"<div "];// style=
     
     //text-decoration:underline
     
     [versehtml insertString:@"class=\"underline\" " atIndex:range.location+range.length];
     
     //(@"versehtml after= %@", versehtml);
     [dictt setValue:versehtml forKey:@"verse_html"];
     
     
     if(self.arrayToMookmark.count == 1){
     
     CGRect frma2 = self.view.frame;
     
     CGFloat ypos = frma2.size.height-80;
     if(isFullScreen){
     ypos = frma2.size.height-35;
     }
     
     UIToolbar *toolBarShare = [[UIToolbar alloc] initWithFrame:CGRectMake(frma2.size.width-100, ypos, 70, 28)];
     //toolBarShare.tintColor = [UIColor blackColor];
     toolBarShare.barStyle = UIBarStyleBlackTranslucent;
     UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionClicked:)];
     toolBarShare.tag = kTagShareToolbar;
     [toolBarShare.layer setMasksToBounds:YES];
     
     [toolBarShare.layer setCornerRadius:3.0];
     [toolBarShare.layer setBorderWidth:.01];
     
     
     
     UILabel *lbl = [[UILabel alloc] init];
     lbl.textColor = [UIColor whiteColor];
     lbl.font = [UIFont systemFontOfSize:15];
     NSString *txtt = [NSString stringWithFormat:@"%i", self.arrayToMookmark.count];
     CGSize sizee = [txtt sizeWithFont:lbl.font];
     
     lbl.frame = CGRectMake(0, 0, sizee.width, 28);
     
     lbl.text = txtt;
     lbl.backgroundColor = [UIColor clearColor];
     UIBarButtonItem *itemspace = [[UIBarButtonItem alloc] initWithCustomView:lbl];
     
     UIBarButtonItem *flexx = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     
     toolBarShare.items = [NSArray arrayWithObjects: itemspace,itemShare,flexx,nil];
     [self.view addSubview:toolBarShare];
     }
     
     
     
     }
     
     [self.tableViewVerses reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:[row intValue]]] withRowAnimation:UITableViewRowAnimationNone];
     /(@"dictt = %@", dictt);
     *//*
        NSString *title = [NSString stringWithFormat:@"Verse %@", [dictt valueForKey:@"verseid"]];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
        delegate:self cancelButtonTitle:nil
        destructiveButtonTitle:nil
        otherButtonTitles:nil];
        
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Notes", @"")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"AddToBookmark", @"")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        
        [actionSheet setCancelButtonIndex:2];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.navigationController.view];// show from our table view (pops up in the middle of the table)
        */
    
}
#pragma mark -
#pragma mark UIScrollViewDelegate



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    
    
    
    [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    if(self.isLoaded){
        
        /*
         MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
         NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.savedLocation objectAtIndex:2]];//:2 withObject:[NSDictionary dictionary]];//+20140929
         if(dict){
         MBLog(@"new offs %lf", scrollView.contentOffset.y);
         lastContentOffset = [[dict valueForKey:@"scroll_position"] floatValue];
         
         [dict setValue:[NSNumber numberWithFloat:scrollView.contentOffset.y] forKey:@"scroll_position"];
         }else{
         //(@"123");
         dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:scrollView.contentOffset.y] forKey:@"scroll_position"];
         
         }
         [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:dict];
         */
        
        float scrollViewHeight = scrollView.frame.size.height;
        float scrollContentSizeHeight = scrollView.contentSize.height;
        float scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset <= 0)
        {
            // then we are at the top
            [self stopAutoScroll];
            if(isFullScreen){
                
                self.isLoaded = NO;
                [self toggleFullScreen];
                
                self.isLoaded = YES;
            }
        }
        else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
        {
            // then we are at the end
        }else{
            
            ScrollDirection scrollDirection = ScrollDirectionNone;
            if (self.lastContentOffset > scrollOffset)
                scrollDirection = ScrollDirectionDown;
            else if (self.lastContentOffset < scrollOffset)
                scrollDirection = ScrollDirectionUp;
            
            
            if (scrollOffset > 0) {
                
                if (scrollDirection == ScrollDirectionUp) {
                    
                    
                    if(!self.isautoscrollling){
                        
                        BOOL isScrollEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kScrollEnable];
                        
                        if (isScrollEnabled) { [self stopAutoScroll]; }
                        self.isautoscrollling = YES;
                   
                        
                        float scrollViewHeight = scrollView.frame.size.height;
                        float scrollContentSizeHeight = scrollView.contentSize.height;
                        float scrollOffset = scrollView.contentOffset.y;
                        
                        if (scrollOffset + scrollViewHeight + 100 < scrollContentSizeHeight)
                        {
                        
                            if(!isFullScreen){
                            MBLog(@"here1 %lf - %lf ",scrollOffset + scrollViewHeight, scrollContentSizeHeight);
                                [self toggleFullScreen];
                            }
                        }
                        
                        if (isScrollEnabled) { [self autoScroll]; }
                    }
                    
                    self.lastContentOffset = scrollOffset;
                }
                else if (scrollDirection == ScrollDirectionDown){
                    
                }
            }
            
        }
        
    }else{
        
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    

    self.lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if(self.isLoaded){
        
        /*
         MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
         NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[appDelegate.savedLocation objectAtIndex:2]];//:2 withObject:[NSDictionary dictionary]];//+20140929
         if(dict){
         MBLog(@"new offs %lf", scrollView.contentOffset.y);
         lastContentOffset = [[dict valueForKey:@"scroll_position"] floatValue];
         
         [dict setValue:[NSNumber numberWithFloat:scrollView.contentOffset.y] forKey:@"scroll_position"];
         }else{
         //(@"123");
         dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:scrollView.contentOffset.y] forKey:@"scroll_position"];
         
         }
         [appDelegate.savedLocation replaceObjectAtIndex:2 withObject:dict];
         */
        
        float scrollViewHeight = scrollView.frame.size.height;
        float scrollContentSizeHeight = scrollView.contentSize.height;
        float scrollOffset = scrollView.contentOffset.y;
        
        if (scrollOffset <= 0)
        {
            // then we are at the top
           
        }
        else if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
        {
            // then we are at the end
            
            
        }else{
            
            ScrollDirection scrollDirection = ScrollDirectionNone;
            if (self.lastContentOffset > scrollOffset)
                scrollDirection = ScrollDirectionDown;
            else if (self.lastContentOffset < scrollOffset)
                scrollDirection = ScrollDirectionUp;
            
            
            if (scrollOffset > 0) {
                
                if (scrollDirection == ScrollDirectionUp) {
                    
                    
                }
                else if (scrollDirection == ScrollDirectionDown){
                    
                    [self stopAutoScroll];
                    if(isFullScreen){
                        MBLog(@"here2");
                        self.isLoaded = NO;
                        [self toggleFullScreen];
                        
                        self.isLoaded = YES;
                    }
                    
                }
            }
            
        }
        
        
        
        
        self.lastContentOffset = scrollOffset;
        
        
    }else{
        
        self.lastContentOffset = scrollView.contentOffset.y;
    }
    
    self.isLoaded = YES;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight)
    {

        // then we are at the end
        [self stopAutoScroll];
        if(isFullScreen){

            self.isLoaded = NO;
            [self toggleFullScreen];
           
            self.isLoaded = YES;
        }
        
    }
    self.lastContentOffset = scrollOffset;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    if(!decelerate){
       
        
    }else{
       
        //self.lastContentOffset = scrollView.contentOffset.y;
    }
    
}

//+20130905
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark FPPopoverControllerDelegate
- (void)popoverControllerDidDismissPopoverFB:(FPPopoverController *)popoverController{
    
    //MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //+rollappDelegate.window.tintColor = nil;
    self.view.alpha = 1.0;
    self.webViewVerses.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [self.tableViewVerses setNeedsDisplay];
    if ([UIDeviceHardware isOS7Device]) {
        imgArrowNext.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    if(imgArrowNext.alpha != .3f){
        imgArrowNext.alpha = 1.0;
    }
    if ([UIDeviceHardware isOS7Device]) {
        imgArrowPrevious.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    if(imgArrowPrevious.alpha != .3f){
        imgArrowPrevious.alpha = 1.0;
    }
    if ([UIDeviceHardware isOS7Device]) {
        imgArrowbooks.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    imgArrowbooks.alpha = 1.0;
    
    
    if(imgArrowChapter){
        if ([UIDeviceHardware isOS7Device]) {
            imgArrowChapter.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
        }
        imgArrowChapter.alpha = 1.0;
    }
    MalayalamBibleAppDelegate *appDelegate =   [[UIApplication sharedApplication] delegate];
    if ([UIDeviceHardware isOS7Device]) {
        appDelegate.window.tintColor = [UIColor defaultWindowColor];
    }
}


#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
    //(@"popover dismissed");
    
    //MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //+rollappDelegate.window.tintColor = nil;
    if ([UIDeviceHardware isOS7Device]) {
    
        imgArrowNext.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    
    if(imgArrowNext.alpha != .3f){
        imgArrowNext.alpha = 1.0;
    }
    if ([UIDeviceHardware isOS7Device]) {
        imgArrowPrevious.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    
    if(imgArrowPrevious.alpha != .3f){
        imgArrowPrevious.alpha = 1.0;
    }
    if ([UIDeviceHardware isOS7Device]) {
        imgArrowbooks.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
    }
    imgArrowbooks.alpha = 1.0;
    
    
    if(imgArrowChapter){
        if ([UIDeviceHardware isOS7Device]) {
            imgArrowChapter.tintColor = [UIColor defaultWindowColor];//+20140312 appDelegate.window.tintColor;
        }
        imgArrowChapter.alpha = 1.0;
    }
}
#pragma mark UIGestureRecognizerDelegate
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    MBLog(@"11");
    return YES;
}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    MBLog(@"11");
    return YES;
    
}

// called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
//
// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    MBLog(@"11");
    return YES;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    MBLog(@"11");
    return YES;
    
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    MBLog(@"11");
    return YES;
    
}
@end



