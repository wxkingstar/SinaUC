//
//  SinaUCLaunchedWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-7.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLaunchedWindowController.h"
#import "SinaUCLaunchedWindow.h"

@interface SinaUCLaunchedWindowController ()

@end

@implementation SinaUCLaunchedWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"LaunchedWindow"];
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (void)willConnect
{
}

- (void)didConnectedWithJid:(NSString*) jid
{
    INAppStoreWindow *aWindow = (INAppStoreWindow*)[self window];
    // Set titlebar height
    aWindow.titleBarHeight = 110.0;
    // Add the custom View as a SubView of the titleBar
    [aWindow.titleBarView addSubview:titleBar];
    [[self window] setAlphaValue:0.0];
    [[self window] makeKeyAndOrderFront:self];
    NSRect windowFrame = [self.window frame];
    windowFrame.origin.y -= 100;
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay+0.5];
    [[self.window animator] setAlphaValue:1.0];
    [[self.window animator] setFrame:windowFrame display:YES animate:YES];
}

- (void)didDisConnectedWithError:(NSInteger) error
{
}


@end
