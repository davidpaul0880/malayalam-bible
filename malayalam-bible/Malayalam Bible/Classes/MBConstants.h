//
//  MBConstants.h
//  Malayalam Bible
//
//  Created by jijo on 1/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kStoreThemeColor @"themecolor"

#define kStoreColor1 @"Color1"
#define kStoreColor2 @"Color2"
#define kStoreColor3 @"Color3"
#define kStoreColor4 @"Color4"
#define kStoreColor5 @"Color5"

extern  CGFloat FONT_SIZE;

#define kFontMaxSize 25
#define kFontMinSize 9
#define kActionViewWidth    250

extern const NSString *bmBookSection;


extern  NSString * const kLangPrimary;
extern  NSString * const kLangEnglishASV;
extern  NSString * const kLangEnglishKJV;
extern  NSString * const kLangNone;

extern  NSString * const kStorePreference;

extern  NSString * const kBookAll;
extern  NSString * const kBookNewTestament;
extern  NSString * const kBookOldTestament;

extern  NSString * const kFontName;
extern  NSString * const kNightTime;
extern  NSString * const kCustomKB;
extern  NSString * const kScrollEnable;
extern  NSString * const kScrollSpeed;
extern CGFloat statusBarHeight;
extern BOOL isDetailControllerVisible;

@interface MBConstants : NSObject

@end
//+20130903
@interface UIColor (MyProject)
+(UIColor *)defaultBlueColor;
+(UIColor *) defaultWindowColor;

@end