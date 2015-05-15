//
//  CustomView.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 09/07/13.
//
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    self.alpha = 1.0;
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    
    
    // Fill Gradient
    
    CGGradientRef glossGradient;
    
    CGColorSpaceRef rgbColorspace;
    
    size_t num_locations = 2;
    
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGFloat components[8] = { 200./255, 200./255, 200./255, 1.0,   // Start color
        
        0/255., 0/255., 0/255., 1. }; // End color
    // 147./255., 153./255., 168./255., 1. }; // End color
    //165./255., 169./255., 182./255., 1.0 }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    
    
    CGRect currentBounds = self.bounds;
    
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));
    
    
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    
    
    
    CGGradientRelease(glossGradient);
    
    CGColorSpaceRelease(rgbColorspace);
    
    
    
    CGContextRestoreGState(context);
    
}


@end
