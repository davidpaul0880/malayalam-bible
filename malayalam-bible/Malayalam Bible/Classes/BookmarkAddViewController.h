//
//  BookmarkAddViewController.h
//  Malayalam Bible
//
//  Created by jijo on 11/6/12.
//
//

#import <UIKit/UIKit.h>
#import "Folders.h"
#import "BookMarks.h"
#import "MBProtocol.h"

@interface BookmarkAddViewController : UITableViewController <UITextFieldDelegate>{
    

    UITextField *activeTextField;
    
    Folders *defaultFolder;
    BookMarks *bookMark;
    
    id <MBProtocol> delegate;
    
    NSString *verseText;
     
}

@property(nonatomic, retain)Folders *defaultFolder;
@property(nonatomic) id <MBProtocol> delegate;

@property(nonatomic, retain) BookMarks *bookMark;
@property(nonatomic, retain) NSString *verseText;
@end
