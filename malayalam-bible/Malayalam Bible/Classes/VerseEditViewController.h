//
//  VerseEditViewController.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 16/10/13.
//
//

#import <UIKit/UIKit.h>

@interface VerseEditViewController : UIViewController <UITextViewDelegate>{
    
    UITextView *vtextView;
    NSDictionary *dictVerse;
    
    NSInteger sbookid;
    NSInteger schapterid;
}
- (id)initWithVerse:(NSDictionary *)dictVersee BookId:(NSInteger)bookid AndChapterId:(NSInteger)chpaterid;
@end
