//
//  SinaUCLaunchedViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLaunchedViewController.h"

@interface SinaUCLaunchedViewController ()

@end

@implementation SinaUCLaunchedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [PSMTabBarControl registerTabStyleClass:[SinaUCContactTabStyle class]];
    [tabBar setStyleNamed:@"SinaUCContact"];
    SinaUCContactTabViewItem *contractModel = [[SinaUCContactTabViewItem alloc] init];
    [contractModel setIcon:[NSImage imageNamed:@"group1"]];
    SinaUCContactTabViewItem *groupModel = [[SinaUCContactTabViewItem alloc] init];
    [groupModel setIcon:[NSImage imageNamed:@"group2"]];
    SinaUCContactTabViewItem *historyModel = [[SinaUCContactTabViewItem alloc] init];
    [historyModel setIcon:[NSImage imageNamed:@"group3"]];
    [[tabView tabViewItemAtIndex:0] setIdentifier:contractModel];
    [[tabView tabViewItemAtIndex:1] setIdentifier:groupModel];
    [[tabView tabViewItemAtIndex:2] setIdentifier:historyModel];
    [tabView selectTabViewItemAtIndex:0];

    [tabBar setUseOverflowMenu:NO];
    [tabBar setDisableTabClose:YES];
    [tabBar setCellMaxWidth:1000];
}

- (PSMTabBarControl *)tabBar {
	return tabBar;
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)aTabViewItem
{
    switch ([tabView indexOfTabViewItem:aTabViewItem]) {
        case 0:
            [[aTabViewItem identifier] setValue:[NSImage imageNamed:@"group1_Down"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:1] identifier] setValue:[NSImage imageNamed:@"group2"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:2] identifier] setValue:[NSImage imageNamed:@"group3"] forKeyPath:@"icon"];
            break;
        case 1:
            [[aTabViewItem identifier] setValue:[NSImage imageNamed:@"group2_Down"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:0] identifier] setValue:[NSImage imageNamed:@"group1"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:2] identifier] setValue:[NSImage imageNamed:@"group3"] forKeyPath:@"icon"];
            break;
        case 2:
            [[aTabViewItem identifier] setValue:[NSImage imageNamed:@"group3_Down"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:0] identifier] setValue:[NSImage imageNamed:@"group1"] forKeyPath:@"icon"];
            [[[tabView tabViewItemAtIndex:1] identifier] setValue:[NSImage imageNamed:@"group2"] forKeyPath:@"icon"];
            break;
    }
}

- (void) willConnect
{
}

- (void) didConnectedWithJidForFirstTime:(NSString *)jid
{
    
}

- (void) didDisConnectedWithError:(NSInteger) error
{
}

- (void) didConnectedWithJid:(NSString*) jid
{
}

@end
