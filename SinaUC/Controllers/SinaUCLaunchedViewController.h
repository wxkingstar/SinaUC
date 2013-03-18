//
//  SinaUCLaunchedViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PSMTabBarControl/PSMTabBarControl.h>
#import <PSMTabBarControl/PSMTabStyle.h>
#import "SinaUCConnectionDelegate.h"
#import "SinaUCContactTabStyle.h"
#import "SinaUCLaunchedView.h"
#import "SinaUCContactTabViewItem.h"
#import "XMPP.h"

@interface SinaUCLaunchedViewController : NSViewController <SinaUCConnectionDelegate, PSMTabBarControlDelegate>
{
    IBOutlet XMPP               *xmpp;
    IBOutlet NSTabView			*tabView;
    IBOutlet PSMTabBarControl	*tabBar;
}

- (PSMTabBarControl *)tabBar;
- (void) willConnect;
- (void) didDisConnectedWithError:(NSInteger) error;
- (void) didConnectedWithJid:(NSString*) jid;
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;

@end
