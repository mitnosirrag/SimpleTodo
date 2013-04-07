//
//  TodoListData.h
//  Simple Todo
//
//  Created by Tim Garrison on 3/11/10.
//  Copyright 2010 Implied Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const APPLICATION_SUPPORT_DIRECTORY;
extern NSString * const USER_SETTINGS_FILENAME;

@interface TodoListData : NSObject {
    
    NSString *filePath, *sourcePath;
    NSMutableDictionary *todoListItems;
}

@property (retain) NSString *filePath, *sourcePath;
@property (retain) NSMutableDictionary *todoListItems;

+ (NSString *)pathForTodoListData;

- (int)addToLoginItems;
- (void)removeTodoListItemFromDictionary:(NSInteger)tag;
- (void)loadTodoListDataToDictionary;
- (void)setTodoListItemsKeyValue:(NSInteger)key value:(NSString *)value;
- (void)writeTodoListToPlist;


@end
