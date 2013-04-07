//
//  SimpleTodoAppDelegate.m
//  SimpleTodo
//
//  Created by Tim Garrison on 3/10/10.
//  Copyright 2010 Implied Solutions. All rights reserved.
//

#import "SimpleTodoAppDelegate.h"
#import "ArrayFunctions.h"

#define kMenuItemCountMinimum 6 // this includes a seperator, so it would default to 5 before an item is added, then go to 7
#define kTodoItemLengthMaximumChars 40
#define kTodoItemTruncateLength 3
#define kTodoItemSeparatorIndex 1
#define kTodoItemNewIndex 2


@implementation SimpleTodoAppDelegate

@synthesize todoListItems;
@synthesize todoItemPanel;
@synthesize todoItemTextField;
@synthesize addTodoItemButton;
@synthesize cancelButton;

- (void)dealloc {
    [menuImage release];
    [menuImageSelected release];
    [super dealloc];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    todoListLoaded = FALSE;
    TodoListData *todoListData = [[TodoListData alloc] init];
    self.todoListItems = [todoListData todoListItems];
    if ( 2 == [todoListData addToLoginItems] ) {
        NSString *humanReadableError = @"Unable to add to Login Items, this app will not launch automatically at Login";
        [NSApp activateIgnoringOtherApps:YES];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:humanReadableError];
        [alert runModal];
        return;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	
	NSBundle *bundle = [NSBundle mainBundle];
    menuImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menuImage" ofType:@"png"]];
    menuImageSelected = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"menuImageSelected" ofType:@"png"]];
    [statusItem setImage:menuImage];
    [statusItem setAlternateImage:menuImageSelected];
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    
    if ( 0 < [self.todoListItems count] ) {
        NSArray *keys = [[todoListItems allKeys] sortedArrayUsingFunction:intSort context:NULL];
        for ( int i = 0; i < [keys count]; i++ ) {
            NSString *todoItem = [todoListItems objectForKey:[keys objectAtIndex:i]];
            NSInteger tag      = [[keys objectAtIndex:i] intValue];
            [self addItemToMenu:todoItem tag:tag];
        }
    }
    todoListLoaded = TRUE;
}

- (void)addItemToMenu:(NSString *)todoItem tag:(NSInteger)tag {
    
    NSString *toolTip = [NSString stringWithString:todoItem];
    if ( kTodoItemLengthMaximumChars < [todoItem length] ) {
        todoItem = [NSString stringWithFormat:@"%@...",
                    [todoItem substringToIndex:(kTodoItemLengthMaximumChars - kTodoItemTruncateLength)]];
    }
    
    if ( kMenuItemCountMinimum >= [menu numberOfItems] ) {
        [menu insertItem:[NSMenuItem separatorItem] atIndex:kTodoItemSeparatorIndex];
    }
    
    NSMenuItem *tempMenuItem;
    
    tempMenuItem = (NSMenuItem *)[menu insertItemWithTitle:todoItem 
                                                    action:@selector(removeItemFromMenu:) 
                                             keyEquivalent:@"" 
                                                   atIndex:kTodoItemNewIndex];
    [tempMenuItem setTarget:self];
    [tempMenuItem setToolTip:toolTip];
    [tempMenuItem setTag:tag];
    [statusItem setMenu:menu];
    
    if ( FALSE != todoListLoaded ) {
        TodoListData *todoListData = [[TodoListData alloc] init];
        [todoListData setTodoListItemsKeyValue:tag 
                                         value:todoItem];
        
        [todoListData writeTodoListToPlist];
    }
}

- (void)removeItemFromMenu:(NSMenuItem *)sender {
    NSInteger tag = [sender tag];
    [menu removeItem:(NSMenuItem *)sender];
    TodoListData *todoListData = [[TodoListData alloc] init];
    [todoListData removeTodoListItemFromDictionary:tag];
    [todoListData writeTodoListToPlist];
    if ( kMenuItemCountMinimum >= [menu numberOfItems] ) {
        [menu removeItemAtIndex:kTodoItemSeparatorIndex];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    return YES;
}

- (void)emptyMethod {
        return;
}        

- (IBAction)addTodoItemButtonClicked:(id)sender {
    /* 
     timestamp is the epoch since 311 day 2010, but its also an int so it can be used as the NSMenuItem.tag... 
     so essentially this app has a lifespan which is until that is bigger than an int :-\
     */
    NSDate *now              = [[NSDate alloc] init];
    NSDate *epoch            = [[NSDate alloc] initWithString:@"2010-03-11 03:11:00 -0800"];
    NSTimeInterval timestamp = [now timeIntervalSinceDate:epoch];
    timestamp                = (int)timestamp;
    NSString *todoItem       = [todoItemTextField stringValue];
    if ( 0 != [todoItem length] ) {
        [self addItemToMenu:todoItem tag:timestamp];
        [todoItemPanel close];
    }
}

- (void)resetTodoItemTextField {
    [addTodoItemButton setEnabled:NO];
    [todoItemTextField setStringValue:@""];
}

- (void)todoItemTextDidChange {
    if ( 0 != [[todoItemTextField stringValue] length] ) {
        [addTodoItemButton setEnabled:YES];
    } else {
        [addTodoItemButton setEnabled:NO];
    }
}

- (void)showTodoItemPanel; {
    [self resetTodoItemTextField];
    [NSApp activateIgnoringOtherApps:YES];
    if ( ![todoItemPanel isVisible] ) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(todoItemTextDidChange)  
                                                     name:NSControlTextDidChangeNotification 
                                                   object:todoItemTextField];
        [todoItemPanel makeFirstResponder:todoItemTextField];
    }
    [todoItemPanel makeKeyAndOrderFront:nil];
    [self resetTodoItemTextField];
}
                    
- (IBAction)showNewItemDialogue:(id)sender {
    [self showTodoItemPanel];
}

- (IBAction)checkForUpdates:(id)sender {
	NSLog(@"checking for updates");
}
	
- (IBAction)showAbout:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}

- (IBAction)shutdown:(id)sender {
	[NSApp replyToApplicationShouldTerminate:YES];
	[NSApp terminate:sender];
}

@end
