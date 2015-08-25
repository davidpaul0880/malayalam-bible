//
//  TintedImageView.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 30/08/13.
//
//

#import <UIKit/UIKit.h>

@interface TintedImageView : UIView
@property (strong, nonatomic) UIImage * image;
@property (strong, nonatomic) UIColor * tintColor;

- (id)initWithImage:(UIImage *)image;
- (UIImage *) getModifiedImage;
@end
