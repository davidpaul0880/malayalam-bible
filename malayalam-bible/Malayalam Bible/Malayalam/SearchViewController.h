//
//  SearchViewController.h
//  Malayalam Bible
//
//  Created by jijo on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
@class MalayalamBibleDetailViewController;


@interface SearchViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
 

    UISearchBar	*searchBarr;
    UILabel *labelSearch;
    NSArray *arrayResults;
    NSString *primaryL;
    BOOL isFirstTime;
    UIActivityIndicatorView *activityView;
    UITableView *tableViewSearch;
    NSInteger scopeValue;
 
}
@property (nonatomic, assign) NSInteger scopeValue;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) MalayalamBibleDetailViewController *detailViewController;
@property (nonatomic, assign) BOOL isFirstTime;
@property (nonatomic, retain) UISearchBar	*searchBarr;
@property (nonatomic, retain) UILabel *labelSearch;
@property (nonatomic, retain) NSArray *arrayResults;
@property (nonatomic, retain) NSString *primaryL;
@property (nonatomic, retain) UITableView *tableViewSearch;
@property (strong, nonatomic) Book *selectedBook;


@end
