//
//  FolderDetailController.h
//  Malayalam Bible
//
//  Created by jijo on 3/13/13.
//
//
//http://html-color-codes.com/

#import <UIKit/UIKit.h>
#import "Folders.h"
#import "ColorViewController.h"

#define kModeView 1
#define kModeNew   2
#define kModeEdit   3

@protocol MBFolderEditDelegate <NSObject>
@required
- (void)upsertedFolder:(Folders *)folder AndMode:(NSInteger)mode;
@end


@interface FolderDetailController : UITableViewController <UITextFieldDelegate, MBColourSelectorDelegate>{
    
    NSInteger viewMode;
    id <MBFolderEditDelegate> delegatee;
    UITextField *activeTextField;
    Folders *folderD;
}


@property(nonatomic, retain) Folders *folderD;

- (id)initWithStyle:(UITableViewStyle)style ViewMode:(NSInteger)vMode AndDelegate:(id)del;


@end
