//
//  XMPPMUCRoom.h
//
//  Created by 硕实 陈 on 12-1-29.
//  

#import <Foundation/Foundation.h>

namespace gloox {
    class MUCRoom;
}

class CMUCRoomEventHandler;

@class SinaUCMessageWindowController;
@class SinaUCMessageViewController;
@class SinaUCRoomMessage;
@class XMPP;
@interface XMPPMUCRoom : NSObject

@property (retain) SinaUCMessageWindowController* chatCtrl;
@property (retain) SinaUCMessageViewController* dialogCtrl;
@property (nonatomic, assign) gloox::MUCRoom* room;
@property (assign) XMPP* xmpp;
@property (retain) NSDictionary* roomInfo;

- (void) openChatWindow:(NSDictionary*) roomInfo;
- (BOOL) sendMessage:(SinaUCRoomMessage*) msg;
- (void) handleMessage:(SinaUCRoomMessage*) msg;
- (void) close;
@end

@interface XMPPMUCRoomManager : NSObject {
@private
    CMUCRoomEventHandler* handler;
}

@property (retain) NSMutableDictionary* rooms;

- (void) joinRoom:(XMPPMUCRoom*) room;
- (void) removeRoom:(XMPPMUCRoom*) room;
- (BOOL) activateRoom:(NSString*) roomJid;
- (void) updateRoom:(XMPPMUCRoom*) room;
- (void) updateRoomContacts:(NSMutableArray*) contacts withRoomJid:(NSString*) roomJid;
- (void) handleMUCMessage:(SinaUCRoomMessage*) msg;

@end