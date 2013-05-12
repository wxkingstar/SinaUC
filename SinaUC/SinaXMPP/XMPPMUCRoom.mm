//
//  XMPPMUC.m
//  cocoa-jabber-messenger
//
//  Created by 硕实 陈 on 12-1-29.
//  Copyright (c) 2012年 NHN Corporation. All rights reserved.
//

/**
 * 聊天室实现，一度令我很郁闷，说说思路，就是参考私聊。
 * 开始没想明白将Session换成MUCRoom即可，推荐先看gloox对MUCRoom的文档
 * http://camaya.net/api/gloox-0.9-pre5/classgloox_1_1MUCRoom.html
 * 先从XMPPSession的sendMessage方法入手，它调用的是MessageSession中定义的send。
 * 那么群聊的sendMessage理应调用类似方法，这个方法正是MUCRoom中定义的send。
 * 对应关系就找到了，ROOM对应SESSION。下面的工作就是复制粘贴加替换，没啥难度了。
 */

#import "XMPPMUCRoom.h"
#include "mucroomhandler.h"
#include "mucroom.h"
#include "message.h"
#include "mutex.h"

#import "XMPP.h"
#import "SinaUCMessageWindowController.h"
#import "SinaUCMessageViewController.h"
#import "SinaUCRoom.h"
#import "SinaUCRoomContact.h"
#import "SinaUCRoomMessage.h"

#pragma mark *** CMUCRoomEventHandler Implementation ***
class CMUCRoomEventHandler:public gloox::MUCRoomHandler
{
public:
    CMUCRoomEventHandler(XMPPMUCRoomManager* pRoomManager);
    virtual ~CMUCRoomEventHandler();
    
protected:
    virtual void 	handleMUCMessage (gloox::MUCRoom*, const gloox::Message&, bool priv);
    virtual void    handleMUCParticipantPresence(gloox::MUCRoom* room, const gloox::MUCRoomParticipant participant, const gloox::Presence& presence);
    virtual void    handleMUCSubject(gloox::MUCRoom* room, const std::string& nick, const std::string& subject);
    virtual void    handleMUCError(gloox::MUCRoom* room, gloox::StanzaError error);
    virtual void    handleMUCInfo(gloox::MUCRoom* room, int features, const std::string& name, const gloox::DataForm* infoForm);
    virtual void    handleMUCItems(gloox::MUCRoom* room, const gloox::Disco::ItemList& items );
    virtual void    handleMUCInviteDecline(gloox::MUCRoom* room, const gloox::JID& invitee, const std::string& reason);
    virtual bool    handleMUCRoomCreation(gloox::MUCRoom* room);
    virtual bool    handleMUCRoomDestruction(gloox::MUCRoom* room);
    
private:
    XMPPMUCRoomManager*     m_pRoomManager;
};

CMUCRoomEventHandler::CMUCRoomEventHandler(XMPPMUCRoomManager* pRoomManager)
:m_pRoomManager(pRoomManager)
{
    
}

CMUCRoomEventHandler::~CMUCRoomEventHandler()
{
    NSLog(@"destroy:CMUCRoomEventHandler");
}

