//
//  XMPPSession.mm
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/20/11.
//  Copyright 2011 NHN Corporation. All rights reserved.
//

#import "XMPPSession.h"

@interface XMPPSession(SessionHandler)
- (void) handleMessage:(SinaUCMessage*) item;
@end

#pragma mark *** CMessageSessionEventHandler Implementation ***
class CMessageSessionEventHandler:public gloox::MessageHandler, public gloox::MessageEventHandler, public gloox::ChatStateHandler
{
public:
    CMessageSessionEventHandler(XMPPSession* m_pSession);
    virtual ~CMessageSessionEventHandler();
    
protected:
    virtual void 	handleMessage (const gloox::Message &msg, gloox::MessageSession *session=0);
    virtual void 	handleMessageEvent (const gloox::JID &from,gloox::MessageEventType event);
    virtual void 	handleChatState (const gloox::JID &from, gloox::ChatStateType state);
    
private:
    XMPPSession* m_pSession;
    
};

CMessageSessionEventHandler::CMessageSessionEventHandler(XMPPSession* pSession)
:m_pSession(pSession)
{
    
}

CMessageSessionEventHandler::~CMessageSessionEventHandler()
{
    NSLog(@"destroy:CMessageSessionEventHandler");
}

void 	CMessageSessionEventHandler::handleMessage (const gloox::Message &msg, 
                                        gloox::MessageSession *session)
{
    /*SinaUCMessage* message = [[SinaUCMessage alloc] init];
    NSString* messageString = [NSString stringWithUTF8String:msg.body().c_str()];
    [message setMessage:messageString];
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

void 	CMessageSessionEventHandler::handleMessageEvent (const gloox::JID &from, gloox::MessageEventType event)
{
}

void 	CMessageSessionEventHandler::handleChatState (const gloox::JID &from, gloox::ChatStateType state)
{
    
}

#pragma mark -
#pragma mark *** XMPPSession Implementation ***
@implementation XMPPSession
@synthesize session;
@synthesize contactInfo;

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

- (void) openChatWindow
{
    SinaUCMessageWindowController* msgWindowController = [[SinaUCMessageWindowController alloc] init];
    [[msgWindowController window] makeKeyAndOrderFront:nil];
    [msgWindowController addContact:contactInfo];
    handler = new CMessageSessionEventHandler(self);
    session->registerMessageHandler(handler);
    //chatStateFilter = new gloox::ChatStateFilter(session);
    //chatStateFilter->registerChatStateHandler(handler);
    //messageEventFilter = new gloox::MessageEventFilter(session);
    //messageEventFilter->registerMessageEventHandler(handler);
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

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        sessions = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addSession:(XMPPSession*) session
{
    [session openChatWindow];
    [sessions addObject:[[session contactInfo] valueForKey:@"jid"]];
}

- (void)removeSession:(XMPPSession*) session
{
    [sessions removeObject:[[session contactInfo] valueForKey:@"jid"]];
}

- (BOOL)activateSession:(XMPPSession*) session
{
    return ([sessions indexOfObject:[[session contactInfo] valueForKey:@"jid"]] != NSNotFound);
}

@end
