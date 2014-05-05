//
//  AppDelegate.m
//  MenuWindow
//
//  Created by shenyixin on 14-4-24.
//  Copyright (c) 2014年 shenyixin. All rights reserved.
//

#import "AppDelegate.h"
#import "SYXMenuWindowController.h"
#import "SYXMenuItem.h"

@implementation AppDelegate
@synthesize searchField = _searchField;
@synthesize menuWindowCtrl = _menuWindowCtrl;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:[NSApp mainWindow]];

}

- (void)controlTextDidChange: (NSNotification *)aNotification
{
    NSString *searchString = [self.searchField stringValue];
    NSLog(@"%@", searchString);
    if ([searchString isEqualToString:@""])
    {
        [self closeMenuWindow];
    }
    else
    {
        NSMutableArray *menuItems = [[NSMutableArray alloc]init];
        int j = random() % 6 + 1;
        for (int i=0; i < j; i++)
        {
            NSString *result = [NSString stringWithFormat:@"%@, row = %d", searchString, i];
            SYXMenuItem *item = [[SYXMenuItem alloc] init];
            item.title = result;
            [menuItems addObject:item];
        }
        
        if (!self.menuWindowCtrl)
        {
            self.menuWindowCtrl = [[SYXMenuWindowController alloc] initWithWindowNibName:@"SYXMenuWindow"];
            self.menuWindowCtrl.delegate = self;
            self.menuWindowCtrl.windowWidth = self.searchField.frame.size.width;
        }
        
        [self.menuWindowCtrl setMenuItems:menuItems];
        if (menuItems.count > 0)
        {
            [self showMenuWindow];
        }
        
    }
}

- (void)closeMenuWindow
{
    [self.menuWindowCtrl closeWindow];
}

- (void)showMenuWindow
{

    [self popUpMenuWindowBehindSearchField];
    //必须remove后再add，否则close childWindow再打开childWindow，移动父窗口，子窗口不会跟着一起移动
    [self.window removeChildWindow:self.menuWindowCtrl.window];
    [self.window addChildWindow:self.menuWindowCtrl.window ordered:NSWindowAbove];
}

- (void)popUpMenuWindowBehindSearchField
{
    [self.menuWindowCtrl popUpContextMenuAtPoint:NSMakePoint(self.window.frame.origin.x + self.searchField.frame.origin.x, self.window.frame.origin.y + self.searchField.frame.origin.y -2)];
}


- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    if (commandSelector == @selector(insertNewline:))
    {
		// enter pressed
        NSInteger selectedRow = [self.menuWindowCtrl.itemsTable selectedRow];
        if (selectedRow >= 0)
        {
            self.searchField.stringValue = ((SYXMenuItem *)[self.menuWindowCtrl.menuItems objectAtIndex:selectedRow]).title;
        }
        else
        {
        }
        //这里需要反选，否则下次直接enter pressed也被认为是有选中
        [self.menuWindowCtrl.itemsTable deselectAll:nil];
        [self closeMenuWindow];
		result = YES;
    }
	else if(commandSelector == @selector(moveLeft:))
    {
		// left arrow pressed
		//result = YES;
	}
	else if(commandSelector == @selector(moveRight:))
    {
		// rigth arrow pressed
		//result = YES;
	}
	else if(commandSelector == @selector(moveUp:))
    {
		// up arrow pressed
        [self moveUp];
		result = YES;
	}
	else if(commandSelector == @selector(moveDown:))
    {
		// down arrow pressed
        [self moveDown];
		result = YES;
	}
    return result;
}

- (void)moveUp
{
    NSInteger selectedRow = [self.menuWindowCtrl.itemsTable selectedRow];
    selectedRow --;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow];
    [self.menuWindowCtrl.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (void)moveDown
{
    NSInteger selectedRow = [self.menuWindowCtrl.itemsTable selectedRow];
    selectedRow ++;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow];
    [self.menuWindowCtrl.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (void)onMouseDownAtRow:(NSUInteger)rowIndex
{
    self.searchField.stringValue = ((SYXMenuItem *)[self.menuWindowCtrl.menuItems objectAtIndex:rowIndex]).title;
    [self closeMenuWindow];

}

//窗口resize时，关闭下拉列表
- (void)windowDidResize:(NSNotification *)notification
{
    [self closeMenuWindow];
}

@end
