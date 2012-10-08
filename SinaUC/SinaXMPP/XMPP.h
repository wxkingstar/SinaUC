//
//  XMPP.h
//  SinaUC
//
//  Created by 硕实 陈 on 12-10-1.
//  Copyright (c) 2012年 Sina Corporation. All rights reserved.
//

#include <sys/time.h>
#import <Foundation/Foundation.h>
#import "SinaUCMD5.h"
#import "RequestWithTGT.h"
#import "SinaUCConnectionDelegate.h"
/*#import "SynthesizeSingleton.h"
 #import "XMPPConnectionDelegate.h"
 #import "XMPPVcardUpdateDelegate.h"
 #import "ContactItem.h"
 #import "MUCRoomItem.h"
 #import "XMPPSession.h"
 #import "XMPPMUCRoom.h"
 #import "ChineseToPinyin.h"*/

#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "Contact.h"
#import "ContactGroup.h"
#import "Room.h"
#import "RoomContact.h"

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
    NSMutableArray* stanzas;
    XMPPThread* xmppThread;
    IBOutlet XMPPSessionManager* sessionManager;
    IBOutlet XMPPMUCRoomManager* mucRoomManager;
    RequestWithTGT* tgtRequest;
}

@property (retain) NSMutableDictionary* myVcard;

- (XMPPSessionManager*) sessionManager;
- (XMPPMUCRoomManager*) mucRoomManager;
- (RequestWithTGT*) requestWithTgt;
- (void)registerConnectionDelegate:(id <SinaUCConnectionDelegate>) delegate;
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
