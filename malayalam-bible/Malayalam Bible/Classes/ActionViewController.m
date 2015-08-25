//
//  ActionViewController.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 05/07/13.
//
//
#import <QuartzCore/QuartzCore.h>
#import "ActionViewController.h"
#import "SeparatorView.h"

#import <Social/Social.h>
#import "CustomView.h"
#import "MBUtils.h"
#import "UIDeviceHardware.h"
#import "MBConstants.h"




@interface ActionViewController ()

@property (nonatomic, strong) NSString *titleiPad;

@end

@implementation ActionViewController
@synthesize btndelegate;

- (id) initWithDelegate:(id <ButtonClickDelegate>) delegate AndTitile:(NSString *)titlee{
    
    self = [super init];
    if (self) {
        // Custom initialization
        self.btndelegate = delegate;
        self.title = titlee;
        self.titleiPad  = titlee;
    }
    return self;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//+20131114
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}
-(void)loadView{
	
	[super loadView];
    
    
     
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat x = 10.0;
    CGFloat y= 10.0;
    
    CGFloat colrbtnGap = 36;
    
    
    if([UIDeviceHardware isIpad]){
        
        x = 15.0;
        y= 15.0;
        colrbtnGap = 43;
        
    }
    
    if([UIDeviceHardware isOS7Device]){
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        SeparatorView *sview = [[SeparatorView alloc] initWithFrame:CGRectMake(0, 1, kActionViewWidth-20, 1)];//+20131114
        [sview setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:sview];
        
        if([UIDeviceHardware isIpad]){
            
            
            CGRect navBarFrame = CGRectMake(0, 0, kActionViewWidth+20, 45);
            
            UINavigationBar *aNavigationBar = [[UINavigationBar alloc]initWithFrame:navBarFrame];
            
            //aNavigationBar.autoresizingMask =	UIViewAutoresizingFlexibleWidth;
            
            //UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"jijo"];//self.titleiPad
            UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
            UILabel *lbl = [[UILabel alloc] initWithFrame:navBarFrame];
            lbl.text = self.titleiPad;
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = [UIColor blackColor];
            navigationItem.titleView = lbl;
           
            
            
            //UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissme:)];
            
            //navigationItem.leftBarButtonItem = buttonItem;
            [aNavigationBar pushNavigationItem:navigationItem animated:NO];
            
            [self.view addSubview:aNavigationBar];
            
            y += 45.0;
        }
        
    }else{
        self.view = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    
    
    
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    

    
    
  
    
    
    //CGFloat toolbarHt = 50.0;
    
    
    //http://www.december.com/html/spec/colorhslhex10.html
        
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(x, y, 25, 25)];
    button.tag = kActionColor1;
    NSString *color = [MBUtils getHighlightColorof:kStoreColor1];//
    [button setBackgroundColor:[UIColor colorWithHexString:color]]; //colorWithRed:(255/255.0) green:(180/255.0) blue:(200/255.0) alpha:1]];
    [button addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    

    
    x+=colrbtnGap;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = kActionColor2;
    [button2 setFrame:CGRectMake(x, y, 25, 25)];
    color = [MBUtils getHighlightColorof:kStoreColor2];//
    [button2 setBackgroundColor:[UIColor colorWithHexString:color]];//colorWithRed:(180/255.0) green:(200/255.0) blue:(255/255.0) alpha:1]];
    [button2 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    x+=colrbtnGap;
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = kActionColor3;
    [button2 setFrame:CGRectMake(x, y, 25, 25)];
    color = [MBUtils getHighlightColorof:kStoreColor3];//
    [button2 setBackgroundColor:[UIColor colorWithHexString:color]];//Red:(255/255.0) green:(230/255.0) blue:(130/255.0) alpha:1]];
    [button2 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    x+=colrbtnGap;
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = kActionColor4;
    [button2 setFrame:CGRectMake(x, y, 25, 25)];
    color = [MBUtils getHighlightColorof:kStoreColor4];//
    [button2 setBackgroundColor:[UIColor colorWithHexString:color]];//Red:(225/255.0) green:(130/255.0) blue:(230/255.0) alpha:1]];
    [button2 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    x+=colrbtnGap;
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = kActionColor5;
    [button2 setFrame:CGRectMake(x, y, 25, 25)];
    color = [MBUtils getHighlightColorof:kStoreColor5];//
    [button2 setBackgroundColor:[UIColor colorWithHexString:color]];//Red:(125/255.0) green:(250/255.0) blue:(250/255.0) alpha:1]];
    [button2 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    x+=colrbtnGap;
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = kActionClear;
    [button2 setFrame:CGRectMake(x, y, 27, 25)];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def valueForKey:@"easteregg"]){
        [button2 setTitle:NSLocalizedString(@"E", @"") forState:UIControlStateNormal];
    }else{
        [button2 setTitle:NSLocalizedString(@"action.clearall", @"") forState:UIControlStateNormal];
    }
    
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1]];
    [button2 addTarget:btndelegate action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    CGRect frameSEp = CGRectMake(10, y+35, kActionViewWidth-40, 2);
    if([UIDeviceHardware isIpad]){
        frameSEp = CGRectMake(13, y+40, kActionViewWidth, 2);
    }
    SeparatorView *seperatorView1 = [[SeparatorView alloc] initWithFrame:frameSEp];
    
    
    //seperatorView1.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:seperatorView1];
    
    
    
    
    CGFloat gap = 50.0;
    CGFloat btnwidth = 30.0;
    CGFloat btnHeight = 35.0;
    
    if([UIDeviceHardware isIpad]){
        
        gap = 60.0;
        y += 50;
        x = 30;
        
        btnwidth = 30.0;
        btnHeight = 35.0;
        
    }else{
        y += 50;
        x = 20;
    }
    /**** Copy Button ****/
    
    NSString *imgCopy = @"copy.png";
    NSString *imgBM = @"readlater.png";
    
    NSString *imgMail = @"mail.png";
    NSString *imgSMS = @"envelope.png";
    NSString *imgFB = @"facebook.png";
    NSString *imgTw = @"twitter.png";
    if([UIDeviceHardware isOS7Device]){
        
        imgCopy = @"ios7_copy.png";
        imgBM = @"ios7_readlater.png";
        
        imgMail = @"ios7_mail.png";
        imgSMS = @"ios7_envelope.png";
        imgFB = @"ios7_facebook.png";
        imgTw = @"ios7_twitter.png";
    }
    
    CustomButton *copyButton = [[CustomButton alloc] initWithFrame:CGRectZero Tag:kActionCopy Title:NSLocalizedString(@"action.copy", @"") Image:[UIImage imageNamed:imgCopy]];
 
    copyButton.btndelegate = self.btndelegate;
    
    [copyButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
    copyButton.tag = kActionCopy;
    [self.view addSubview:copyButton];   
    x += gap;
    
      
       
     
    CustomButton *bmButton = [[CustomButton alloc] initWithFrame:CGRectZero Tag:kActionBookmark Title:NSLocalizedString(@"action.bookmark", @"") Image:[UIImage imageNamed:imgBM]];
    bmButton.btndelegate = self.btndelegate;
    
    
    [bmButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
    bmButton.tag = kActionBookmark;
    [self.view addSubview:bmButton];
    x += gap;
    
    /*
    CustomButton *notess = [[CustomButton alloc] initWithFrame:CGRectZero Tag:kActionNotes Title:NSLocalizedString(@"action.notes", @"") Image:[UIImage imageNamed:@"notes.png"]];
    notess.btndelegate = self.btndelegate;
    
    
    notess.tag = kActionNotes;
    [notess setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
   
    [self.view addSubview:notess];
    x += gap;
     */

    
       
    /**** Mail Button **/
    
    CustomButton *mailButton = [[CustomButton alloc] initWithFrame:CGRectZero Tag:kActionMail Title:NSLocalizedString(@"action.mail", @"") Image:[UIImage imageNamed:imgMail]];
    
    mailButton.btndelegate = self.btndelegate;
   
    mailButton.tag = kActionMail;
  
    [mailButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
   
    [self.view addSubview:mailButton];
    x += gap;
    
    if([UIDeviceHardware isIpad]){
        
        y+=55;
        x = 70;
    }else{
        y+=45;
        x = 55;//30
    }

    
   
    /**** SMS Button **/
    
    CustomButton *smsButton = [[CustomButton alloc] initWithFrame:CGRectZero Tag:kActionSMS Title:NSLocalizedString(@"action.sms", @"") Image:[UIImage imageNamed:imgSMS]];
    smsButton.btndelegate = self.btndelegate;
    
    smsButton.tag = kActionSMS;
    [smsButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
    
    [self.view addSubview:smsButton];
    x += gap;
    
    
    NSInteger ftag = 0;
    if ([UIDeviceHardware isOS6Device] && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        ftag = kActionFB;
    }
    
    
        CustomButton *fbButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 30, 35) Tag:ftag Title:NSLocalizedString(@"action.facebook", @"") Image:[UIImage imageNamed:imgFB]];
    if(ftag == 0){
        
        fbButton.alpha = .4;
    }
        fbButton.btndelegate = self.btndelegate;
    
        [fbButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
        
        [self.view addSubview:fbButton];
        x += gap;
   
    
    
    NSInteger ttag = 0;
    if ([UIDeviceHardware isOS6Device] && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        ttag = kActionTwitter;
    }
    
    
        CustomButton *twButton = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 30, 35) Tag:ttag Title:NSLocalizedString(@"action.twitter", @"") Image:[UIImage imageNamed:imgTw]];
        twButton.btndelegate = self.btndelegate;
    
    if(ttag == 0){
        
        twButton.alpha = .4;
    }
    
        [twButton setFrame:CGRectMake(x, y, btnwidth, btnHeight)];
        
        [self.view addSubview:twButton];
        
    
    
    
        

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
