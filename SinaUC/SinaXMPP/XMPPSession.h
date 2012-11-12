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
#include <string.h>

namespace gloox {
    class MessageSession;
    class MessageEventFilter;
    class ChatStateFilter;
}

class CMessageSessionEventHandler;

@interface XMPPSession : NSObject {
@private
    CMessageSessionEventHandler* handler;
}

@property (assign) gloox::MessageSession* session;
@property (retain) NSDictionary* contactInfo;

- (void) openChatWindow;
- (BOOL) sendMessage:(SinaUCMessage*) msg;
- (void) close;

@end

@interface XMPPSessionManager : NSObject {
@private
    NSMutableArray* sessions;
}

- (void) addSession:(XMPPSession*) session;
- (void) removeSession:(XMPPSession*) session;
- (BOOL) activateSession:(XMPPSession*) session;

@end
