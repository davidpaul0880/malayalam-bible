//
//  MalayalamBibleMasterViewController.h
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Information.h"
#import "ChapterSelection.h"

@class MalayalamBibleDetailViewController;

@interface MalayalamBibleMasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource > {
    NSMutableArray *books;
    NSMutableArray *newTestament;
    NSMutableArray *oldTestament;
    
    BOOL isNeedReload;
    UITableView *tableViewBooks;
    NSMutableArray *indexArray;
       
    
}

@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) MalayalamBibleDetailViewController *detailViewController;
@property (strong, nonatomic) Information *infoViewController;
//@property (strong, nonatomic) ChapterSelection *chapterSelectionController;
@property (strong, nonatomic) UITableView *tableViewBooks;
@property (nonatomic, assign) BOOL isNeedReload;


- (void)restoreLevelWithSelectionArray:(NSArray *)selectionArray;

@end
