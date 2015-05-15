//
//  RootWindow.m
//  Malayalam Bible
//
//  Created by jijo on 10/8/12.
//
//

#import "RootWindow.h"
#import "MalayalamBibleAppDelegate.h"
#import <objc/runtime.h>
#import "MBConstants.h"

@implementation RootWindow

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
/*
- (void)sendEvent:(UIEvent *)event {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        
        MalayalamBibleAppDelegate *appDelegate = (MalayalamBibleAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //NSArray *allTouches = [[event allTouches] allObjects];
        UITouch *touch = [[event allTouches] anyObject];
        UIView *touchView = [touch view];
        
        if(isDetailControllerVisible)
            if (touchView && ([touchView isDescendantOfView:appDelegate.detailViewController.webViewVerses])) {
                
                bibleEvent = [touchView isDescendantOfView:appDelegate.detailViewController.webViewVerses];
                
                //
                // touchesMoved
                //
                
                if (touch.phase==UITouchPhaseMoved) {
                    
                }
                
                
                //
                // touchesEnded
                ///
                if (touch.phase==UITouchPhaseEnded) {
                    
                    
                    if ( [touch tapCount] == 2) {
                        
                        if(bibleEvent) {
                            
                            [appDelegate.detailViewController toggleFullScreen];
                            
                        }
                    }
                    
                    
                    
                    
                }
            }
    }
    
    
    [super sendEvent:event];
}
*/
@end
