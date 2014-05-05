//
//  SYXMenuWindowController.h
//  StatusItem
//
//  Created by shenyixin on 14-4-24.
//
//

#import <Cocoa/Cocoa.h>
#import "SYXMenuItem.h"

@class DetectingTableView;
@protocol DetectingTableViewDelegate;


@protocol SYXMenuWindowControllerViewDelegate
@optional
- (void)onMouseDownAtRow:(NSUInteger)rowIndex;
@end

@interface SYXMenuWindowController : NSWindowController<DetectingTableViewDelegate>
{
    NSTimer *timer; // PRIVATE: Used for fade out.
	NSArray *menuItems; //tableview的数据
	DetectingTableView *itemsTable; //tableview
    id delegate;

}

@property (retain) IBOutlet DetectingTableView *itemsTable;
@property (nonatomic, retain) NSArray *menuItems;
@property (assign)  id delegate;

@property (assign)  NSUInteger windowWidth;

- (void)popUpContextMenuAtPoint:(NSPoint)point;
- (void)loadHeightsWithWindowOrigin:(NSPoint)point;

- (void)closeWindow;

- (void)onMouseEnteredAtRow:(NSUInteger)rowIndex;
- (void)onMouseExitedAtRow:(NSUInteger)rowIndex;
- (void)onMouseMovedAtRow:(NSUInteger)rowIndex;

- (void)onMouseDownAtRow:(NSUInteger)rowIndex;
@end
