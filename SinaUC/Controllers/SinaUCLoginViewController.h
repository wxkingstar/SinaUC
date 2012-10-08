//
//  SinaUCLoginViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCConnectionDelegate.h"
#import "SinaUCLoginView.h"
#import "XMPP.h"
#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "User.h"

@protocol SinaUCConnectionDelegate;
@class XMPP;
@class SinaUCLoginView;
@interface SinaUCLoginViewController : NSViewController <SinaUCConnectionDelegate, NSTextViewDelegate>
{
    IBOutlet XMPP *xmpp;
}

- (IBAction) showTop:(id)sender;
- (IBAction) hideTop:(id)sender;
- (IBAction) login:(id)sender;

- (void) controlTextDidChange: (NSNotification *) notification;

- (void) willConnect;
- (void) didDisConnectedWithError:(NSInteger) error;
- (void) didConnectedWithJid:(NSString*) jid;

@end
