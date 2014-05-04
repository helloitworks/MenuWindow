//
//  AppDelegate.h
//  MenuWindow
//
//  Created by shenyixin on 14-4-24.
//  Copyright (c) 2014年 shenyixin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SYXMenuWindowController;
@protocol SYXMenuWindowControllerViewDelegate;

@interface AppDelegate : NSObject <NSApplicationDelegate, SYXMenuWindowControllerViewDelegate>
{
    NSSearchField *_searchField;

}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSearchField *searchField;


@property (retain) SYXMenuWindowController *menuWindow;

- (void)onMouseDownAtRow:(NSUInteger)rowIndex;

@end
