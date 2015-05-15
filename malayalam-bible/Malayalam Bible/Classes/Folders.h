//
//  Folders.h
//  Malayalam Bible
//
//  Created by jijo Pulikkottil on 19/07/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BookMarks, Folders, Notes;

@interface Folders : NSManagedObject

@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * folder_color;
@property (nonatomic, retain) NSString * folder_label;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) Folders *parentfolder;
@property (nonatomic, retain) NSSet *subfolders;
@end

@interface Folders (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(BookMarks *)value;
- (void)removeBookmarksObject:(BookMarks *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;
- (void)addNotesObject:(Notes *)value;
- (void)removeNotesObject:(Notes *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
- (void)addSubfoldersObject:(Folders *)value;
- (void)removeSubfoldersObject:(Folders *)value;
- (void)addSubfolders:(NSSet *)values;
- (void)removeSubfolders:(NSSet *)values;
@end
