//
//  Information.m
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Information.h"
#import "MBConstants.h"

@implementation Information

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//+20261123 Phase 2 (UIWebView removal): the view is built here, without [super loadView], so the old
// Information.xib (which holds a UIWebView) is never loaded; callers keep initWithNibName:@"Information".
// WKWebView: no JavaScript (the page has none), nothing stored between visits, no link previews, no data
// detectors (the e-mail addresses stay plain text). Transparent with the page colour behind it, so Night mode
// never shows a white flash while the page loads.
- (void)loadView
{
    BOOL isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    UIColor *pageColor = isdark ? [UIColor blackColor] : [UIColor whiteColor];

    UIView *root = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    root.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    root.backgroundColor = pageColor;

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.defaultWebpagePreferences.allowsContentJavaScript = NO;
    configuration.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    configuration.dataDetectorTypes = WKDataDetectorTypeNone;

    WKWebView *aboutWebView = [[WKWebView alloc] initWithFrame:root.bounds configuration:configuration];
    aboutWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    aboutWebView.navigationDelegate = self;
    aboutWebView.allowsLinkPreview = NO;
    aboutWebView.opaque = NO;
    aboutWebView.backgroundColor = pageColor;
    aboutWebView.scrollView.backgroundColor = pageColor;
    aboutWebView.underPageBackgroundColor = pageColor;
    [root addSubview:aboutWebView];

    self.webView = aboutWebView;
    self.view = root;
}

- (void)dealloc
{
    webView.navigationDelegate = nil;   // ivar from @synthesize webView
}

- (void)viewDidLoad
{
    //<a href=\"mailto:jeesmon@gmail.com?cc=jpulikkottil@gmail.com\">Jeesmon Jacob (jeesmon@gmail.com)</a>
    //<a href=\"mailto:jpulikkottil@gmail.com?cc=jeesmon@gmail.com\">Jijo Pulikkottil (jpulikkottil@gmail.com)</a>
    [super viewDidLoad];
    NSString *html = @"<html><body style='font-family:verdana;'><h3>Malayalam Bible</h3><b>Version:</b> 3.0<br/><br/><b>App Developed by:</b><br/> Jeesmon Jacob (jeesmon@gmail.com)<br/> Jijo Pulikkottil (jpulikkottil@gmail.com)<br/><br/><b>English content obtained from:</b> Public domain<br/><br/><b>Malayalam content obtained from:</b> Nishad  Kaippally (<a href='http://malayalambible.in'>http://malayalambible.in</a>)<br/><br/><b>Disclaimer:</b> Information provided in this App is intended for research and educational use only. Distribution of religious material is restricted and or prohibited by law in certain countries, and may constitute criminal offences. The owner of this App does not endorse the propogation of any religion or doctorine and is not liable for the actions of individuals who may choose to distribute this content.<br/><br/><b>Terms of Use:</b> &quot;The Complete Malayalam Bible In Unicode <b>Ver 3</b>&quot; was encoded by Nishad  Kaippally. The Content provided has been released under the <a href='http://creativecommons.org/licenses/by-nc/2.5/in/'>Creative Commons License</a>. You are free to to share, copy, distribute and transmit the work for non-commercial, non-profit use. The content provided here is based on &quot;The Holy Bible&quot; printed in 1977 by &quot;The Bible Society of India, 20 Mahathma Gandhi Road, Bangalore. India&quot;.<br/></body></html>";
    //+20261118 Night mode: Information.xib draws the view and the web view white and the HTML has no colours,
    // so About was a full white page in Night mode. In Night only: black surfaces, light text and links in the
    // existing theme colour. The text itself is unchanged; Light mode is unchanged.
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
    NSString *nightStyle = @"";
    if (isdark) {
        self.view.backgroundColor = [UIColor blackColor];
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor blackColor];
        self.webView.scrollView.backgroundColor = [UIColor blackColor];
        CGFloat lr = 0, lg = 0, lb = 0, la = 0;
        [[UIColor defaultWindowColor] getRed:&lr green:&lg blue:&lb alpha:&la];
        NSString *linkHex = [NSString stringWithFormat:@"#%02X%02X%02X", (int)lroundf(lr * 255), (int)lroundf(lg * 255), (int)lroundf(lb * 255)];
        nightStyle = [NSString stringWithFormat:@"<style>body{background:#000;color:#E5E5EA;}a{color:%@;}</style>", linkHex];
    }
    //+20261123 Phase 2: one <head> in both modes, with a viewport so WKWebView lays the text out at the screen
    // width (as the old web view did) instead of 980 px scaled down. The text itself is unchanged.
    NSString *head = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style>html{-webkit-text-size-adjust:100%%;}</style>%@</head>", nightStyle];
    html = [html stringByReplacingOccurrencesOfString:@"<html>" withString:[@"<html>" stringByAppendingString:head]];
    // No base URL: the page loads nothing relative (it was http://www.jeesmon.com/mb, which only set an http origin).
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark WKNavigationDelegate (+20261123)

// Same rule as before: a tapped link opens outside the app (Safari) and never in this view; now through
// openURL:options:completionHandler:, as the old openURL: no longer opens URLs on recent iOS. The page itself
// (loadHTMLString with no base URL, i.e. about:blank) may load; every other navigation is blocked.
- (void)webView:(WKWebView *)aboutWebView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme.lowercaseString;

    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (url != nil && ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"mailto"])) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    if (navigationAction.navigationType == WKNavigationTypeOther && navigationAction.targetFrame.isMainFrame && [scheme isEqualToString:@"about"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    decisionHandler(WKNavigationActionPolicyCancel);
}

@end
