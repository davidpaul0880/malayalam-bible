//
//  SettingsViewController.h
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorViewController.h"

@interface SettingsViewController : UITableViewController <MBColourSelectorDelegate>{
    
    NSMutableArray *arraySettings;
    
    NSArray *arrayLangs;
    
    NSArray *arrayPrefs;
    
   
    
    NSString *selectedPrimary;
    NSString *selectedSecondary;
}



@end
