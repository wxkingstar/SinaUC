//
//  SinaUCLaunchedViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCConnectionDelegate.h"
#import "SinaUCLaunchedView.h"
#import "XMPP.h"

@protocol SinaUCConnectionDelegate;
@class XMPP;
@class SinaUCLaunchedView;
@interface SinaUCLaunchedViewController : NSViewController <SinaUCConnectionDelegate>
{
    IBOutlet XMPP *xmpp;
}

- (void) willConnect;
- (void) didDisConnectedWithError:(NSInteger) error;
- (void) didConnectedWithJid:(NSString*) jid;

@end
