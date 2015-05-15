//
//  FontSizeCell.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 29/08/13.
//
//

#import "FontSizeCell.h"
#import "MBConstants.h"

@implementation FontSizeCell

@synthesize fontSizeSlider, lblSample, isFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IsFontCell:(BOOL)isFontcell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.isFont = isFontcell;
        self.fontSizeSlider = [[UISlider alloc] init];
        [self.fontSizeSlider addTarget:self action:@selector(sliderValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
        if(isFontcell){
            
            self.fontSizeSlider.minimumValue = kFontMinSize;
            self.fontSizeSlider.maximumValue = kFontMaxSize;
            [self.fontSizeSlider setValue:FONT_SIZE animated:YES];
        }else{
            self.fontSizeSlider.minimumValue = 1;
            self.fontSizeSlider.maximumValue = 100;
        
            [self.fontSizeSlider setValue:[[NSUserDefaults standardUserDefaults] floatForKey:kScrollSpeed] animated:YES];
            
        }
        
        
        
        self.lblSample = [[UILabel alloc] init];
        
        
        self.lblSample.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.lblSample.textAlignment = NSTextAlignmentCenter;
        
        bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
        if (isdark ){
            self.lblSample.textColor = [UIColor whiteColor];
        }
        
        [self.contentView addSubview:self.fontSizeSlider];
        [self.contentView addSubview:self.lblSample];
    }
    return self;
}
-(void)sliderValueChanged:(UISlider *)sender
{
    if(isFont){
        
        MBLog(@"slider value = %f", sender.value);
        FONT_SIZE = sender.value;
        self.lblSample.font = [UIFont systemFontOfSize:FONT_SIZE];

    }else{
        self.lblSample.text = [NSString stringWithFormat:@"Auto Scroll Speed %.1f %%", sender.value];
        
        [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:kScrollSpeed];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect contentRect = self.contentView.bounds;
    CGSize cgSize = contentRect.size;
    
    self.fontSizeSlider.frame = CGRectMake(60, 38, cgSize.width-120, 20);
    self.lblSample.frame = CGRectMake(0, 10, cgSize.width, 25);
}
@end
