//
//  SelectionController.h
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionController : UITableViewController{
    
    NSArray *arrayOptions;
    
    
}

@property(nonatomic, assign) NSUInteger optionType;
- (id)initWithStyle:(UITableViewStyle)style Options:(NSArray *)options;

@end
