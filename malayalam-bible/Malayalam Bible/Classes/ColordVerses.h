//
//  ColordVerses.h
//  Malayalam Bible
//
//  Created by jijo on 8/27/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ColordVerses : NSManagedObject

@property (nonatomic, retain) NSNumber * bookid;
@property (nonatomic, retain) NSNumber * chapter;
@property (nonatomic, retain) NSString * colorcode;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSNumber * verseid;
@property (nonatomic, retain) NSString * version;

@end
