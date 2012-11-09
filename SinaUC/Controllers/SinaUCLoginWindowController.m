//
//  SinaUCLoginWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-7.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginWindowController.h"

@interface SinaUCLoginWindowController ()

@end

@implementation SinaUCLoginWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"LoginWindow"];
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (void) willConnect
{

}

- (void) didDisConnectedWithError:(NSInteger) error
{
    
}

- (void) didConnectedWithJid:(NSString*) jid forFistTime:(bool) first
{
    if (first) {
        NSRect windowFrame = [self.window frame];
        windowFrame.origin.y += 100;
        NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
        [[NSAnimationContext currentContext] setDuration:delay+0.5];
        [[self.window animator] setAlphaValue:0.0];
        [[self.window animator] setFrame:windowFrame display:YES animate:YES];
        [self.window orderOut:nil];
    }
}


@end
