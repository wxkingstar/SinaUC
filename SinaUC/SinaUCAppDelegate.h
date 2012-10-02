//
//  SinaUCAppDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCConnectionDelegate.h"

@protocol SinaUCConnectionDelegate;
@interface SinaUCAppDelegate : NSObject <NSApplicationDelegate, SinaUCConnectionDelegate>

@property (assign) IBOutlet NSWindow *loginWindow;
@property (assign) IBOutlet NSWindow *launchedWindow;
@property (retain) NSMutableArray *activeDelegates;

- (void)onConnect;

@end
