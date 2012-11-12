//
//  SinaUCMessageWindowController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PSMTabBarControl/PSMTabStyle.h>
#import <PSMTabBarControl/PSMTabBarControl.h>

#import "SinaUCMessage.h"
#import "SinaUCMessageDelegate.h"

@class XMPPSession;
@interface SinaUCMessageWindowController : NSWindowController <SinaUCMessageDelegate>
{
    IBOutlet XMPP               *xmpp;
    IBOutlet NSTabView			*tabView;
    IBOutlet PSMTabBarControl	*tabBar;
}

@property (retain) NSString* currentJid;
@property (retain) NSMutableDictionary* sessions;

- (void)addContact:(NSDictionary*) contact;
- (PSMTabBarControl*)tabBar;
- (void)createDialog;
- (BOOL)hasSession:(XMPPSession*) session;
- (void)addSession:(XMPPSession*) session;
- (void)activateSession:(NSString*) jid;
- (void)handleMessage:(SinaUCMessage*) msg;
- (void)sendMessage:(SinaUCMessage*) msg;

@end
