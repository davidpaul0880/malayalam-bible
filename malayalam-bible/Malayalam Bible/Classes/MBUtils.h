//
//  MBUtils.h
//  Malayalam Bible
//
//  Created by jijo on 5/8/13.
//
//

#import <Foundation/Foundation.h>



@interface MBUtils : NSObject
+ (NSURL *)getBaseURL;
+ (NSString *) getHighlightColorof:(NSString *)colorConst;

@end

@interface UIColor(MBCategory)

+ (UIColor *)colorWithHex:(UInt32)col;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end