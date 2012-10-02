//
//  XMPP.h
//  cocoa-jabber-messenger
//
//  Created by Sangeun Kim on 4/16/11.
//  Copyright 2011 NHN Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaUCConnectionDelegate;
@protocol XMPPVcardUpdateDelegate;
@class RequestWithTGT;
@class XMPPThread;
@class XMPPSession;
@class XMPPSessionManager;
@class XMPPMUCRoom;
@class XMPPMUCRoomManager;
@class Contact;
@interface XMPP : NSObject {
@private
    NSMutableDictionary* myVcard;
    NSMutableArray* connectionDelegates;
    NSMutableArray* vcardUpdateDelegates;
    NSMutableArray* stanzas;
    XMPPThread* xmppThread;
    IBOutlet XMPPSessionManager* sessionManager;
    IBOutlet XMPPMUCRoomManager* mucRoomManager;
    RequestWithTGT* tgtRequest;
}

@property (retain) NSMutableDictionary* myVcard;

- (XMPPSessionManager*) sessionManager;
- (XMPPMUCRoomManager*) mucRoomManager;
- (RequestWithTGT*) tgtRequest;
- (void)registerVcardUpdateDelegate:(id <XMPPVcardUpdateDelegate>) vcardUpdateDelegate;
- (void)registerConnectionDelegate:(id <SinaUCConnectionDelegate>) connectionDelegate;
- (BOOL)login:(NSString*) username withPassword:(NSString*) password;
- (void)onConnect:(NSString*) myJid;
- (void)disconnect;
- (void)onDisconnect:(NSString*) errorString;
- (void)requestVcard:(NSString*) jid;
- (void)updateContact:(Contact*) item;
- (void)updateSelfVcard:(Contact*) item;
- (void)startChat:(NSString*) jid;
- (void)startRoomChat:(NSString*) jid;
- (void)searchContacts:(NSString*) cond;

@end
