//
//  XMPP.h
//  SinaUC
//
//  Created by 硕实 陈 on 12-10-1.
//  Copyright (c) 2012年 Sina Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "RequestWithTGT.h"
#import "SinaUCConnectionDelegate.h"
#import "SinaUCSVcardUpdateDelegate.h"
#import "SinaUCCVcardUpdateDelegate.h"
#import "SinaUCRoomUpdateDelegate.h"
#import "SinaUCContactRosterUpdateDelegate.h"
#import "SinaUCRoomRosterUpdateDelegate.h"

#include <sys/time.h>
#include "gloox.h"
#include "client.h"
#include "connectiontcpclient.h"
#include "eventhandler.h"
#include "rostermanager.h"
#include "messagehandler.h"
#include "presencehandler.h"
#include "vcardhandler.h"
#include "connectionlistener.h"
#include "rosterlistener.h"
#include "error.h"
#include "vcardmanager.h"
#include "mutex.h"
#include "pubsubmanager.h"
#include "message.h"
#include "messagesessionhandler.h"
#include "messagesession.h"
#include "mucroom.h"
#include "mucroomhandler.h"

namespace gloox {
    class MessageSession;
}

@class XMPPThread, XMPPSession, XMPPSessionManager, XMPPMUCRoomManager, SinaUCContact;
@interface XMPP : NSObject {
@private
    NSString* myJid;
    //NSMutableDictionary* myVcard;
    //tgt请求
    RequestWithTGT *tgtRequest;
    //登录相关回调
    NSMutableArray *connectionDelegates;
    //用户vcard更新回调
    NSMutableArray *sVcardUpdateDelegates;
    //联系人vcard更新回调
    NSMutableArray *cVcardUpdateDelegates;
    //NSMutableArray* stanzas;
    //联系人列表更新回调
    id <SinaUCContactRosterUpdateDelegate> cDelegate;
    //群组列表更新回调
    id <SinaUCRoomRosterUpdateDelegate> rDelegate;
    //xmpp线程
    XMPPThread *xmppThread;
    //会话管理器
    XMPPSessionManager *smngr;
    XMPPMUCRoomManager *rmngr;
}

@property (copy) NSString *myJid;
@property (retain) NSMutableDictionary *myVcard;
@property (retain) id <SinaUCContactRosterUpdateDelegate> cDelegate;
@property (retain) id <SinaUCRoomRosterUpdateDelegate> rDelegate;

- (RequestWithTGT*) requestWithTgt;
- (void)registerConnectionDelegate:(id <SinaUCConnectionDelegate>) delegate;
- (void)registerSVcardUpdateDelegate:(id <SinaUCSVcardUpdateDelegate>) delegate;
- (void)registerCVcardUpdateDelegate:(id <SinaUCCVcardUpdateDelegate>) delegate;
- (BOOL)login:(NSString *) username withPassword:(NSString *) password;
- (void)onConnect:(NSString *) myJid;
- (void)disconnect;
- (void)onDisconnect:(NSString *) errorString;
- (void)updateContactRoster;
- (void)updateRoomRoster;
- (void)updateRosterItem:(NSString *) jid;
- (void)requestVcard:(NSString *) jid;
- (void)updateContact:(NSString *) jid;
- (void)updateSelfVcard;
- (void)iStartChat:(SinaUCContact *) contact;
- (void)uStartChat:(XMPPSession *) session;
- (void)startRoomChat:(NSString *) jid;
- (void)searchContacts:(NSString *) cond;

@end
