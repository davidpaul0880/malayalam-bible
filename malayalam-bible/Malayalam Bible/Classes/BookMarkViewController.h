//
//  BookMarkViewController.h
//  Malayalam Bible
//
//  Created by jijo on 4/22/13.
//
//

#import <UIKit/UIKit.h>
#import "FolderDetailController.h"
@class MalayalamBibleDetailViewController;
@class Folders;

@interface BookMarkViewController : UITableViewController <MBFolderEditDelegate>{
    
    NSMutableArray *arrayBookmarks;
    NSMutableArray *arrayFolders;
    
    NSArray *bmArray;
    Folders *parentFolder;
}
@property(nonatomic, retain) Folders *parentFolder;
@property(nonatomic, retain) NSMutableArray *arrayBookmarks;
@property(nonatomic, retain) NSMutableArray *arrayFolders;

@property(nonatomic, retain) NSArray *bmArray;
@property (nonatomic, strong) MalayalamBibleDetailViewController *detailViewController;

- (id)initWithStyle:(UITableViewStyle)style BMFolder:(Folders *)folder;

@end
