//
//  XMPPSession.h
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/20/11.
//  Checked by Chen shuoshi on 1/30/11
//  实现一对一对话

#import <Foundation/Foundation.h>

#include "message.h"
#include "messagesession.h"
#include "messagehandler.h"
#include "messageeventhandler.h"
#include "chatstatehandler.h"
#include "chatstatefilter.h"
#include "messageeventfilter.h"

#import "XMPP.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessage.h"
//#import "GrowlLinker.h"

namespace gloox {
    class MessageSession;
    class MessageEventFilter;
    class ChatStateFilter;
}

class CMessageSessionEventHandler;

@class XMPP;
@class SinaUCMessageWindowController;
@interface XMPPSession : NSObject {
@private
    gloox::MessageSession* session;
    gloox::ChatStateFilter* chatStateFilter;
    gloox::MessageEventFilter* messageEventFilter;
    CMessageSessionEventHandler* handler;
    SinaUCMessageWindowController* windowController;
    NSDictionary* contact;
    BOOL incomingSession;
    NSString* name;
    NSString* jid;
    XMPP* xmpp;
}
@property (nonatomic, assign) gloox::MessageSession* session;
@property (assign) BOOL incomingSession;
@property (assign) XMPP* xmpp;
@property (readonly) NSString* jid;
@property (readonly) NSString* name;

- (void) openChatWindow:(NSDictionary*) contactInfo;
- (BOOL) sendMessage:(SinaUCMessage*) msg;
- (void) close;
- (void) activateWindow;
@end

@interface XMPPSessionManager : NSObject {
@private
    NSMutableArray* sessions;
}
- (void) addSession:(XMPPSession*) session;
- (void) removeSession:(XMPPSession*) session;
- (BOOL) activateSession:(NSString*)jid;
@end
