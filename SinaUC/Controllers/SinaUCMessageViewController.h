//
//  SinaUCMessageViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-11.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SinaUCWebKitMessageViewController, SinaUCTextView, XMPPSession, SinaUCMessage, XMPPMUCRoom, SinaUCRoomMessage;
@interface SinaUCMessageViewController : NSViewController
{
    NSMutableArray *messages;
    IBOutlet SinaUCTextView *input;
    IBOutlet SinaUCWebKitMessageViewController	*messageDisplayController;
}

@property (retain) XMPPSession *session;
@property (retain) XMPPMUCRoom *room;

- (IBAction)send:(id) sender;
- (void)addMessage:(SinaUCMessage *)msg;
- (void)addRoomMessage:(SinaUCRoomMessage *) message;

@end