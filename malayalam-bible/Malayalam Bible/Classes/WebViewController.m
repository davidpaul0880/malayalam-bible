//
//  WebViewController.m
//  VaramozhiEditor
//
//  Created by jijo on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "MBConstants.h"

//+20261123 Phase 2 (UIWebView removal): the help chart is shown natively in a zoomable image view.
@interface WebViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *helpScrollView;
@property (strong, nonatomic) UIImageView *helpImageView;
@property (assign, nonatomic) BOOL helpShowsTopOnLayout;   // until the screen has appeared, layouts keep the top in view

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
    //+20261123 Phase 2 (UIWebView removal): the image at requestURL (a file path; the help chart lipi.png) in a
    // zoomable scroll view instead of a UIWebView. Same behaviour: fitted to the width on open, top aligned,
    // pinch and double-tap zoom, scrolling when zoomed; same page colour around it in Light and Night.
    UIColor *pageColor = isdarkPage ? [UIColor blackColor] : [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.backgroundColor = pageColor;
    scrollView.delegate = self;
    scrollView.bouncesZoom = YES;
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;   // clear of the bars
    [self.view addSubview:scrollView];
    self.helpScrollView = scrollView;

    UIImage *image = (requestURL.length > 0) ? [UIImage imageWithContentsOfFile:requestURL] : nil;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];   // frame = image size (zoom scale 1)
    imageView.isAccessibilityElement = YES;
    imageView.accessibilityTraits = UIAccessibilityTraitImage;
    imageView.accessibilityLabel = NSLocalizedString(@"SearchHelp", @"");
    [scrollView addSubview:imageView];
    scrollView.contentSize = imageView.bounds.size;
    self.helpImageView = imageView;
    self.helpShowsTopOnLayout = YES;

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mb_helpDoubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
}

#pragma mark Help image zoom (+20261123)

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self mb_updateHelpZoomScales];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.helpShowsTopOnLayout = NO;
}

// Smallest zoom = the image fitted to the visible width (as the web view's scalesPageToFit did); up to 3x that.
// Recomputed on every layout (rotation, size changes); an image at the smallest zoom stays fitted.
- (void)mb_updateHelpZoomScales
{
    UIScrollView *scrollView = self.helpScrollView;
    UIImage *image = self.helpImageView.image;
    if (scrollView == nil || image == nil || image.size.width <= 0) return;

    CGFloat visibleWidth = CGRectGetWidth(scrollView.bounds) - scrollView.safeAreaInsets.left - scrollView.safeAreaInsets.right;
    if (visibleWidth <= 0) return;

    CGFloat fitScale = visibleWidth / image.size.width;
    BOOL wasFitted = (scrollView.zoomScale <= scrollView.minimumZoomScale + 0.001);
    scrollView.minimumZoomScale = fitScale;
    scrollView.maximumZoomScale = fitScale * 3.0;
    if (self.helpShowsTopOnLayout || wasFitted || scrollView.zoomScale < fitScale) {
        scrollView.zoomScale = fitScale;
    }
    if (self.helpShowsTopOnLayout) {
        scrollView.contentOffset = CGPointMake(-scrollView.adjustedContentInset.left, -scrollView.adjustedContentInset.top);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.helpImageView;
}

// Double tap: zoom in 2x around the tapped point, or back to the fitted width.
- (void)mb_helpDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    UIScrollView *scrollView = self.helpScrollView;
    if (scrollView.zoomScale > scrollView.minimumZoomScale + 0.001) {
        [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
        return;
    }
    CGFloat targetScale = MIN(scrollView.maximumZoomScale, scrollView.minimumZoomScale * 2.0);
    if (targetScale <= 0) return;
    CGPoint point = [recognizer locationInView:self.helpImageView];
    CGSize size = CGSizeMake(CGRectGetWidth(scrollView.bounds) / targetScale, CGRectGetHeight(scrollView.bounds) / targetScale);
    [scrollView zoomToRect:CGRectMake(point.x - size.width / 2.0, point.y - size.height / 2.0, size.width, size.height) animated:YES];
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
