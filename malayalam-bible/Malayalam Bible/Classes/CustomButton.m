//
//  CustomButton.m
//  VaramozhiEditor
//
//  Created by jijo on 4/16/13.
//
//

#import "CustomButton.h"
#import  "UIDeviceHardware.h"

@implementation CustomButton

@synthesize actionTagg;
@synthesize btndelegate;

- (id)initWithFrame:(CGRect)frame Tag:(NSInteger)actionTag Title:(NSString *)btnTitle Image:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, 48, 35)];
    if (self) {
        // Initialization code
        
        UIButton *btnNewSignature1 = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imgNewSignature1 = [UIImage imageWithImage:image scaledToSize:CGSizeMake(image.size.width-7, image.size.height-7)];
       [btnNewSignature1 setBackgroundImage:imgNewSignature1 forState:UIControlStateNormal];
        [btnNewSignature1 setFrame:CGRectMake((48-imgNewSignature1.size.width)/2, (26-imgNewSignature1.size.height)/2, imgNewSignature1.size.width, imgNewSignature1.size.height)];
        btnNewSignature1.tag = actionTag;
        //[btnNewSignature1 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if(actionTag == 0){
            btnNewSignature1.enabled = false;
        }
        
        [self addSubview:btnNewSignature1];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 48, 10)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = btnTitle;
        if([UIDeviceHardware isOS7Device]){
            label.textColor = [UIColor blackColor];
        }else{
            label.textColor = [UIColor whiteColor];
        }
        
        label.font = [UIFont systemFontOfSize:10];
        label.minimumScaleFactor = 6.0/label.font.pointSize;
        [self addSubview:label];
        
        self.actionTagg = actionTag;
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self                                               action:@selector(handleSingleTap:)];
        
        [singleFingerTap setCancelsTouchesInView:NO];
        singleFingerTap.numberOfTapsRequired = 1;
        singleFingerTap.delegate = self;
        
        [self addGestureRecognizer:singleFingerTap];



    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [btndelegate buttonClickedWithTag:self.actionTagg];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
@implementation UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image
			  scaledToSize:(CGSize)newSize;
{
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	
	return newImage;
    /*
     CGSize size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy);
     
     UIGraphicsBeginImageContext(size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGAffineTransform transform = CGAffineTransformIdentity;
     
     transform = CGAffineTransformScale(transform, scaleBy, scaleBy);
     CGContextConcatCTM(context, transform);
     
     // Draw the image into the transformed context and return the image
     [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
     UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return newimg;
     */
}
- (UIImage*)scaleImageToSize:(CGSize)newSize
{
	return [UIImage imageWithImage:self scaledToSize:newSize];
}



@end