//
//  FolderSelectController.h
//  Malayalam Bible
//
//  Created by jijo on 10/18/12.
//
//

#import <UIKit/UIKit.h>

@class Folders;

@protocol MBFolderSelectDelegate <NSObject>
@required
- (void)selectedFolder:(Folders *)folder;
@end


@interface FolderSelectController : UITableViewController{
    
    id <MBFolderSelectDelegate> delegatee;
}

@property (strong, nonatomic) NSMutableArray *arrayFolders;
@property (strong, nonatomic) NSMutableArray *arrayNewFolders;

- (id)initWithStyle:(UITableViewStyle)style Delegate:(id)del;

@end






