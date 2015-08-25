//
//  MBConstants.m
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBConstants.h"
#import "ColorViewController.h"

@implementation MBConstants

CGFloat FONT_SIZE = 17;

const NSString *bmBookSection = @"BookPathSection";
//const NSString *bmBookRow = @"BookPathRow";

NSString * const kLangPrimary = @"malayalam";
NSString * const kLangEnglishASV = @"english_asv";
NSString * const kLangEnglishKJV = @"english_kjv";
NSString * const kLangNone = @"none";

NSString * const kStorePreference = @"Preferences";


NSString * const kBookAll = @"All";
NSString * const kBookNewTestament = @"New Testament";
NSString * const kBookOldTestament = @"Old Testament";

NSString * const kFontName = @"Helvetica";
NSString * const kNightTime = @"kNightTime";
NSString * const kCustomKB = @"kCustomKB";
NSString * const kScrollEnable = @"kScrollEnable";
NSString * const kScrollSpeed = @"kScrollSpeed";
CGFloat statusBarHeight = 20;
BOOL isDetailControllerVisible = YES;

@end
@implementation UIColor (MyProject)
+(UIColor *)defaultBlueColor{
    
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

+(UIColor *) defaultWindowColor {
    
    NSInteger colorr = [[NSUserDefaults standardUserDefaults] integerForKey:@"themecolor"];
    if(colorr == 0){
        colorr = 3;
    }
    
    return [[ColorViewController arrayColors] objectAtIndex:colorr-1];
    
    
    //[UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
}//CJ 20131007 //[UIColor colorWithRed:69/255.0 green:157/255.0 blue:255/255.0 alpha:1]//+20131011 //green:122.0/255.0 blue:1.0 alpha:1.0

@end