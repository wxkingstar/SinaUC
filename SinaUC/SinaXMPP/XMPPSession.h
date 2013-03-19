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

@class SinaUCMessageWindowController;
@class SinaUCMessageViewController;
@class SinaUCMessage;
@class XMPP;
@interface XMPPSession : NSObject

@property (retain) SinaUCMessageWindowController* chatCtrl;
@property (retain) SinaUCMessageViewController* dialogCtrl;
@property (nonatomic, assign) gloox::MessageSession* session;
@property (assign) XMPP* xmpp;
@property (retain) NSDictionary* contactInfo;

- (void) openChatWindowInitiative:(BOOL) positive;
- (BOOL) sendMessage:(SinaUCMessage*) item;
- (void) handleMessage:(SinaUCMessage*) item;
- (void) close;
@end

@interface XMPPSessionManager : NSObject

@property (retain) NSMutableDictionary* sessions;

- (void) addSession:(XMPPSession*) session;
- (void) removeSession:(XMPPSession*) session;
- (BOOL) activateSession:(NSString*)jid;
@end