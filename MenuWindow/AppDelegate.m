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

@synthesize connection = _connection;
@synthesize receivedData = _receivedData;
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)controlTextDidChange: (NSNotification *)aNotification
{
    NSString *searchString = [self.searchField stringValue];
    NSLog(@"%@", searchString);
    if ([searchString isEqualToString:@"test"] || [searchString isEqualToString:@""])
    {
        [self closeMenuWindown];
    }
    else
    {
        if (self.connection)
        {
            [self.connection cancel];
        }
        NSString *url = [NSString stringWithFormat:@"http://appstore.mac.xunlei.com/common/search_suggestions.php?word=%@", searchString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:15.0];


        self.receivedData = [NSMutableData dataWithCapacity: 0];
        
        // create the connection with the request
        // and start loading the data
        self.connection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
        
        
        NSMutableArray *menuItems = [[NSMutableArray alloc]init];
        int j = random() % 6 + 1;
        for (int i=0; i < j; i++)
        {
            NSString *result = [NSString stringWithFormat:@"i = %lu", random()];
            SYXMenuItem *item = [[SYXMenuItem alloc] init];
            item.title = result;
            [menuItems addObject:item];
        }
        
        if (!self.menuWindow)
        {
            self.menuWindow = [[SYXMenuWindowController alloc] initWithWindowNibName:@"SYXMenuWindow"];
            self.menuWindow.delegate = self;
        }
        
        [self.menuWindow setMenuItems:menuItems];
        if (menuItems.count > 0)
        {
            [self showMenuWindow];
        }
        
    }
}

#pragma mark - connection delegate

//响应的时候触发
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

//有新的数据收到，会触发，我们把新的数据append
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

//完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receivedDataString = [[[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"receivedDataString = %@", receivedDataString);

}

//错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

- (void)closeMenuWindown
{
    [self.menuWindow closeWindow];
}

- (void)showMenuWindow
{

    [self popUpMenuWindowBehindSearchField];
    //必须remove后再add，否则close childWindow再打开childWindow，移动父窗口，子窗口不会跟着一起移动
    [self.window removeChildWindow:self.menuWindow.window];
    [self.window addChildWindow:self.menuWindow.window ordered:NSWindowAbove];
}

- (void)popUpMenuWindowBehindSearchField
{
    [self.menuWindow popUpContextMenuAtPoint:NSMakePoint(self.window.frame.origin.x + self.searchField.frame.origin.x, self.window.frame.origin.y + self.searchField.frame.origin.y -2)];
}


- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    if (commandSelector == @selector(insertNewline:))
    {
		// enter pressed
        NSInteger selectedRow = [self.menuWindow.itemsTable selectedRow];
        if (selectedRow >= 0)
        {
            self.searchField.stringValue = ((SYXMenuItem *)[self.menuWindow.menuItems objectAtIndex:selectedRow]).title;
        }
        else
        {
        }
        [self closeMenuWindown];
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
    NSInteger selectedRow = [self.menuWindow.itemsTable selectedRow];
    selectedRow --;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow];
    [self.menuWindow.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (void)moveDown
{
    NSInteger selectedRow = [self.menuWindow.itemsTable selectedRow];
    selectedRow ++;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:selectedRow];
    [self.menuWindow.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (void)onMouseDownAtRow:(NSUInteger)rowIndex
{
    self.searchField.stringValue = ((SYXMenuItem *)[self.menuWindow.menuItems objectAtIndex:rowIndex]).title;
    [self closeMenuWindown];

}

@end
