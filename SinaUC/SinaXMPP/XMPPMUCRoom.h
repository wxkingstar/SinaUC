//
//  XMPPMUC.h
//  cocoa-jabber-messenger
//
//  Created by 硕实 陈 on 12-1-29.
//  

#import <Foundation/Foundation.h>

#include "mucroomhandler.h"
#include "mucroom.h"
#include "message.h"
#include "mutex.h"

#import "XMPP.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCRoom.h"
#import "SinaUCRoomContact.h"
#import "SinaUCRoomMessage.h"
//#import "GrowlLinker.h"

namespace gloox {
    class MUCRoom;
}

class CMUCRoomEventHandler;

@class GrowlLinker;
@class SinaUCMessageWindowController;
@class RoomMessage;
@class XMPP;
@interface XMPPMUCRoom : NSObject {
@private
    gloox::MUCRoom* room;
    SinaUCMessageWindowController* windowController;
    NSDictionary* roomInfo;
    BOOL chatWindowCreated;
    NSString* gid;
    NSString* jid;
    NSString* name;
    XMPP* xmpp;
}

@property (assign) gloox::MUCRoom* room;
@property (assign) BOOL chatWindowCreated;
@property (assign) XMPP* xmpp;
@property (assign) NSString* jid;
@property (assign) NSString* gid;
@property (assign) NSString* name;

- (void) openChatWindow:(NSDictionary*) roomInfo;
- (BOOL) sendMessage:(SinaUCRoomMessage*) msg;
- (void) handleMessage:(SinaUCRoomMessage*) msg;
- (void) close;
- (void) activateWindow;
@end

@interface XMPPMUCRoomManager : NSObject {
@private
    NSMutableDictionary* rooms;
    CMUCRoomEventHandler* handler;
}

- (void) joinRoom:(XMPPMUCRoom*) room;
- (void) removeRoom:(XMPPMUCRoom*) room;
- (BOOL) activateRoom:(NSString*) roomJid;
- (void) updateRoom:(XMPPMUCRoom*) room;
- (void) updateRoomContacts:(NSMutableArray*) contacts withRoomJid:(NSString*) roomJid;
- (void) handleMUCMessage:(SinaUCRoomMessage*) msg;

@end