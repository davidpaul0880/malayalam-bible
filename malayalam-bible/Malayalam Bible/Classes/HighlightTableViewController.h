//
//  HighlightTableViewController.h
//  Malayalam Bible
//
//  Created by jijo on 4/9/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class MalayalamBibleDetailViewController;

@interface HighlightTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
    
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) MalayalamBibleDetailViewController *detailViewController;

@end
