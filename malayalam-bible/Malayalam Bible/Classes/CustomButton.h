//
//  CustomButton.h
//  VaramozhiEditor
//
//  Created by jijo on 4/16/13.
//
//

#import <UIKit/UIKit.h>

#define kActionColor1   1
#define kActionColor2   2
#define kActionColor3   3
#define kActionColor4   4
#define kActionColor5   5
#define kActionClear 6

#define kActionCopy 10
#define kActionMail 11
#define kActionSMS 12
#define kActionBookmark 13
#define kActionNotes 14
#define kActionFB 15
#define kActionTwitter 16


@protocol ButtonClickDelegate;

@interface CustomButton : UIView <UIGestureRecognizerDelegate>{
    
    NSInteger actionTagg;
    id <ButtonClickDelegate> btndelegate;
}

@property(nonatomic, assign) NSInteger actionTagg;
@property(nonatomic) id <ButtonClickDelegate> btndelegate;

- (id)initWithFrame:(CGRect)frame Tag:(NSInteger)actionTag Title:(NSString *)btnTitle Image:(UIImage *)image;

@end


@protocol ButtonClickDelegate <NSObject>

- (void) buttonClickedWithTag:(NSInteger)actionTag;
- (void) buttonClicked:(UIButton *)sender;
@end

@interface UIImage (INResizeImageAllocator)
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
- (UIImage*)scaleImageToSize:(CGSize)newSize;
@end
