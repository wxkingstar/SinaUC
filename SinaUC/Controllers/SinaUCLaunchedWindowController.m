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
    [[self window] setAlphaValue:0.0];
    [[self window] makeKeyAndOrderFront:nil];
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay+1.5];
    [[[self window] animator] setAlphaValue:1.0];
}

- (void)didDisConnectedWithError:(NSInteger) error
{
}


@end