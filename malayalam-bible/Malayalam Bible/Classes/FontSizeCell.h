//
//  FontSizeCell.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 29/08/13.
//
//

#import <UIKit/UIKit.h>

@interface FontSizeCell : UITableViewCell{
    
    UILabel *lblSample;
    UISlider *fontSizeSlider;
    BOOL isFont;
}
@property(assign) BOOL isFont;
@property(nonatomic) UISlider *fontSizeSlider;
@property(nonatomic) UILabel *lblSample;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsFontCell:(BOOL)isFontcell;

@end
