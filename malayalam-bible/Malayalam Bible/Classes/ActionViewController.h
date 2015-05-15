//
//  ActionViewController.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 05/07/13.
//
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"



@interface ActionViewController : UIViewController{
    
    id <ButtonClickDelegate> btndelegate;
}
@property(nonatomic) id <ButtonClickDelegate> btndelegate;

- (id) initWithDelegate:(id <ButtonClickDelegate>) delegate AndTitile:(NSString *)titlee;

@end
