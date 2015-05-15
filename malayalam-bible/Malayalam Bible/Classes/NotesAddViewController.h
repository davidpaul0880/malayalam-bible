//
//  NotesAddViewController.h
//  Malayalam Bible
//
//  Created by jijo on 8/21/13.
//
//

#import <UIKit/UIKit.h>
#import "Notes.h"
#import "MBProtocol.h"



@interface NotesAddViewController : UIViewController <UITextViewDelegate>{
    
    Notes *notesNew;
    NSString *verseTitle;
    BOOL isEditingNote;
    id <MBProtocol> delegatee;
}
@property (nonatomic) id <MBProtocol> delegatee;
@property(nonatomic, assign) BOOL isEditingNote;
@property(nonatomic, retain) Notes *notesNew;
@property(nonatomic, retain) NSString *verseTitle;
@end
