//
//  SinaUCMessageWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageWindowController.h"

@interface SinaUCMessageWindowController ()

@end

@implementation SinaUCMessageWindowController
@synthesize contacts;

static SinaUCMessageWindowController* instance;

- (id)init
{
    if (!instance) {
        instance = [super initWithWindowNibName:@"MessageWindow"];
        instance.contacts = [[NSMutableDictionary alloc] init];
    }
    return instance;
}

- (void)addContact:(NSDictionary*) _info
{
    [instance.contacts setValue:_info forKey:[_info valueForKey:@"jid"]];
    [instance createDialog:[_info valueForKey:@"jid"]];
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

- (void)createDialog:(NSString*) jid
{
    [PSMTabBarControl registerTabStyleClass:[SinaUCMessageTabStyle class]];
    [tabBar setStyleNamed:@"SinaUCMessage"];
    SinaUCMessageTabViewItem *msgModel = [[SinaUCMessageTabViewItem alloc] init];
    [msgModel setIcon:[[NSImage alloc] initWithData:[[instance.contacts valueForKey:jid] valueForKey:@"image"]]];
	NSTabViewItem *dialog = [(NSTabViewItem*)[NSTabViewItem alloc] initWithIdentifier:msgModel];
	[dialog setLabel:[[instance.contacts valueForKey:jid] valueForKey:@"name"]];
	[tabView addTabViewItem:dialog];
    SinaUCMessageViewController *dialogView = [[SinaUCMessageViewController alloc] initWithNibName:@"SinaUCMessageViewController" bundle:nil];
    dialogView.view.frame = [[dialog view] frame];
    [[dialog view] addSubview:[dialogView view]];
	[tabView selectTabViewItem:dialog]; // this is optional, but expected behavior
}

- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	NSLog(@"didCloseTabViewItem: %@", [tabViewItem label]);
}

@end
