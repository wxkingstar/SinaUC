//
//  SinaUCMessageWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "XMPP.h"
#import "XMPPMucRoom.h"
#import "XMPPSession.h"
#import "SinaUCContact.h"
#import "SinaUCRoom.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessageTabStyle.h"
#import "SinaUCMessageTabViewItem.h"
#import "SinaUCMessageViewController.h"


@interface SinaUCMessageWindowController ()

@end

@implementation SinaUCMessageWindowController
@synthesize currentJid;

static SinaUCMessageWindowController* instance;

- (id)init
{
    if (!instance) {
        instance = [super initWithWindowNibName:@"MessageWindow"];
    }
    return instance;
}

- (void)addSession:(XMPPSession *) session
{
    [PSMTabBarControl registerTabStyleClass:[SinaUCMessageTabStyle class]];
    [tabBar setStyleNamed:@"SinaUCMessage"];
    SinaUCMessageTabViewItem *msgModel = [[SinaUCMessageTabViewItem alloc] init];
    NSString* jid = [[session info] jid];
    [msgModel setIcon:[[NSImage alloc] initWithData:[[session info] image]]];
    [msgModel setJid:jid];
    NSTabViewItem *dialog = [(NSTabViewItem*)[NSTabViewItem alloc] initWithIdentifier:msgModel];
    [dialog setLabel:[[session info] name]];
    [tabView addTabViewItem:dialog];
    [tabView selectTabViewItem:dialog];
    SinaUCMessageViewController *dialogController = [[SinaUCMessageViewController alloc] initWithNibName:@"SinaUCMessageViewController" bundle:nil];
    [dialogController setSession:session];
    [session setDialogCtrl:dialogController];
    dialogController.view.frame = NSMakeRect(0, 0, [[dialog view] frame].size.width, [[dialog view] frame].size.height);
    [[dialog view] addSubview:[dialogController view]];
}

- (void)addRoom:(XMPPMUCRoom *) room
{
    [PSMTabBarControl registerTabStyleClass:[SinaUCMessageTabStyle class]];
    [tabBar setStyleNamed:@"SinaUCMessage"];
    SinaUCMessageTabViewItem *msgModel = [[SinaUCMessageTabViewItem alloc] init];
    NSString* jid = [[room info] jid];
    [msgModel setIcon:[[NSImage alloc] initWithData:[[room info] image]]];
    [msgModel setJid:jid];
    NSTabViewItem *dialog = [(NSTabViewItem*)[NSTabViewItem alloc] initWithIdentifier:msgModel];
    [dialog setLabel:[[room info] name]];
    [tabView addTabViewItem:dialog];
    [tabView selectTabViewItem:dialog];
    SinaUCMessageViewController *dialogController = [[SinaUCMessageViewController alloc] initWithNibName:@"SinaUCMessageViewController" bundle:nil];
    [dialogController setRoom:room];
    [room setDialogCtrl:dialogController];
    dialogController.view.frame = NSMakeRect(0, 0, [[dialog view] frame].size.width, [[dialog view] frame].size.height);
    [[dialog view] addSubview:[dialogController view]];
}

- (void)activate:(NSString *) jid
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

- (PSMTabBarControl *)tabBar
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

@end
