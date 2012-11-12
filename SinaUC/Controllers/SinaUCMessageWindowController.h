//
//  SinaUCMessageWindowController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import <PSMTabBarControl/PSMTabStyle.h>
#import <PSMTabBarControl/PSMTabBarControl.h>
#import "SinaUCMessageTabStyle.h"
#import "SinaUCMessageTabViewItem.h"
#import "SinaUCMessageViewController.h"

@interface SinaUCMessageWindowController : NSWindowController
{
    IBOutlet XMPP               *xmpp;
    IBOutlet NSTabView			*tabView;
    IBOutlet PSMTabBarControl	*tabBar;
}

@property (retain, nonatomic) NSMutableDictionary* contacts;

- (void)addContact:(NSDictionary*) contact;
- (PSMTabBarControl*)tabBar;
- (void)createDialog;

@end
