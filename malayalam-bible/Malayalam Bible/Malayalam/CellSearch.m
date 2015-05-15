//
//  CellSearch.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 24/07/13.
//
//

#import "CellSearch.h"

@implementation CellSearch

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (action == @selector(copy:))
        return YES;
    return NO;
}
- (BOOL)canBecomeFirstResponder {
    
    return YES;
    
}
@end
