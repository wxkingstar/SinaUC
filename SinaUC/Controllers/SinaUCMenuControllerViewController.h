//
//  SinaUCMenuControllerViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import "SinaUCConnectionDelegate.h"

@interface SinaUCMenuControllerViewController : NSViewController <SinaUCConnectionDelegate>
{
    NSStatusItem* messageCenter;
    NSPopover* popView;
    IBOutlet XMPP* xmpp;
}

@property (assign) BOOL poped;
@property (strong) IBOutlet NSPopover* popView;

- (void)willConnect;
- (void)didConnectedWithJid:(NSString*) jid;
- (void)didDisConnectedWithError:(NSInteger) error;
- (IBAction)showChatWindow:(id) sender;
- (IBAction)showRemindMessages:(id) sender;

@end
