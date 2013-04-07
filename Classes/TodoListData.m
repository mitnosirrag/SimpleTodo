//
//  TodoListData.m
//  Simple Todo
//
//  Created by Tim Garrison on 3/11/10.
//  Copyright 2010 Implied Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "TodoListData.h"


@implementation TodoListData

NSString * const APPLICATION_SUPPORT_DIRECTORY = @"~/Library/Application Support/Simple Todo/";
NSString * const USER_SETTINGS_FILENAME = @"todoListData.plist";

@synthesize filePath, sourcePath;
@synthesize todoListItems;

- (id) init {
    if ( self = [super init] ) {
        [self loadTodoListDataToDictionary];
        if ( nil == self.todoListItems ) {
            self.todoListItems = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

+ (NSString *)pathForTodoListData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = APPLICATION_SUPPORT_DIRECTORY;
    folder = [folder stringByExpandingTildeInPath];
    NSString *fileName = USER_SETTINGS_FILENAME;
    fileName = [NSString stringWithFormat:@"%@/%@",
                folder,
                USER_SETTINGS_FILENAME];
    if ( NO == [fileManager fileExistsAtPath: folder] ) {
        [fileManager createDirectoryAtPath: folder attributes:nil];
    }
    if ( NO == [fileManager fileExistsAtPath:fileName] ) {
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
    }
    
    return fileName;
}

- (void)removeTodoListItemFromDictionary:(NSInteger)tag {
    [self.todoListItems removeObjectForKey:[NSString stringWithFormat:@"%i",tag]];
}

- (void)setTodoListItemsKeyValue:(NSInteger)key value:(NSString *)value {
    [self.todoListItems setObject:value forKey:[NSString stringWithFormat:@"%i",key]];
}

- (void)writeTodoListToPlist {
    [self.todoListItems writeToFile:[TodoListData pathForTodoListData] atomically:YES];
}

- (void)loadTodoListDataToDictionary {
    self.todoListItems = [[NSMutableDictionary alloc] 
                                  initWithContentsOfFile:[TodoListData pathForTodoListData]];
}

- (int)addToLoginItems {
    NSBundle *appBundle = [NSBundle bundleWithIdentifier:@"com.productofdivorce.SimpleTodo"];
    NSString *pathToApp = [appBundle bundlePath];
    
    OSStatus status;
    CFURLRef URLToToggle = (CFURLRef)[NSURL fileURLWithPath:pathToApp];
    LSSharedFileListItemRef existingItem = NULL;
   	LSSharedFileListRef loginItems = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListSessionLoginItems, /*options*/ NULL);
    
    UInt32 seed = 0U;
    NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
    for (id itemObject in currentLoginItems) {
        LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
        
        UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
        CFURLRef URL = NULL;
        OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, NULL);
        if ( err == noErr ) {
            Boolean foundIt = CFEqual(URL, URLToToggle);
            CFRelease(URL);
            
            if ( foundIt ) {
                existingItem = item;
                return 0; // already in place
            }
        }
    }
    
    if ( NULL == existingItem ) {
        NSString *displayName = [[NSFileManager defaultManager] displayNameAtPath:pathToApp];
        IconRef icon = NULL;
        FSRef ref;
        Boolean gotRef = CFURLGetFSRef(URLToToggle, &ref);
        if ( gotRef ) {
            status = GetIconRefFromFileInfo(&ref, 0, NULL,kFSCatInfoNone, NULL,kIconServicesNormalUsageFlag, &icon, NULL);
            if ( noErr != status ) {
                icon = NULL;
            }
        }
        
        LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst, (CFStringRef)displayName, icon, URLToToggle, NULL, NULL);
    } else if ( NULL != existingItem ) {
        // this isnt good
        return 2; // app fails to add to login items
    }
    
    return 1; // app now a login item
}


@end
