//
//  SinaUCAppDelegate.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCAppDelegate.h"
#import "XMPP.h"

@implementation SinaUCAppDelegate
@synthesize launchedWindow;
@synthesize loginWindow;

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) willConnect
{
    
}

- (void) didDisConnectedWithError:(NSInteger) error
{
    //launchedWindow 下线状态
}

- (void) didConnectedWithJid:(NSString*) jid
{
    [self fadeOutAndOrderOut];
    [self fadeInAndMakeKeyAndOrderFront:YES];
}

- (void) fadeInAndMakeKeyAndOrderFront:(BOOL)orderFront {
    [launchedWindow setAlphaValue:0.0];
    if (orderFront) {
        [launchedWindow makeKeyAndOrderFront:nil];
    }
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay+0.5];
    [[launchedWindow animator] setAlphaValue:1.0];
}

- (void) fadeOutAndOrderOut {
    NSRect windowFrame = [loginWindow frame];
    windowFrame.origin.y += 100;
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay+0.5];
    [[loginWindow animator] setAlphaValue:0.0];
    [[loginWindow animator] setFrame:windowFrame display:YES animate:YES];
}

@end
