//
//  Information.m
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Information.h"

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

- (void)viewDidLoad
{
    //<a href=\"mailto:jeesmon@gmail.com?cc=jpulikkottil@gmail.com\">Jeesmon Jacob (jeesmon@gmail.com)</a>
    //<a href=\"mailto:jpulikkottil@gmail.com?cc=jeesmon@gmail.com\">Jijo Pulikkottil (jpulikkottil@gmail.com)</a>
    [super viewDidLoad];
    NSString *html = @"<html><body style='font-family:verdana;'><h3>Malayalam Bible</h3><b>Version:</b> 3.0<br/><br/><b>App Developed by:</b><br/> Jeesmon Jacob (jeesmon@gmail.com)<br/> Jijo Pulikkottil (jpulikkottil@gmail.com)<br/><br/><b>English content obtained from:</b> Public domain<br/><br/><b>Malayalam content obtained from:</b> Nishad  Kaippally (<a href='http://malayalambible.in'>http://malayalambible.in</a>)<br/><br/><b>Disclaimer:</b> Information provided in this App is intended for research and educational use only. Distribution of religious material is restricted and or prohibited by law in certain countries, and may constitute criminal offences. The owner of this App does not endorse the propogation of any religion or doctorine and is not liable for the actions of individuals who may choose to distribute this content.<br/><br/><b>Terms of Use:</b> &quot;The Complete Malayalam Bible In Unicode <b>Ver 3</b>&quot; was encoded by Nishad  Kaippally. The Content provided has been released under the <a href='http://creativecommons.org/licenses/by-nc/2.5/in/'>Creative Commons License</a>. You are free to to share, copy, distribute and transmit the work for non-commercial, non-profit use. The content provided here is based on &quot;The Holy Bible&quot; printed in 1977 by &quot;The Bible Society of India, 20 Mahathma Gandhi Road, Bangalore. India&quot;.<br/></body></html>";
    [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.jeesmon.com/mb"]];
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

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
