//
//  SinaUCMessageWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "XMPP.h"
#import "XMPPSession.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessageTabStyle.h"
#import "SinaUCMessageTabViewItem.h"
#import "SinaUCMessageViewController.h"

@interface SinaUCMessageWindowController ()

@end

@implementation SinaUCMessageWindowController
@synthesize sessions;
@synthesize currentJid;

static SinaUCMessageWindowController* instance;

- (id)init
{
    if (!instance) {
        instance = [super initWithWindowNibName:@"MessageWindow"];
        instance.sessions = [[NSMutableDictionary alloc] init];
    }
    return instance;
}

- (BOOL)hasSession:(XMPPSession*) session
{
    if ([instance.sessions objectForKey:[[session contactInfo] valueForKey:@"jid"]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addSession:(XMPPSession*) session
{
    [instance.sessions setObject:session forKey:[[session contactInfo] valueForKey:@"jid"]];
    [PSMTabBarControl registerTabStyleClass:[SinaUCMessageTabStyle class]];
    [tabBar setStyleNamed:@"SinaUCMessage"];
    SinaUCMessageTabViewItem *msgModel = [[SinaUCMessageTabViewItem alloc] init];
    NSString* jid = [[session contactInfo] valueForKey:@"jid"];
    [msgModel setIcon:[[NSImage alloc] initWithData:[[[instance.sessions objectForKey:jid] contactInfo] valueForKey:@"image"]]];
    [msgModel setJid:jid];
    NSTabViewItem *dialog = [(NSTabViewItem*)[NSTabViewItem alloc] initWithIdentifier:msgModel];
    [dialog setLabel:[[[instance.sessions objectForKey:jid] contactInfo] valueForKey:@"name"]];
    [tabView addTabViewItem:dialog];
    [tabView selectTabViewItem:dialog];
    SinaUCMessageViewController *dialogController = [[SinaUCMessageViewController alloc] initWithNibName:@"SinaUCMessageViewController" bundle:nil];
    dialogController.view.frame = NSMakeRect(0, 0, [[dialog view] frame].size.width, [[dialog view] frame].size.height);
    [[dialog view] addSubview:[dialogController view]];
    session.chatCtrl = instance;
    session.dialogCtrl = dialogController;
}

- (void)activateSession:(NSString*) jid
{
    for (NSTabViewItem* dialog in [tabView tabViewItems]) {
        if ([[[dialog identifier] valueForKey:@"jid"] isEqual:jid]) {
            [tabView selectTabViewItem:dialog];
            break;
        }
    }
}

- (void)awakeFromNib
{
    NSRect tabBarFrame = [tabBar frame], tabViewFrame = [tabView frame];
	NSRect totalFrame = NSUnionRect(tabBarFrame, tabViewFrame);
    tabBarFrame.size.height = totalFrame.size.height;
    tabBarFrame.size.width = 150;
    tabBarFrame.origin.y = totalFrame.origin.y;
    [tabBar setAutoresizingMask:NSViewHeightSizable];
    tabBarFrame.origin.x = totalFrame.origin.x;
	[tabBar setFrame:tabBarFrame];
	[tabBar setOrientation:PSMTabBarVerticalOrientation];
}

- (PSMTabBarControl*)tabBar
{
	return tabBar;
}

- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *) dialog
{
	NSLog(@"didCloseTabViewItem: %@", [dialog label]);
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem*) dialog
{
    currentJid = [[dialog identifier] valueForKey:@"jid"];
}

- (void)handleMessage:(SinaUCMessage*) msg
{
}

- (void)sendMessage:(SinaUCMessage*) msg
{
}

@end
