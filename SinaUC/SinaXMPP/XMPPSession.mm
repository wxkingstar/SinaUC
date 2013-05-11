//
//  XMPPSession.mm
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/20/11.
//  Copyright 2011 NHN Corporation. All rights reserved.
//

#import "XMPP.h"
#import "XMPPSession.h"
#import "SinaUCMessage.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessageViewController.h"

#include "message.h"
#include "messagesession.h"
#include "messagehandler.h"
#include "messageeventhandler.h"
#include "chatstatehandler.h"
#include "chatstatefilter.h"
#include "messageeventfilter.h"


#pragma mark *** CSessionEventHandler Implementation ***
class CSessionEventHandler:public gloox::MessageHandler, public gloox::MessageEventHandler, public gloox::ChatStateHandler
{
public:
    CSessionEventHandler(XMPPSession* m_pSession);
    virtual ~CSessionEventHandler();
    
protected:
    virtual void 	handleMessage (const gloox::Message &msg, gloox::MessageSession *session=0);
    virtual void 	handleMessageEvent (const gloox::JID &from,gloox::MessageEventType event);
    virtual void 	handleChatState (const gloox::JID &from, gloox::ChatStateType state);
    
private:
    XMPPSession*    m_pSession;
    
};

CSessionEventHandler::CSessionEventHandler(XMPPSession* pSession)
:m_pSession(pSession)
{
    
}

CSessionEventHandler::~CSessionEventHandler()
{
    NSLog(@"destroy:CSessionEventHandler");
}

void 	CSessionEventHandler::handleMessage (const gloox::Message &msg, 
                                        gloox::MessageSession *session)
{
    SinaUCMessage *message = [[SinaUCMessage alloc] init];
    [message setMessage:[NSString stringWithUTF8String:msg.body().c_str()]];
    [m_pSession performSelectorOnMainThread:@selector(handleMessage:) withObject:message waitUntilDone:NO];
    //information
    /*
    if (!msg.when()) {
        [message setTimeStamp:[NSDate date]];
    } else {
        NSArray* stamp = [[NSString stringWithUTF8String:msg.when()->stamp().c_str()] componentsSeparatedByString:@"T"];
        NSDate *sendTime = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@-%@-%@ %@ -0800", 
                                                       [[stamp objectAtIndex:0] substringWithRange:NSMakeRange(0, 4)], 
                                                       [[stamp objectAtIndex:0] substringWithRange:NSMakeRange(4, 2)], 
                                                       [[stamp objectAtIndex:0] substringWithRange:NSMakeRange(6, 2)], 
                                                       [stamp objectAtIndex:1]]];
        [message setTimeStamp:sendTime];
    }
    [m_pSession performSelectorOnMainThread:@selector(handleMessage:) withObject:message waitUntilDone:NO];*/
                         
}

void 	CSessionEventHandler::handleMessageEvent (const gloox::JID &from, gloox::MessageEventType event)
{
}

void 	CSessionEventHandler::handleChatState (const gloox::JID &from, gloox::ChatStateType state)
{
    
}

#pragma mark -
#pragma mark *** XMPPSession Implementation ***
@implementation XMPPSession
@synthesize session;
@synthesize contactInfo;
@synthesize dialogCtrl;

- (void) setSession:(gloox::MessageSession *)theSession
{
    @synchronized(self) {
        session = theSession;
        handler = new CSessionEventHandler(self);
        session->registerMessageHandler(handler);
        chatStateFilter = new gloox::ChatStateFilter(session);
        chatStateFilter->registerChatStateHandler(handler);
        messageEventFilter = new gloox::MessageEventFilter(session);
        messageEventFilter->registerMessageEventHandler(handler);
    }
}

- (void) close
{
    /*delete handler;
    [windowController close];
    [xmpp close:self];
    if (chatStateFilter) {
        chatStateFilter->removeChatStateHandler();
        delete chatStateFilter;
    }
    
    if (messageEventFilter) {
        messageEventFilter->removeMessageEventHandler();
        delete messageEventFilter;
    }
    
    if (session) {
        session->removeMessageHandler();
    }
    session = nil;*/
}

- (void) addMessage:(SinaUCMessage*) message
{
    //Notification
    NSLog(@"%@", [message message]);
    //[dialogCtrl addMessage:message];
}

- (void) handleMessage:(SinaUCMessage*) message
{
    /*[item setType:@"from"];
    [item setJid:jid];
    [item setName:name];
    [windowController onMessageReceived:item];
	if (![NSApp isActive]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"unreadMessage" object:item];
	}*/
    [self addMessage:message];
}

- (BOOL) sendMessage:(SinaUCMessage*) message
{
    std::string msg = [[message message] UTF8String];
    session->send(msg);
    [self addMessage:message];
    return NO;
}

@end

@implementation XMPPSessionManager
@synthesize xmpp;
@synthesize sessions;
@synthesize chatCtrl;

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        sessions = [[NSMutableDictionary alloc] init];
        chatCtrl = [[SinaUCMessageWindowController alloc] init];
    }
    return self;
}

- (void) openSession:(XMPPSession*) session withWindow:(BOOL) active
{
    if (![[NSApplication sharedApplication] isActive]) {
        //[[chatCtrl window] setAlphaValue:0];
    }
    [[chatCtrl window] makeKeyAndOrderFront:nil];
    NSString *jidStr = [[session contactInfo] valueForKey:@"jid"];
    if (![sessions objectForKey: jidStr]) {
        [sessions setObject:session forKey:jidStr];
        [chatCtrl addSession:session];
    }
    if (active) {
        [chatCtrl activateSession:jidStr];
    }
}

@end