void    CMUCRoomEventHandler::handleMUCMessage(gloox::MUCRoom* room, const gloox::Message& msg, bool priv)
{
    NSString* myNick = [NSString stringWithUTF8String:room->nick().c_str()];
    NSString* senderNick = [NSString stringWithUTF8String:msg.from().resource().c_str()];
    if ([senderNick isEqualToString:myNick]) {
        return;
    }
    NSMutableString *jid = [NSMutableString stringWithCapacity:senderNick.length];
    NSScanner *scanner = [NSScanner scannerWithString:senderNick];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [jid appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    NSString *senderJid = [NSString stringWithFormat:@"%@@uc.sina.com.cn", jid];
    SinaUCRoomMessage *message = [[SinaUCRoomMessage alloc] init];
    [message setGid:[NSString stringWithUTF8String:room->name().c_str()]];
    [message setReceier:myNick];
    [message setSender:senderJid];
    [message setOutgoing:[NSNumber numberWithBool:NO]];
    [message setMessage:[NSString stringWithUTF8String:msg.body().c_str()]];
    if (!msg.when()) {
        [message setSendtime:[NSDate date]];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd'T'hh':'mm':'ss"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-8*3600]];
        NSDate *date = [dateFormat dateFromString:[NSString stringWithUTF8String:msg.when()->stamp().c_str()]];
        [message setSendtime:date];
    }
    //[message save];
    [m_pRoomManager performSelectorOnMainThread:@selector(handleRoomMessage:) withObject:message waitUntilDone:NO];
}

void    CMUCRoomEventHandler::handleMUCParticipantPresence(gloox::MUCRoom* room, const gloox::MUCRoomParticipant participant, const gloox::Presence& presence)
{
    /*NSString* myJid = [NSString stringWithUTF8String:room->nick().c_str()];
    NSString* roomJid = [NSString stringWithFormat:@"%@@group.uc.sina.com.cn/%@", [NSString stringWithUTF8String:room->name().c_str()], myJid];
    MUCRoomContactItem* contact = [[MUCRoomContactItem alloc] init];
    [contact setJid:[NSString stringWithUTF8String:participant.jid->username().c_str()]];
    [contact setRoomJid:roomJid];
    [contact setPresence:presence.subtype()];
    [m_pRoomManager performSelectorOnMainThread:@selector(updateContact:) withObject:contact waitUntilDone:NO];*/
}

void    CMUCRoomEventHandler::handleMUCSubject(gloox::MUCRoom* room, const std::string& nick, const std::string& subject)
{
}

void    CMUCRoomEventHandler::handleMUCError(gloox::MUCRoom* room, gloox::StanzaError error)
{
}

void    CMUCRoomEventHandler::handleMUCInfo(gloox::MUCRoom* room, int features, const std::string& name, const gloox::DataForm* infoForm)
{
    NSLog(@"muc info!");
}

void    CMUCRoomEventHandler::handleMUCItems(gloox::MUCRoom* room, const gloox::Disco::ItemList& items)
{
    NSLog(@"muc item!");
}

void    CMUCRoomEventHandler::handleMUCInviteDecline(gloox::MUCRoom* room, const gloox::JID& invitee, const std::string& reason)
{
    NSLog(@"muc invite decline!");
}

bool    CMUCRoomEventHandler::handleMUCRoomCreation(gloox::MUCRoom* room)
{
    return true;
}

bool    CMUCRoomEventHandler::handleMUCRoomDestruction(gloox::MUCRoom* room)
{
    return true;
}


@implementation XMPPMUCRoom
@synthesize room;
@synthesize xmpp;
@synthesize info;
@synthesize dialogCtrl;

- (void) close
{
}

/*- (void) activateWindow
{
    [[windowController window]makeKeyAndOrderFront:self];
}*/

- (void) addMessage:(id) message
{
    //Notification
    [dialogCtrl addRoomMessage:message];
}

- (void) handleRoomMessage:(SinaUCRoomMessage *) message
{
    /*[chatCtrl onMessageReceived:msg];
	if (![NSApp isActive]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadMessage" object:msg];
	}*/
    NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, jid, name FROM RoomContact WHERE jid=? AND rid=?;" withValues:[message sender], [info pk], nil];
    NSArray *contactRes = [ZIMDbConnection dataSource:@"addressbook" query:contactStatement];
    NSMutableDictionary *displayMessage = [NSMutableDictionary dictionaryWithObjectsAndKeys:[message message], @"message", [message sendtime], @"sendtime", [message outgoing], @"outgoing", nil];
    if ([contactRes count] != 0) {
        [displayMessage setValue:[[contactRes objectAtIndex:0] valueForKey:@"name"] forKey:@"displayName"];
    }
    [self addMessage:displayMessage];
}

- (BOOL) sendMessage:(SinaUCRoomMessage *) message
{
    std::string msg = [[message message] UTF8String];
    room->send(msg);
    NSMutableDictionary *displayMessage = [NSMutableDictionary dictionaryWithObjectsAndKeys:[message message], @"message", [message sendtime], @"sendtime", [message outgoing], @"outgoing", @"我", @"displayName", nil];
    [self addMessage:displayMessage];
    return YES;
}

@end

#pragma mark -
#pragma mark *** XMPPMUCRoomManager ***
@implementation XMPPMUCRoomManager
@synthesize rooms, chatCtrl;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        rooms = [[NSMutableDictionary alloc] init];
        handler = new CMUCRoomEventHandler(self);
        chatCtrl = [[SinaUCMessageWindowController alloc] init];
    }
    return self;
}

- (void) joinRoom:(XMPPMUCRoom *) room
{
    if ([rooms objectForKey:[[room info] jid]] == nil) {
        [rooms setObject:room forKey:[[room info] jid]];
        [room room]->registerMUCRoomHandler(handler);
        [room room]->join();
    }
}

- (void) removeRoom:(XMPPMUCRoom *) room
{
    [rooms removeObjectForKey:[[room info] jid]];
}

- (BOOL) activateRoom:(NSString *) roomJid withWindow:(BOOL) active
{
    [[chatCtrl window] makeKeyAndOrderFront:nil];
    if ([rooms objectForKey:roomJid] != nil) {
        [chatCtrl addRoom:[rooms objectForKey:roomJid]];
        if (active) {
            [chatCtrl activate:roomJid];
        }
        return YES;
    }
    return NO;
}

- (void) updateRoom:(XMPPMUCRoom *) room
{
    /*MUCRoomItem* roomItem = [[MUCRoomItem alloc] init];
    [roomItem setJid:[room jid]];
    [roomItem setName:[room name]];
    [roomItem setIntro:[room intro]];
    [roomItem setNotice:[room notice]];
    [mucRoomDataContxt updateRoom:roomItem];
    [roomItem release];*/
}

/*- (void) updateContact:(MUCRoomContactItem*) contact
{
    //[mucRoomDataContxt updateRoomContact:contact withRoomJid:[contact roomJid]];
}

- (void) updateRoomContacts:(NSMutableArray*) contacts withRoomJid:(NSString*) roomJid
{
    //[mucRoomDataContxt updateRoomContacts:contacts withRoomJid:roomJid];
}*/

- (void) handleRoomMessage:(SinaUCRoomMessage*) message
{
    XMPPMUCRoom *room = [rooms objectForKey:[NSString stringWithFormat:@"%@@group.uc.sina.com.cn", [message gid]]];
    if (room) {
        [[rooms objectForKey:[[room info] jid]] handleRoomMessage:message];
    }
}

@end
