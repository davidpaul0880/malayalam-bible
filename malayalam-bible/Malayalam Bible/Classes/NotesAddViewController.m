//
//  NotesAddViewController.m
//  Malayalam Bible
//
//  Created by jijo on 8/21/13.
//
//

#import "NotesAddViewController.h"
#import "MalayalamBibleAppDelegate.h"
#import "UIDeviceHardware.h"
#import "MBConstants.h"

@interface NotesAddViewController ()
@property (nonatomic,strong) UITextView *textArea;
@end

@implementation NotesAddViewController

@synthesize notesNew, verseTitle, isEditingNote;
@synthesize delegatee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    bool isdark = [[NSUserDefaults standardUserDefaults] boolForKey:kNightTime];
    if([UIDeviceHardware isOS7Device]){
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
        //noneed[self setEdgesForExtendedLayout:UIRectEdgeNone];
    }else{
        
        if (isdark) {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            
        }else{
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        }
    }
    
    self.textArea = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

	self.textArea.autoresizingMask =	UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|
	UIViewAutoresizingFlexibleBottomMargin;

    self.textArea.delegate = self;
    self.textArea.font = [UIFont systemFontOfSize:16];
    if(notesNew){
        self.textArea.text = notesNew.notesdescription;
    }
	[self.view addSubview:self.textArea];
	
	
    
    
    
    //self.title = [NSString stringWithFormat:@"%@ for %@",NSLocalizedString(@"add.notes", @""), self.verseTitle];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveClicked:)];
    if(!isEditingNote){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked:)];
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    if(!isEditingNote){
        [self.textArea becomeFirstResponder];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) saveClicked:(UIBarButtonItem *)btn{
    
    [self.textArea resignFirstResponder];
    
    
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    
    
    if(isEditingNote){
        self.notesNew.modifieddate = [NSDate date];
    }else{
        self.notesNew.createddate = [NSDate date];
    }
    
    
     ///setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"createddate"];
  
    self.notesNew.notesdescription = self.textArea.text;
    
       
    NSError *error;
    [context save:&error];
   
    if(isEditingNote){
        [delegatee addedNotes:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
 
        [delegatee addedNotes:self.notesNew];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void) cancelClicked:(UIBarButtonItem *)btn{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    MalayalamBibleAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =  [appDelegate managedObjectContext];
    [context rollback];
}


#pragma mark KeyBoardnotifications

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up{
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.textArea.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    MBLog(@"keyboardFrame.size.height = %f", keyboardFrame.size.height);
    //newFrame.origin.y -= keyboardFrame.size.height * (up? 1 : -1);
    CGRect screenRect = [self.view bounds];
    if(up){
        newFrame.size.height = screenRect.size.height - keyboardFrame.size.height;
    }else{
        newFrame.size.height = screenRect.size.height;
    }
    
    self.textArea.frame = newFrame;
    
    [UIView commitAnimations];
}


-(void) keyboardWillShow:(NSNotification *)aNotification {
    
	
    [self moveTextViewForKeyboard:aNotification up:YES];
}

-(void) keyboardWillHide:(NSNotification *)aNotification
{
	[self moveTextViewForKeyboard:aNotification up:NO];
}

@end
