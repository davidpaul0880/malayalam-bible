//
//  NotesViewController.h
//  Malayalam Bible
//
//  Created by jijo on 8/23/13.
//
//

#import <UIKit/UIKit.h>
#import "MBProtocol.h"


@interface NotesViewController : UITableViewController <MBProtocol>{
    
    NSMutableArray *arrayNotes;
}

@property(nonatomic, retain)    NSMutableArray *arrayNotes;
@end
