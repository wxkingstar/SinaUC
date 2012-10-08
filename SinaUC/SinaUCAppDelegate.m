//
//  SinaUCAppDelegate.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCAppDelegate.h"

@implementation SinaUCAppDelegate

- (void) awakeFromNib
{
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    loginWindowController = [[SinaUCLoginWindowController alloc] init];
    launchedWindowController = [[SinaUCLaunchedWindowController alloc] init];
    [launchedWindowController showWindow:nil];
    [[launchedWindowController window] orderOut:nil];
    [loginWindowController showWindow:nil];
}

@end
