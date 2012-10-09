//
//  SinaUCLaunchedWindowController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-7.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import "SinaUCConnectionDelegate.h"

@class XMPP;
@interface SinaUCLaunchedWindowController : NSWindowController <SinaUCConnectionDelegate>
{
    IBOutlet XMPP *xmpp;
    IBOutlet NSView *titleBar;
}

- (void)willConnect;
- (void)didConnectedWithJid:(NSString*) jid;
- (void)didDisConnectedWithError:(NSInteger) error;


@end
