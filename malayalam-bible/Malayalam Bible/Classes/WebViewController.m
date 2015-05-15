//
//  WebViewController.m
//  VaramozhiEditor
//
//  Created by jijo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end



@implementation WebViewController

@synthesize requestURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadView{
    
    [super loadView];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect rect = self.view.frame;
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
	
	[self.view addSubview:webView];
	
	
    NSURL *url = nil;
	//if(isFileURL){
		url = [NSURL fileURLWithPath:requestURL]; 
	//}else{
	//	url = [NSURL URLWithString:requestURL]; 
	//}
    
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url]; 
	
	[webView loadRequest:requestObj]; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
