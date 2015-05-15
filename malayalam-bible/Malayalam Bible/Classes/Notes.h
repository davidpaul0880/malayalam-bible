//
//  Notes.h
//  Malayalam Bible
//
//  Created by jijo on 8/27/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folders;

@interface Notes : NSManagedObject

@property (nonatomic, retain) NSNumber * bookid;
@property (nonatomic, retain) NSNumber * chapter;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * notesdescription;
@property (nonatomic, retain) NSString * verseid;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSDate * modifieddate;
@property (nonatomic, retain) Folders *folder;

@end
