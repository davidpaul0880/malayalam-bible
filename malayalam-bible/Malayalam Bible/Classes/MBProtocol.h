//
//  MBProtocol.h
//  Malayalam Bible
//
//  Created by jijo on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookMarks.h"
#import "Notes.h"

@protocol MBProtocol <NSObject>

@optional

- (void) setBookMarkForIds:(BookMarks *)bookMark;;
- (void) setSelectedRow:(NSUInteger)roww IsPrimary:(BOOL)isPrimary;
- (void) addedNotes:(Notes *)note;

@end
