//
//  TintedImageView.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 30/08/13.
//
//

#import "TintedImageView.h"

@implementation TintedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@synthesize image=_image;
@synthesize tintColor=_tintColor;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    if(self)
    {
        self.image = image;
        
        //set the view to opaque
        self.opaque = NO;
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)color
{
    _tintColor = color;
    
    //update every time the tint color is set
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    /*CGContextRef context = UIGraphicsGetCurrentContext();
    
    //resolve CG/iOS coordinate mismatch
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    //set the clipping area to the image
    CGContextClipToMask(context, rect, _image.CGImage);
    
    //set the fill color
    CGContextSetFillColor(context, CGColorGetComponents(_tintColor.CGColor));
    CGContextFillRect(context, rect);
    
    //blend mode overlay
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    
    //draw the image
    CGContextDrawImage(context, rect, _image.CGImage);
    
    */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSaveGState(context);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    //set the clipping area to the image
    CGContextClipToMask(context, rect, _image.CGImage);
    
    // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
    // over top of image.
    //
    CGContextSetBlendMode (context, kCGBlendModeMultiply);
    CGContextSetFillColor(context, CGColorGetComponents(_tintColor.CGColor));
    CGContextFillRect (context, rect);
    //CGContextRestoreGState(context);
    // Draw picture first
    //
    CGContextDrawImage(context, rect, self.image.CGImage);
    
   
}
- (UIImage *) getModifiedImage{
    UIGraphicsBeginImageContext( self.image.size );
	[self.image drawInRect:CGRectMake(0,0,self.image.size.width,self.image.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSaveGState(context);
    
    CGRect rect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);// self.image.frame;
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    //set the clipping area to the image
    CGContextClipToMask(context, rect, _image.CGImage);
    
    // Blend mode could be any of CGBlendMode values. Now draw filled rectangle
    // over top of image.
    //
    CGContextSetBlendMode (context, kCGBlendModeMultiply);
    CGContextSetFillColor(context, CGColorGetComponents(_tintColor.CGColor));
    CGContextFillRect (context, rect);
    //CGContextRestoreGState(context);
    // Draw picture first
    //
    //CGContextDrawImage(context, rect, self.image.CGImage);
    
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	
	return newImage;
}

@end
