//
//  VerseEditViewController.m
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 16/10/13.
//
//

#import "VerseEditViewController.h"

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "mal_api.h"
#include "txt2html.h"
#import "BibleDao.h"
#import "MBConstants.h"
#import "mozhi_unicode_default.h"

@interface VerseEditViewController ()

@end

@implementation VerseEditViewController

- (id)initWithVerse:(NSDictionary *)dictVersee BookId:(NSInteger)bookid AndChapterId:(NSInteger)chpaterid
{
    self = [super init];
    if (self) {
        // Custom initialization
        vtextView = [[UITextView alloc] init];
        vtextView.autocorrectionType = UITextAutocorrectionTypeNo;
        dictVerse = dictVersee;
        
        sbookid = bookid;
        schapterid = chpaterid;
        
        vtextView.delegate = self;
      
        vtextView.text = [dictVerse valueForKey:@"versetoedit"];
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    vtextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    vtextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vtextView.font = [UIFont systemFontOfSize:FONT_SIZE];
    [self.view addSubview:vtextView];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateVerse)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) onChange:(id)ss{
    
    
    long flags = FL_DEFAULT;
    char *output = mozhi_unicode_parse([vtextView.text UTF8String], flags);
    NSString *outputStr = [NSString stringWithUTF8String:output];
    vtextView.delegate = nil;
    vtextView.text = outputStr;
    vtextView.delegate = self;
    
}

- (void)textViewDidChange:(UITextView *)textView{
    //+20150908
    BOOL isCustomkb = [[NSUserDefaults standardUserDefaults] boolForKey:kCustomKB];
    if (!isCustomkb) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onChange:) object:nil];
        [self performSelector:@selector(onChange:) withObject:nil afterDelay:1.00];
    }
 
 
 
}
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSMutableString *updatedText = [[NSMutableString alloc] initWithString:textView.text];
    
    
    NSString *tempStruptoedit = [updatedText substringToIndex:range.location];
    NSRange tempafterSpaceRange = [tempStruptoedit rangeOfString:@" " options:NSBackwardsSearch];
    
    NSRange afterSpaceRange = NSMakeRange(0, 0);
    
    if(tempafterSpaceRange.length > 0){
        
        afterSpaceRange =tempafterSpaceRange;
    }
    
    MBLog(@"afterSpaceRange.location = %i", afterSpaceRange.location);
    
    [updatedText insertString:text atIndex:range.location];
    
    NSRange afterCharRange = NSMakeRange(0, 0);
    
    if(text.length > 0){
        
        MBLog(@"text = %@", text);
        
        MBLog(@"updatedText = %@", updatedText);
        
        afterCharRange = [updatedText rangeOfString:text options:NSBackwardsSearch];
        
        if(afterCharRange.length > 0){
            
            
            MBLog(@"afterCharRange.location = %i", afterCharRange.location);
            MBLog(@"afterCharRange.length = %i", afterCharRange.length);
            
            NSRange replaceRange = NSMakeRange(afterSpaceRange.location, (afterCharRange.location+afterCharRange.length - afterSpaceRange.location));
            NSRange endRange = range;
            
            NSString *strToreplace = [updatedText substringWithRange:replaceRange];
            
            MBLog(@"strToreplace = %@", strToreplace);
            
            
            long flags = FL_DEFAULT;
            char *output = mozhi_unicode_parse([strToreplace UTF8String], flags);
            NSString *outputStr = [NSString stringWithUTF8String:output];
            
            
            MBLog(@"outputStr = %@", outputStr);
            
            int replaceCount = [updatedText replaceOccurrencesOfString:strToreplace withString:outputStr options:NSCaseInsensitiveSearch range:replaceRange];
            
            if (replaceCount > 0) {
                
                textView.text = updatedText;
                
                // leave cursor at end of inserted text
                endRange.location += text.length;
                endRange.length = 0;
                textView.selectedRange = endRange;
                
                return NO;
            }

        }
        
        
        
    }else{
        afterCharRange.location = range.location;
        afterCharRange.length = -1;
    }
    
  
    
    
    return YES;
}
 */
-(void)updateVerse{
    
    NSString *sql = [NSString stringWithFormat:@"update verses set verse_text='%@' where book_id=%li and chapter_id=%li and verse_id=%li", vtextView.text, (long)sbookid, (long)schapterid, (long)[[dictVerse valueForKey:@"verseid"] integerValue]];
    
    MBLog(@"sql = %@", sql);
    /*NSRange range = [sql rangeOfString:@"\""];
    if(range.location != NSNotFound){
        sql = [sql stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    }
    MBLog(@"sql = %@", sql);
    */
    BibleDao *daoo = [[BibleDao alloc] init];
    if([daoo executeQuery:sql]){
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"queries"];
        BOOL isDire = YES;
        
        if(![fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDire]){
            
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        NSString *localStringPath = [documentsDirectory stringByAppendingPathComponent:@"myedit.sql"];
        
        if(![fileManager fileExistsAtPath:localStringPath]){
            
            NSString *strToWrite = @"/*\nEdited Verses\n*/";
            [strToWrite writeToFile:localStringPath atomically:YES encoding: NSUTF8StringEncoding error:nil];
        }
        
        
        NSString *strToAppend = [NSString stringWithFormat:@"\n%@;", sql];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:localStringPath];
        [fileHandle seekToEndOfFile];
        NSData *textData = [strToAppend dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:textData];
        [fileHandle closeFile];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyTableReload" object:nil userInfo:nil]; 
    }
    
    
    
}
@end
