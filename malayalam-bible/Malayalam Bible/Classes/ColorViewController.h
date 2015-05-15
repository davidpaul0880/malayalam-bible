//
//  ColorViewController.h
//  Malayalam Bible
//
//  Created by jijo on 4/22/13.
//
//

#import <UIKit/UIKit.h>


@protocol MBColourSelectorDelegate <NSObject>
@required
- (void)colorStringDidChange:(NSNumber *)newColor;
@end

@interface ColorViewController : UITableViewController{
    
    id <MBColourSelectorDelegate> delegatee;
//    NSArray *arrayColors;
    NSInteger selectedColor;
}

- (id)initWithStyle:(UITableViewStyle)style SelectedColor:(NSInteger)selColor Delegate:(id)delgte;
+ (NSArray *)arrayColors;
@end
