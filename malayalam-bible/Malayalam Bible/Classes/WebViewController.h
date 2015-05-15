//
//  WebViewController.h
//  VaramozhiEditor
//
//  Created by jijo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>{
    
    NSString *requestURL;
}

@property(nonatomic, retain) NSString *requestURL;

@end
