//
//  VerseCell.m
//  Malayalam Bible
//
//  Created by jijo on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerseCell.h"
#import "MBConstants.h"
#import "UIDeviceHardware.h"


@implementation VerseCell

@synthesize webView, verseText, touchView, isSearchResult, isUnderlined;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.webView = [[UIWebView alloc] init];
        //self.webView.scalesPageToFit = YES;
        
        
        if([UIDeviceHardware isOS5Device]){
            self.webView.scrollView.scrollEnabled = NO;
        }else{
            for (id subview in webView.subviews){ 
                if ([[subview class] isSubclassOfClass: [UIScrollView class]]) { 
                    UIScrollView *scrollVieww = (UIScrollView *)subview;
                    scrollVieww.scrollEnabled = NO;
                    break;
                }
            }

        }
                        
        [self.contentView addSubview:webView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat adjustWidth = 20.0;
    CGRect contentRect = self.contentView.bounds;
    CGSize cgSize = contentRect.size;
    
    if(self.isSearchResult){
        adjustWidth = 27.0;
    }
    
     


    UIFont *cellFont = [UIFont fontWithName:kFontName size:FONT_SIZE];
    CGSize constraintSize = CGSizeMake(cgSize.width-adjustWidth, MAXFLOAT);//280
    CGSize labelSize = [verseText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
   
    CGFloat adjustht = 0;
    if(self.isUnderlined){
        
        //adjustht = (labelSize.height /20)*2;
    }
    
        
    [self.webView setFrame:CGRectMake(0, 0, cgSize.width+10, labelSize.height+15+adjustht)];
    //[self.webView setFrame:CGRectMake(0, 0, 0, 0)];
   
}



@end
