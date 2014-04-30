//
//  SYXMenuItem.h
//  MenuWindow
//
//  Created by shenyixin on 14-4-24.
//  Copyright (c) 2014年 shenyixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYXMenuItem : NSObject
{
    NSString *_title;
    NSString *_url;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;

@end
