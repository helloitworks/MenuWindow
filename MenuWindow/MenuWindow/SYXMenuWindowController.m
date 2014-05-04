//
//  SYXMenuWindowController.m
//  StatusItem
//
//  Created by shenyixin on 14-4-24.
//
//

#import "SYXMenuWindowController.h"
#import "RoundWindowFrameView.h"
#import "SYXMenuItem.h"
#import "DetectingTableView.h"

@interface SYXMenuWindowController ()
@end

@implementation SYXMenuWindowController
@synthesize itemsTable = itemsTable;
@synthesize delegate = delegate;
@synthesize menuItems = menuItems;

- (id)initWithWindowNibName:(NSString *)windowNibName {
	self = [super initWithWindowNibName:windowNibName];
	if (self) {
    }
    return self;
}

#pragma mark - 弹出窗口

- (void)popUpContextMenuAtPoint:(NSPoint)point {
	if (timer) { // Window shouldn't be closing right now. Stop the timer.
		[timer invalidate];
        [timer release];
        timer = nil;
		[self.window setAlphaValue:1.0];
	}
	
	[self loadHeightsWithWindowOrigin:point];
    [self.window orderFront:nil];
}

// 在指定的Point弹出窗口
- (void)loadHeightsWithWindowOrigin:(NSPoint)point {
    NSRect newWindowFrame = self.window.frame;

	int sizeOfCellsInTableView = 0;
    for (SYXMenuItem *item in self.menuItems) {
		sizeOfCellsInTableView += [self.itemsTable rectOfRow:[menuItems indexOfObject:item]].size.height;
	}
    
    //设置新窗口的大小
    newWindowFrame.size.height = sizeOfCellsInTableView + 10;
    newWindowFrame.origin.y = point.y - newWindowFrame.size.height - 2;
	newWindowFrame.origin.x = point.x;

    [self.window setFrame:newWindowFrame display:YES];

    //将contentView的superview改成四角都是圆角
    [(RoundWindowFrameView *)[[self.window contentView] superview] setAllCornersRounded:YES];
	//[(RoundWindowFrameView *)[[self.window contentView] superview] setProMode:YES];
    
    //设置新contentview的大小
    NSRect contentViewFrame = newWindowFrame;
    contentViewFrame.origin.x = 0;
    contentViewFrame.origin.y = 5;
    contentViewFrame.size.height -= 10;
    [self.window.contentView setFrame:contentViewFrame];
    [(RoundWindowFrameView *)[self.window contentView] setFrame:contentViewFrame];

    //设置tableview的大小
    //table的position是相对于contentview的，所以origin.y设置成0，而不是5
    NSRect tableOldFrame = self.itemsTable.frame;
    tableOldFrame.origin.x = 0;
    tableOldFrame.size.height = sizeOfCellsInTableView;
    tableOldFrame.origin.y = 0;
    [[[self.itemsTable superview] superview] setFrame:tableOldFrame];
}

#pragma mark 关闭窗口

- (void)closeWindow
{
    //下面两行用于立即关闭窗口，而不是渐渐退隐窗口
    [self.window orderOut:nil];
    return;
    
    //todo:渐渐退隐窗口会有焦点的问题.
    timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fade:) userInfo:nil repeats:YES] retain];
}


- (void)fade:(NSTimer *)theTimer
{
    
    if ([self.window alphaValue] > 0.0) {
        // If window is still partially opaque, reduce its opacity.
        [self.window setAlphaValue:[self.window alphaValue] - 0.3];
    } else {
        // Otherwise, if window is completely transparent, destroy the timer and close the window.
        [timer invalidate];
        [timer release];
        timer = nil;
        
        [self.window orderOut:nil];
        
        // Make the window fully opaque again for next time.
        [self.window setAlphaValue:1.0];
    }
}


#pragma mark - tableview data

- (NSArray *)menuItems {
	return menuItems;
}

- (void)setMenuItems:(NSArray *)items {
	menuItems = [items copy];
	[self.itemsTable reloadData];
    //syx:todo
	//[self loadHeights];
}

- (SYXMenuItem *)_entityForRow:(NSInteger)row {
    return (SYXMenuItem *)[self.menuItems objectAtIndex:row];
}


#pragma mark  tableview datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger count = [self.menuItems count];
    return count;
}


#pragma mark  tableview delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 24.f;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    SYXMenuItem *item = [self _entityForRow:row];
    NSString *identifier = [tableColumn identifier];
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
    cellView.textField.stringValue = item.title;
    return cellView;

}

////menuWindow作为子窗口非焦点弹出（因为焦点会抢占搜索框输入），tableViewSelectionDidChange需要在焦点的时候才会触发，导致要点击两次才有效。
//所以不采用这个函数来捕获鼠标点击，而是采用DetectingTableView里面捕获mouseDown，再根据mouse down point算出点击了那一行，并调用delegate的onMouseDownAtRow:
//这个函数只用来处理选择事件
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSIndexSet *selectedRowIndexs = [self.itemsTable selectedRowIndexes];
	if(selectedRowIndexs == nil || selectedRowIndexs.count == 0 )
    {
		return;
	}
    else if(selectedRowIndexs.count == 1)
    {
        NSInteger row = selectedRowIndexs.firstIndex;
        NSLog(@"you click row %lu",row);
        //[self closeWindow];
        NSInteger selectedRow = [self.itemsTable selectedRow];
        NSTableRowView *myRowView = [self.itemsTable rowViewAtRow:selectedRow makeIfNecessary:NO];
        [myRowView setEmphasized:YES];
    }
    else
    {
        NSLog(@"you select multiple row");
    }
}


#pragma mark - mouse action

- (void)onMouseEnteredAtRow:(NSUInteger)rowIndex
{
    NSLog(@"onMouseEnteredAtRow row=%lu",rowIndex);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:rowIndex];
    [self.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (void)onMouseExitedAtRow:(NSUInteger)rowIndex
{
    NSLog(@"onMouseExitedAtRow row=%lu",rowIndex);
    [self.itemsTable deselectAll:nil];
}

- (void)onMouseMovedAtRow:(NSUInteger)rowIndex
{
    NSLog(@"onMouseMovedAtRow row=%lu",rowIndex);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:rowIndex];
    [self.itemsTable selectRowIndexes:indexSet byExtendingSelection:NO];
}


- (void)onMouseDownAtRow:(NSUInteger)rowIndex
{
    NSLog(@"onMouseDownAtRow row=%lu",rowIndex);
    
    if ([self.delegate respondsToSelector:@selector(onMouseDownAtRow:)])
    {
        [self.delegate onMouseDownAtRow:rowIndex];
    }
}

@end
