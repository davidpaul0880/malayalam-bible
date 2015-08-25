//
//  ChapterSelection.h
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "MalayalamBibleDetailViewController.h"
#import "PopOverDelegate.h"

@interface ChapterSelection : UIViewController {
    
    
    UIScrollView *scrollViewBar;
    UILabel *lblChapter;
    NSIndexPath *indexPath;
}

@property (nonatomic, assign) BOOL fromMaster;
@property (nonatomic, retain) UIScrollView *scrollViewBar;
@property (nonatomic, retain) UILabel *lblChapter;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger selectedChapter;

@property (strong, nonatomic) Book *selectedBook;
@property (strong, nonatomic) MalayalamBibleDetailViewController *detailViewController;
@property (nonatomic, assign) id <PopOverDelegate> delegate;

-(void) configureView:(BOOL)isFromMaster;
- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray;


@end
