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

@class XMPPThread;
@interface XMPP : NSObject {
@private
    NSString* myJid;
    //NSMutableDictionary* myVcard;
    //tgt请求
    RequestWithTGT* tgtRequest;
    //登录相关回调
    NSMutableArray* connectionDelegates;
    //用户vcard更新回调
    NSMutableArray* sVcardUpdateDelegates;
    //联系人vcard更新回调
    NSMutableArray* cVcardUpdateDelegates;
    //NSMutableArray* stanzas;
    //联系人列表更新回调
    id <SinaUCContactRosterUpdateDelegate> cDelegate;
    //群组列表更新回调
    id <SinaUCRoomRosterUpdateDelegate> rDelegate;
    //xmpp线程
    XMPPThread* xmppThread;
}

@property (copy) NSString* myJid;
@property (retain) NSMutableDictionary* myVcard;
@property (retain) id <SinaUCContactRosterUpdateDelegate> cDelegate;
@property (retain) id <SinaUCRoomRosterUpdateDelegate> rDelegate;

- (RequestWithTGT*) requestWithTgt;
- (void)registerConnectionDelegate:(id <SinaUCConnectionDelegate>) delegate;
- (void)registerSVcardUpdateDelegate:(id <SinaUCSVcardUpdateDelegate>) delegate;
- (void)registerCVcardUpdateDelegate:(id <SinaUCCVcardUpdateDelegate>) delegate;
- (BOOL)login:(NSString*) username withPassword:(NSString*) password;
- (void)onConnect:(NSString*) myJid;
- (void)disconnect;
- (void)onDisconnect:(NSString*) errorString;
- (void)updateContactRoster;
- (void)updateRoomRoster;
- (void)updateRosterItem:(NSString*) jid;
- (void)requestVcard:(NSString*) jid;
- (void)updateContact:(NSString*) jid;
- (void)updateSelfVcard;
- (void)startChat:(NSString*) jid;
- (void)startRoomChat:(NSString*) jid;
- (void)searchContacts:(NSString*) cond;

@end
