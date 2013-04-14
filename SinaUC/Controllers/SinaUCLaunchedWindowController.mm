//
//  SinaUCLaunchedWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-7.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLaunchedWindowController.h"

@interface SinaUCLaunchedWindowController ()

@end

@implementation SinaUCLaunchedWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"LaunchedWindow"];
    INAppStoreWindow *aWindow = ((INAppStoreWindow*)[self window]);
    aWindow.titleBarHeight = 0;
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (void)willConnect
{
}

- (void)didConnectedWithJidForFirstTime:(NSString *)jid
{
    [[self window] setAlphaValue:0.0];
    [[self window] makeKeyAndOrderFront:self];
    NSRect windowFrame = [self.window frame];
    windowFrame.origin.y -= 100;
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay+0.5];
    [[self.window animator] setAlphaValue:1.0];
    [[self.window animator] setFrame:windowFrame display:YES animate:YES];
}

- (void)didConnectedWithJid:(NSString*) jid
{
}

- (void)didDisConnectedWithError:(NSInteger) error
{
}


@end
