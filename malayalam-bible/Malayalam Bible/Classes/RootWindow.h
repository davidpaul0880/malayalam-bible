//
//  RootWindow.h
//  Malayalam Bible
//
//  Created by jijo on 10/8/12.
//
//

#import <UIKit/UIKit.h>

@interface RootWindow : UIWindow{
    BOOL bibleEvent;
    BOOL movement;
	BOOL ignoreMovementEvents;
    NSTimeInterval startTouchTime;
	CGPoint previousTouchPosition1, previousTouchPosition2;
	CGPoint startTouchPosition1, startTouchPosition2;
}
//- (void)sendEvent:(UIEvent *)event;
@end
