//
//  SinaUCMessageViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-11.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCWebKitMessageViewController.h"
#import "SinaUCMessageViewController.h"
#import "XMPPSession.h"
#import "XMPPMUCRoom.h"
#import "SinaUCRoom.h"
#import "SinaUCContact.h"
#import "SinaUCMessage.h"
#import "SinaUCRoomMessage.h"
#import "SinaUCTextView.h"

@interface SinaUCMessageViewController ()

@end

@implementation SinaUCMessageViewController
@synthesize session;
@synthesize room;

- (id)initWithNibName:(NSString*) nibNameOrNil bundle:(NSBundle*) nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    messages = [[NSMutableArray alloc] init];
    [input setTarget:self];
    [input setAction:@selector(send:)];
}

- (IBAction)send:(id) sender
{
    //notification 告知view和sinaucmessagewindowcontroller发送了消息，这样只需要一份xmpp拷贝即可。
    if (session) {
        SinaUCMessage *msg = [[SinaUCMessage alloc] init];
        [msg setOutgoing:[NSNumber numberWithBool:YES]];
        [msg setMessage:[[input string] copy]];
        [msg setSendtime:[NSDate date]];
        [msg setRecevier:[[session info] jid]];
        [session sendMessage: msg];
    } else {
        SinaUCRoomMessage *msg = [[SinaUCRoomMessage alloc] init];
        [msg setOutgoing:[NSNumber numberWithBool:YES]];
        [msg setMessage:[[input string] copy]];
        [msg setSendtime:[NSDate date]];
        [msg setGid:[[room info] gid]];
        [room sendMessage: msg];
    }
    [input setString:@""];
}

- (void)addMessage:(SinaUCMessage *) message
{
    [messageDisplayController enqueueContentObject:message];
}

- (void)addRoomMessage:(SinaUCRoomMessage *) message
{
    [messageDisplayController enqueueContentObject:message];
}

@end
