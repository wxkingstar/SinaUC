//
//  SinaUCMessageViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-10.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PSMTabBarControl/PSMTabBarControl.h>
#import <PSMTabBarControl/PSMTabStyle.h>
#import "SinaUCMessageTabStyle.h"
#import "SinaUCMessageViewController.h"
#import "XMPP.h"

@interface SinaUCMessageViewController : NSViewController <PSMTabBarControlDelegate>
{
    IBOutlet XMPP               *xmpp;
    IBOutlet NSTabView          *tabView;
    IBOutlet PSMTabBarControl   *tabBar;
}

- (PSMTabBarControl *)tabBar;
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;

@end
