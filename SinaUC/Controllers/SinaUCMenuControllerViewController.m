//
//  SinaUCMenuControllerViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMenuControllerViewController.h"

@interface SinaUCMenuControllerViewController ()

@end

@implementation SinaUCMenuControllerViewController
@synthesize popView;
@synthesize poped;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (IBAction) showRemindMessages:(id)sender
{
    [[self popView] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

- (void)willConnect
{
}

- (void)didConnectedWithJid:(NSString*) jid
{
    messageCenter = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [messageCenter setImage:[NSImage imageNamed:@"remind_QQlogo_normal"]];
    [messageCenter setTarget:self];
    [messageCenter setAction:@selector(showRemindMessages:)];
}

- (void)didDisConnectedWithError:(NSInteger) error
{
}

@end
