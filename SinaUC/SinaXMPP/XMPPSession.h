//
//  XMPPSession.h
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/20/11.
//  Checked by Chen shuoshi on 1/30/11
//  实现一对一对话

#import <Foundation/Foundation.h>
#import "SinaUCMessage.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessageViewController.h"

namespace gloox {
    class MessageSession;
    class MessageEventFilter;
    class ChatStateFilter;
}

class CMessageSessionEventHandler;

@interface XMPPSession : NSObject

@property (retain) SinaUCMessageWindowController* chatCtrl;
@property (retain) SinaUCMessageViewController* dialogCtrl;
@property (nonatomic, assign) gloox::MessageSession* session;
@property (retain) NSDictionary* contactInfo;

- (void) openChatWindowInitiative:(BOOL) positive;
- (BOOL) sendMessage:(SinaUCMessage*) item;
- (void) close;
@end