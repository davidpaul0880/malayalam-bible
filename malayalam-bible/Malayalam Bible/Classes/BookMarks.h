//
//  BookMarks.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 19/07/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folders;

@interface BookMarks : NSManagedObject

@property (nonatomic, retain) NSString * bmdescription;
@property (nonatomic, retain) NSNumber * bookid;
@property (nonatomic, retain) NSNumber * chapter;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * verseid;
@property (nonatomic, retain) NSString * versetitle;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) Folders *folder;

@end
