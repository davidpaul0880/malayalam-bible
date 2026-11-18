//
//  WebViewController.m
//  VaramozhiEditor
//
//  Created by jijo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "MBConstants.h"

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
    
    
    //+20261118 Night mode: black around the help page instead of a white frame. Light mode is unchanged.
    BOOL isdarkPage = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    [self.view setBackgroundColor:(isdarkPage ? [UIColor blackColor] : [UIColor whiteColor])];
    CGRect rect = self.view.frame;
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	webView.scalesPageToFit = YES;
	webView.delegate = self;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
	
	if (isdarkPage) {
		webView.opaque = NO;
		webView.backgroundColor = [UIColor blackColor];
		webView.scrollView.backgroundColor = [UIColor blackColor];
	}
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
    //+20261118 Night mode: follow the app's own Night mode (kNightTime) rather than the iOS appearance, the
    // same convention as Settings, Add Bookmark, Notes and Bookmarks. Settings saves kNightTime before pushing
    // this screen, so the value here is current.
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    self.overrideUserInterfaceStyle = isdark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
    // Navigation bar matching the reading screen's own bar (opaque black in Night, the default bar in Light),
    // so it is right even when Night mode was just switched in Settings. Set on the shared navigation bar,
    // as the reading screen does; screens with their own navigationItem appearance (Settings) keep theirs.
    UINavigationBarAppearance *barAppearance = [[UINavigationBarAppearance alloc] init];
    if (isdark) {
        [barAppearance configureWithOpaqueBackground];
        barAppearance.backgroundColor = [UIColor blackColor];
        barAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        barAppearance.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    } else {
        [barAppearance configureWithDefaultBackground];
    }
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.standardAppearance = barAppearance;
    navigationBar.compactAppearance = barAppearance;
    navigationBar.scrollEdgeAppearance = barAppearance;
    navigationBar.compactScrollEdgeAppearance = barAppearance;
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
