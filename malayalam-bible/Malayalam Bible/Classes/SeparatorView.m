//
//  SeparatorView.m
//  MobileEdge
//
//  Created by jijo on 6/6/11.
//  Copyright 2011 __iEnterprises__.  All rights reserved.  Maintained by __Notetech__.
//

#import "SeparatorView.h"


@implementation SeparatorView

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
    
    CGFloat components[8] = { 253./255, 253.0/255., 253.0/255., .8,   // Start color
        
        255./255., 255./255., 255./255., 1.0 }; // End color
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
