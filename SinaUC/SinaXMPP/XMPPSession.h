//
//  XMPPSession.h
//
//  Checked by Chen shuoshi on 1/30/11
//  实现一对一对话

#import <Foundation/Foundation.h>

namespace gloox {
    class MessageSession;
    class MessageEventFilter;
    class ChatStateFilter;
}

class CSessionEventHandler;

@class SinaUCMessage;
@interface XMPPSession : NSObject {
    gloox::ChatStateFilter* chatStateFilter;
    gloox::MessageEventFilter* messageEventFilter;
    CSessionEventHandler* handler;
}

@property (nonatomic, assign) gloox::MessageSession* session;
@property (retain) NSDictionary* contactInfo;

- (void) openChatWindowInitiative:(BOOL) positive;
- (BOOL) sendMessage:(SinaUCMessage*) item;
- (void) handleMessage:(SinaUCMessage*) item;
- (void) close;
@end

@class XMPP;
@class SinaUCMessageWindowController;
@class SinaUCMessageViewController;
@interface XMPPSessionManager : NSObject

@property (retain) XMPP* xmpp;
@property (retain) NSMutableDictionary* sessions;
@property (retain) SinaUCMessageWindowController* chatCtrl;
@property (retain) SinaUCMessageViewController* dialogCtrl;

- (void) openSession:(XMPPSession*) session withWindow:(BOOL) active;
@end