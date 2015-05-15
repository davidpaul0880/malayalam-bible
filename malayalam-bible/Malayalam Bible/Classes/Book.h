//
//  Book.h
//  Malayalam Bible
//
//  Created by Jeesmon Jacob on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject {
    NSString *alphaCode;
    int bookId;
    NSString *englishName;
    int numOfChapters;
    NSString *shortName;
    NSString *longName;
    NSString *displayValue;
}

@property(retain, readwrite) NSString *alphaCode;
@property(assign, readwrite) int bookId;
@property(retain, readwrite) NSString *englishName;
@property(assign, readwrite) int numOfChapters;
@property(retain, readwrite) NSString *shortName;
@property(retain, readwrite) NSString *longName;
@property(retain, readwrite) NSString *displayValue;
@end
