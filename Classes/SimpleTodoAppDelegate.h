//
//  SimpleTodoAppDelegate.h
//  SimpleTodo
//
//  Created by Tim Garrison on 3/10/10.
//  Copyright 2010 Implied Solutions. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TodoListData.h"

@interface SimpleTodoAppDelegate : NSObject {

    NSMutableDictionary *todoListItems;
    
    IBOutlet NSMenu      *menu;
    
    IBOutlet NSPanel     *todoItemPanel;
    IBOutlet NSTextField *todoItemTextField;
    IBOutlet NSButton    *addTodoItemButton;
    IBOutlet NSButton    *cancelButton;
    
    NSStatusItem *statusItem;
    
    NSImage *menuImage;
    NSImage *menuImageSelected;
    
    BOOL todoListLoaded;
    
}

@property (retain) NSMutableDictionary *todoListItems;
@property (retain) IBOutlet NSPanel *todoItemPanel;
@property (retain) IBOutlet NSTextField *todoItemTextField;
@property (retain) IBOutlet NSButton *addTodoItemButton;
@property (retain) IBOutlet NSButton *cancelButton;

- (void)addItemToMenu:(NSString *)todoItem tag:(NSInteger)tag;
- (void)resetTodoItemTextField;
- (void)showTodoItemPanel;

- (IBAction)addTodoItemButtonClicked:(id)sender;
- (IBAction)showNewItemDialogue:(id)sender;
- (IBAction)checkForUpdates:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)shutdown:(id)sender;

@end
