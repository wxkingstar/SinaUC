//
//  XMPPSession.mm
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/20/11.
//  Copyright 2011 NHN Corporation. All rights reserved.
//

#import "XMPPSession.h"
#import "XMPP.h"
#import "SinaUCMessage.h"
#import "SinaUCMessageViewController.h"
#import "SinaUCMessageWindowController.h"

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
    NSString* messageString = [NSString stringWithUTF8String:msg.body().c_str()];
    [message setMessage:messageString];
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
@synthesize chatCtrl;
@synthesize dialogCtrl;

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

- (void) openChatWindowInitiative:(BOOL) positive
{
    SinaUCMessageWindowController* msgWindowController = [[SinaUCMessageWindowController alloc] init];
    if (![[NSApplication sharedApplication] isActive]) {
        [[msgWindowController window] setAlphaValue:0];
    }
    [[msgWindowController window] makeKeyAndOrderFront:nil];
    if ([msgWindowController hasSession:self] == NO) {
        CSessionEventHandler* handler = new CSessionEventHandler(self);
        session->registerMessageHandler(handler);
        //chatStateFilter = new gloox::ChatStateFilter(session);
        //chatStateFilter->registerChatStateHandler(handler);
        //messageEventFilter = new gloox::MessageEventFilter(session);
        //messageEventFilter->registerMessageEventHandler(handler);
        //创建窗口的同时，设置session的chatWindow和dialog
        [msgWindowController addSession:self];
    }
    if (positive) {
        [msgWindowController activateSession:[contactInfo valueForKey:@"jid"]];
    }
    
    //[msgWindowController addContact:contactInfo];
}

- (void)handleMessage:(SinaUCMessage*) item
{
    /*[item setType:@"from"];
    [item setJid:jid];
    [item setName:name];
    [windowController onMessageReceived:item];
	if (![NSApp isActive]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"unreadMessage" object:item];
	}*/
}

- (BOOL)sendMessage:(SinaUCMessage*) item
{
    std::string message = [[item message] UTF8String];
    if (session) {
        session->send(message);
        return YES;
    }
    return NO;
}

@end

@implementation XMPPSessionManager
@synthesize sessions;

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        sessions = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

- (void) addSession:(XMPPSession*) session
{
}

- (void) removeSession:(XMPPSession*) session
{
}

- (BOOL) activateSession:(NSString*) jid
{
    return NO;
}

@end
