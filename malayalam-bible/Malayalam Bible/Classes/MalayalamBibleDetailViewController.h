//
//  MalayalamBibleDetailViewController.h
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Book.h"
#import "PopOverDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProtocol.h"
#import "SearchViewController.h"
#import "FPPopoverController.h"
#import "CustomButton.h"
#import <MessageUI/MFMessageComposeViewController.h>

@class TintedImageView;

@interface MalayalamBibleDetailViewController : UIViewController <UISplitViewControllerDelegate, PopOverDelegate, MFMailComposeViewControllerDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, MBProtocol, UIWebViewDelegate, UIScrollViewDelegate, ButtonClickDelegate, MFMessageComposeViewControllerDelegate, FPPopoverControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>//+20130905
{
    NSMutableArray *bVerses;
    
    NSMutableArray *bVersesIndexArray;

    UIPopoverController *popoverChapterController;
    UIPopoverController *popoverActionController;
    
    UITableView *tableViewVerses;
    UITableView *tableViewVersesLeft;
    UITableView *tableViewVersesRight;
    
    //UITableView *tableWebViewVerses;
    
    BOOL isActionClicked;
    BOOL isFromSeachController;
    UIToolbar *bottomToolBar;
    
    BOOL isFullScreen;
    BOOL isWebViewLoaded;
    
    NSMutableArray *arrayToMookmark;
    UIWebView *webViewVerses;
    
    UIWebView *versesLeft;
    UIWebView *versesRight;
    UIView *versesCurrent;
    
    CGPoint mSwipeStart;
    FPPopoverController *popover;
    
    NSArray *bookMarkedObjs;
    NSArray *colordObjs;
    
    UIView *imgArrowbooks;
    UIView *imgArrowChapter;
    UIView *imgArrowPrevious;
    UIView *imgArrowNext;
    
    BOOL isLoadViewSET;//+20131114
    BOOL isLoaded;

}


@property(nonatomic, assign) BOOL isLoaded;
@property(nonatomic, assign) BOOL isLoadViewSET;
@property (strong, nonatomic) UIView *imgArrowbooks;
@property (strong, nonatomic) UIView *imgArrowChapter;
@property (strong, nonatomic) UIView *imgArrowPrevious;
@property (strong, nonatomic) UIView *imgArrowNext;

@property (strong, nonatomic) NSArray *bookMarkedObjs;
@property (strong, nonatomic) NSArray *colordObjs;


@property(nonatomic, assign) BOOL isWebViewLoaded;

@property(nonatomic, strong) SearchViewController *searchController;
@property (strong, nonatomic) UIWebView *webViewVerses;

@property (strong, nonatomic) UIWebView *versesLeft;
@property (strong, nonatomic) UIWebView *versesRight;
@property (strong, nonatomic) UIView *versesCurrent;


@property (strong, nonatomic) NSMutableArray *bVerses;
@property (strong, nonatomic) NSMutableArray *bVersesIndexArray;
@property(nonatomic, assign) BOOL isActionClicked;
@property(nonatomic, assign) BOOL isFromSeachController;
@property (strong, nonatomic) Book *selectedBook;
@property (assign, readwrite) NSInteger chapterId;
@property(nonatomic, retain) UIPopoverController *popoverChapterController;
@property(nonatomic, retain) UIPopoverController *popoverActionController;


@property(nonatomic, retain) UITableView *tableViewVerses;
@property(nonatomic, retain) UITableView *tableViewVersesLeft;
@property(nonatomic, retain) UITableView *tableViewVersesRight;
@property(nonatomic, retain) UIToolbar *bottomToolBar;

- (void)showAlert:(NSString *)message;


- (void) toggleFullScreen;
//- (void)configureiPadView;
- (void)configureView;

- (void)toucheBegan:(UITouch *)toucch;
- (void)toucheMoved:(UITouch *)toucch;
- (void)toucheEnded:(UITouch *)toucche;
    
    
@end

/*@interface UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
- (UIImage*)scaleImageToSize:(CGSize)newSize;
@end
*/