//
//  SinaUCAppDelegate.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCAppDelegate.h"

@implementation SinaUCAppDelegate

- (void)awakeFromNib
{
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)onConnect
{
    [self fadeOutAndOrderOut];
    [self fadeInAndMakeKeyAndOrderFront:YES];
}

- (void)fadeInAndMakeKeyAndOrderFront:(BOOL)orderFront {
    [_launchedWindow setAlphaValue:0.0];
    if (orderFront) {
        [_launchedWindow makeKeyAndOrderFront:nil];
    }
    [[_launchedWindow animator] setAlphaValue:1.0];
}

- (void)fadeOutAndOrderOut {
    NSRect windowFrame = [_loginWindow frame];
    windowFrame.origin.y += 100;
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay];
    [[_loginWindow animator] setAlphaValue:0.0];
    [[_loginWindow animator] setFrame:windowFrame display:YES animate:YES];
}

@end
