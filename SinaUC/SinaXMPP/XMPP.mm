/**
 * @desc
 * 运行过程中一直存在。其中CXmpp的C代表C++，是负责监听各种gloox消息的类。实现了众多主要接口。
 * 要让gloox循环正常运行，最好的方法是单独建立一个进程，由XMPP类代理实现对该进程的访问和控制。
 * XMPP是负责和XMPPSession、XMPPMUCRoom进行交互的类，主要作用是把CXmpp接收到的消息转发给session和room
 * 的manager，再通过各自manager转给各个session和room的实例。session、room和各自manager的实现请看
 * XMPPSession.mm和XMPPMUCRoom.mm
 */

#import "XMPP.h"

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
#include "messagesessionhandler.h"
#include "messagesession.h"
#include "message.h"
#include "mucroom.h"
#include "mucroomhandler.h"

//CXmpp实现
class CXmpp:public gloox::EventHandler, gloox::ConnectionListener , gloox::RosterListener, gloox::PresenceHandler, gloox::VCardHandler, gloox::MessageSessionHandler, gloox::LogHandler
{
public:
    //仅有一个实例
    static CXmpp& instance();
    
    //和XMPP组合
    void setDelegate (XMPP* pDelegate) {
        m_delegateMutex.lock();
        m_pDelegate = pDelegate;
        vcardRequestStack = [[NSMutableArray alloc] init];
        rooms = [[NSMutableArray alloc] init];
        m_delegateMutex.unlock();
    }
    
    //设置注册用户名、密码
    bool login(NSString* loginId, NSString* password);
    
    //发起连接请求
    void connect();
    
    //发起获取联系人信息请求
    void requestVcard(NSString* jid);
    
    //返回client实例
    gloox::Client* client() {
        return m_pClient;
    };
    
    XMPP* delegate() {
        return m_pDelegate;
    }
    
    //开始个人聊天
    void startChat(gloox::JID& jid);
    
    //关闭个人聊天
    void closeSession(gloox::MessageSession* pSession);
    
protected:
    //连接成功回调
    virtual void 	onConnect ();
        
    //断开成功回调
    virtual void 	onDisconnect (gloox::ConnectionError e);
    
    //个人聊天session创建失败回调
    virtual void 	onSessionCreateError (const gloox::Error *error);
    
    //TLS连接创建成功回调
    virtual bool 	onTLSConnect (const gloox::CertInfo &info){
        return true;
    }
    
    //TODO comment
    //virtual void 	onResourceBind (const std::string &resource){};
    
    //TODO comment
    //virtual void 	onResourceBindError (const gloox::Error *error){};
    
    //TODO comment
    //virtual void 	onStreamEvent (gloox::StreamEvent event){};
    
    //返回请求的联系人信息回调
    virtual void 	handleVCard (const gloox::JID &jid, const gloox::VCard *vcard);
    
    //TODO comment
    virtual void 	handleVCardResult (gloox::VCardHandler::VCardContext context, const gloox::JID &jid, gloox::StanzaError se=gloox::StanzaErrorUndefined);
    
    //TODO 添加好友
    virtual void 	handleItemAdded (const gloox::JID &jid){};
    virtual void 	handleItemSubscribed (const gloox::JID &jid){};
    virtual void 	handleItemRemoved (const gloox::JID &jid){};
    virtual void 	handleItemUpdated (const gloox::JID &jid){};
    virtual void 	handleItemUnsubscribed (const gloox::JID &jid, const std::string&){};
    
    //联系人列表回调
    virtual void 	handleRoster (const gloox::Roster &roster);
    
    //TODO comment
    virtual void 	handlePresence (const gloox::Presence &presence);
    
    //个人聊天新消息回调
    virtual void    handleMessageSession (gloox::MessageSession* session);
    
    //联系人在线状态回调
    virtual void 	handleRosterPresence (const gloox::RosterItem &item, 
                                          const std::string &resource, 
                                          gloox::Presence::PresenceType presence, 
                                          const std::string &msg){};
    //个人在线状态回调
    virtual void 	handleSelfPresence (const gloox::RosterItem &item, 
                                        const std::string &resource, 
                                        gloox::Presence::PresenceType presence, 
                                        const std::string &msg){};
    
    //允许加好友请求回调
    virtual bool 	handleSubscriptionRequest (const gloox::JID &jid, const std::string &msg);
    
    //拒绝加好友请求回调
    virtual bool 	handleUnsubscriptionRequest (const gloox::JID &jid, const std::string &msg){return false;};
    
    //
    virtual void 	handleNonrosterPresence (const gloox::Presence &presence){};
    
    //第三方接入
    virtual void    handleGatewayLogin(const std::string& domain){};
    
    //联系人列表请求失败回调
    virtual void 	handleRosterError (const gloox::IQ &iq);
    
    
    virtual void    handleEvent(const gloox::Event& event);
    
    //日志回调
    virtual void    handleLog(gloox::LogLevel level, gloox::LogArea area, const std::string &message);

private:
    CXmpp();
    gloox::Client* m_pClient;
    gloox::PubSub::Manager* m_pPubSubManager;
    gloox::RosterManager* m_pRosterManager;
    gloox::VCardManager* m_pVcardManager;
    XMPP* m_pDelegate;
    NSMutableArray* vcardRequestStack;
    NSMutableArray* rooms;
    gloox::util::Mutex m_delegateMutex;
    bool m_connected;
    int m_heartbeat;
    
    //xmpp换票
    void exchangeTgt();
    //xmpp心跳
    void heartBeat();
    //发送获取vcard请求
    void sendVcardRequest();
    //初始化数据库连接，若是新用户，创建用户本地存储
    void initUserStore();
    //加入聊天室
    void joinRooms();
};

#pragma mark -
#pragma mark *** public functions ***

CXmpp::CXmpp()
:m_pClient(0),
m_pDelegate(0),
m_pRosterManager(0),
m_pVcardManager(0),
m_pPubSubManager(0),
m_connected(false),
m_heartbeat(0)
{
}

CXmpp&  CXmpp::instance()
{
    static CXmpp xmpp;
    return xmpp;
}

void    CXmpp::initUserStore()
{
    NSString* username = [NSString stringWithUTF8String: m_pClient->jid().username().c_str()];
    NSString *userStorePath = [NSString pathWithComponents: [NSArray arrayWithObjects: [(NSArray *)NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [NSString stringWithFormat:@"SinaUC/%@", username], nil]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //判断Support文件夹是否存在myJid文件夹，不存在则创建用户文件夹
    if (![fileManager fileExistsAtPath: userStorePath]) {
        NSError *error;
        [fileManager createDirectoryAtPath:userStorePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    //更新数据库文件位置
    NSString *plist = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ZIMDbPropertyList];
    NSMutableDictionary *config = [NSDictionary dictionaryWithContentsOfFile: plist];
    NSDictionary *detail;
    detail = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@/message.sqlite", username], @"SQLite", nil]
                                         forKeys:[NSArray arrayWithObjects:@"database", @"type", nil]];
    [config setObject:detail forKey:@"message"];
    detail = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@/addressbook.sqlite", username], @"SQLite", nil]
                                         forKeys:[NSArray arrayWithObjects:@"database", @"type", nil]];
    [config setObject:detail forKey:@"addressbook"];
    [config writeToFile:plist atomically:NO];
    //没有数据库文件时自动创建，并创建数据表和外键
    NSString *addressbookDbPath = [NSString pathWithComponents: [NSArray arrayWithObjects: [(NSArray *)NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [NSString stringWithFormat:@"SinaUC/%@/addressbook.sqlite", username], nil]];
    NSString *messageDbPath = [NSString pathWithComponents: [NSArray arrayWithObjects: [(NSArray *)NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex: 0], [NSString stringWithFormat:@"SinaUC/%@/message.sqlite", username], nil]];
    if (![fileManager fileExistsAtPath:addressbookDbPath]) {
        if ([fileManager createFileAtPath:addressbookDbPath contents:nil attributes:nil]) {
            //创建addressbook数据库
            ZIMSqlCreateTableStatement *createContactGroup = [[ZIMSqlCreateTableStatement alloc] init];
            [createContactGroup table: @"ContactGroup"];
            [createContactGroup column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createContactGroup column: @"name" type: ZIMSqlDataTypeVarChar(20)];
            NSString *statement = [createContactGroup statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            statement = [ZIMSqlPreparedStatement preparedStatement: @"INSERT INTO `ContactGroup` (`name`) VALUES (?);" withValues:@"陌生人", nil];
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            
            ZIMSqlCreateTableStatement *createContact = [[ZIMSqlCreateTableStatement alloc] init];
            [createContact table: @"Contact"];
            [createContact column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createContact column: @"jid" type: ZIMSqlDataTypeVarChar(50) unique:YES];
            [createContact column: @"gid" type: ZIMSqlDataTypeBigInt];
            [createContact column: @"name" type: ZIMSqlDataTypeVarChar(20)];
            [createContact column: @"pinyin" type: ZIMSqlDataTypeVarChar(30)];
            [createContact column: @"image" type: ZIMSqlDataTypeBlob];
            [createContact column: @"presence" type: ZIMSqlDataTypeSmallInt];
            statement = [createContact statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            
            ZIMSqlCreateTableStatement *createRoom = [[ZIMSqlCreateTableStatement alloc] init];
            [createRoom table: @"Room"];
            [createRoom column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createRoom column: @"gid" type: ZIMSqlDataTypeInteger];
            [createRoom column: @"jid" type: ZIMSqlDataTypeVarChar(50)];
            [createRoom column: @"name" type: ZIMSqlDataTypeVarChar(20)];
            [createRoom column: @"intro" type: ZIMSqlDataTypeVarChar(100)];
            [createRoom column: @"notice" type: ZIMSqlDataTypeVarChar(50)];
            [createRoom column: @"image" type: ZIMSqlDataTypeBlob];
            statement = [createRoom statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            
            ZIMSqlCreateTableStatement *createRoomContact = [[ZIMSqlCreateTableStatement alloc] init];
            [createRoomContact table: @"RoomContact"];
            [createRoomContact column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createRoomContact column: @"jid" type: ZIMSqlDataTypeVarChar(50)];
            [createRoomContact column: @"rid" type: ZIMSqlDataTypeInteger];
            [createRoomContact column: @"name" type: ZIMSqlDataTypeVarChar(20)];
            [createRoomContact column: @"image" type: ZIMSqlDataTypeBlob];
            [createRoomContact column: @"precense" type: ZIMSqlDataTypeSmallInt];
            statement = [createRoomContact statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
        }
    }
    
    if (![fileManager fileExistsAtPath:messageDbPath]) {
        if ([fileManager createFileAtPath:messageDbPath contents:nil attributes:nil]) {
            ZIMSqlCreateTableStatement *createMessage = [[ZIMSqlCreateTableStatement alloc] init];
            [createMessage table: @"Message"];
            [createMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            //[createMessage column: @"sender" type: ZIMSqlDataTypeVarChar(l50)];
            [createMessage column: @"receier" type: ZIMSqlDataTypeInteger];
            //[createMessage column: @"message" type: ZIMSqlDataTypeVarChar(l20)];
            [createMessage column: @"sendtime" type: ZIMSqlDataTypeBlob];
            NSString *statement = [createMessage statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"message" execute: statement];
            
            ZIMSqlCreateTableStatement *createRoomMessage = [[ZIMSqlCreateTableStatement alloc] init];
            [createRoomMessage table: @"RoomMessage"];
            [createRoomMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createRoomMessage column: @"rid" type: ZIMSqlDataTypeInteger];
            //[createRoomMessage column: @"sender" type: ZIMSqlDataTypeVarChar(l50)];
            //[createRoomMessage column: @"receier" type: ZIMSqlDataTypeVarChar(l50)];
            [createRoomMessage column: @"message" type: ZIMSqlDataTypeText];
            [createRoomMessage column: @"sendtime" type: ZIMSqlDataTypeDateTime];
            statement = [createRoomMessage statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"message" execute: statement];
        }
    }
}

void    CXmpp::joinRooms()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    NSString* uid = [NSString stringWithUTF8String:m_pClient->jid().username().c_str()];
    NSArray* roomsData = [[m_pDelegate requestWithTgt] getRoomList:uid];
    for (NSDictionary* roomData in roomsData) {
        //NSLog(@"%@", roomData);
        Room* room = [[Room alloc] init];
        [room setGid:[roomData valueForKey:@"groupid"]];
        [room setName:[roomData valueForKey:@"groupname"]];
        [room setJid:[NSString stringWithFormat:@"%@@group.uc.sina.com.cn", [roomData valueForKey:@"groupid"]]];
        [room setIntro:[roomData valueForKey:@"intro"]];
        NSString *roomStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk FROM Room WHERE gid = ?;" withValues:[roomData valueForKey:@"groupid"], nil];
        NSArray *roomRes = [ZIMDbConnection dataSource:@"addressbook" query:roomStatement];
        if ([roomRes count] == 0) {
            [room save];
        } else {
            [room setPk:[[roomRes objectAtIndex:0] valueForKey:@"pk"]];
            [room save];
        }
        NSArray* contactsData = [[m_pDelegate requestWithTgt] getRoomContacts:[roomData valueForKey:@"groupid"] withUid:uid];
        for (NSDictionary* contactData in contactsData) {
            //NSLog(@"%@", contactData);
            NSString* contactJid = [NSString stringWithFormat:@"%@@uc.sina.com.cn", [contactData valueForKey:@"uid"]];
            RoomContact* roomContact = [[RoomContact alloc] init];
            [roomContact setRid:[room pk]];
            [roomContact setName:[contactData valueForKey:@"nickname"]];
            [roomContact setJid:contactJid];
            NSString *roomContactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk FROM RoomContact WHERE jid = ?;" withValues:contactJid, nil];
            NSArray *roomContactRes = [ZIMDbConnection dataSource:@"addressbook" query:roomContactStatement];
            if ([roomContactRes count] == 0) {
                [roomContact save];
            } else {
                [roomContact setPk:[[roomContactRes objectAtIndex:0] valueForKey:@"pk"]];
                [roomContact save];
            }
        }
    }
}

void    CXmpp::exchangeTgt()
{
    [[m_pDelegate requestWithTgt] exchangeTgt];
}

void    CXmpp::heartBeat()
{
    m_pClient->xmppPing(m_pClient->jid(), this);
    if (++m_heartbeat > 2) {
        m_pClient->disconnect();
    }
}

void    CXmpp::sendVcardRequest()
{
    if (m_pVcardManager && [vcardRequestStack count] > 0 && [vcardRequestStack objectAtIndex:0] != nil) {
        NSString *jidStr = [vcardRequestStack objectAtIndex:0];
        NSLog(@"%@", jidStr);
        gloox::JID jid([jidStr UTF8String]);
        m_pVcardManager->fetchVCard(jid, this);
        [vcardRequestStack removeObjectAtIndex:0];
    }
}

bool    CXmpp::login(NSString* username, NSString* password)
{
    gloox::JID* jid = new gloox::JID();
    jid->setServer("uc.sina.com.cn");
    jid->setResource("darwin");
    if (![[m_pDelegate requestWithTgt] tgt]) {
        NSString* firstTgt = [SinaUCMD5 md5:[NSString stringWithFormat:@"%@%@", username, password]];
        [[m_pDelegate requestWithTgt] setTgt:firstTgt];
    }
    NSString* loginId = [NSString stringWithString:[username stringByReplacingOccurrencesOfString:@"@"
                                                                                       withString:@"\\40"]];
    jid->setUsername([loginId UTF8String]);
    m_pClient = new gloox::Client(*jid, [password UTF8String]);
    m_pClient->registerPresenceHandler(this);
    m_pClient->registerConnectionListener(this);
    m_pClient->logInstance().registerLogHandler(gloox::LogLevelDebug, gloox::LogAreaAll, this);
    m_pClient->registerMessageSessionHandler(this);
    m_pRosterManager = m_pClient->rosterManager();
    m_pRosterManager->registerRosterListener(this, false);
    m_pRosterManager->fill();
    m_pVcardManager = new gloox::VCardManager(m_pClient);
    m_pPubSubManager = new gloox::PubSub::Manager(m_pClient);
    return true;
}

void    CXmpp::connect()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    gloox::ConnectionError ce = gloox::ConnNoError;
    if (m_pClient->connect(false)) {
        int i = 1;
        do {
            ce = m_pClient->recv(100000);
            //NSLog(@"%s", m_pClient->jid().bare().c_str());
            //每900次执行tgt换票
            if (m_connected) {
                if (i%900 == 0) {
                    exchangeTgt();
                }
                if (i%100 == 0) {
                    heartBeat();
                }
            }
            //重置i
            if (i > 1000) {
                i = 1;
            }
            //接收后发送Vcard请求，保证xmpp读写互斥
            sendVcardRequest();
            //接收后发送消息，保证xmpp读写互斥
            //sendMessage();
        } while (ce == gloox::ConnNoError && ++i);
    }
    NSLog(@"error: %d", ce);
}

void 	CXmpp::onConnect ()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    m_connected = true;
    initUserStore();
    joinRooms();
    NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
    requestVcard(myJid);
    [m_pDelegate performSelectorOnMainThread:@selector(onConnect:) withObject:myJid waitUntilDone:NO];
}

void 	CXmpp::onDisconnect (gloox::ConnectionError e)
{
    m_connected = false;
    m_heartbeat = 0;
    if (m_pVcardManager){
        delete m_pVcardManager;
        m_pVcardManager = 0;
    }
    if (m_pRosterManager) {
        m_pRosterManager->removeRosterListener();
    }
    if (m_pPubSubManager) {
        delete m_pPubSubManager;
        m_pPubSubManager = 0;
    }
    NSString* errorString = [[NSString alloc] initWithFormat:@"%d", e];
    [m_pDelegate performSelectorOnMainThread:@selector(onDisconnect:) withObject:errorString waitUntilDone:NO];
}

void 	CXmpp::handleRoster (const gloox::Roster &roster)
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    gloox::Roster* pRoster = new gloox::Roster(roster);
    gloox::Roster::iterator it;
    for (it = pRoster->begin(); it != pRoster->end(); it++) {
        Contact *contact = [[Contact alloc] init];
        [contact setGid:[NSNumber numberWithInt:1]];
        ContactGroup *contactGroup = [[ContactGroup alloc] init];
        gloox::RosterItem* pItem = (*it).second;
        gloox::StringList list(pItem->groups());
        gloox::StringList::iterator group;
        for (group = list.begin(); group != list.end(); group++) {
            [contactGroup setName:[NSString stringWithUTF8String:(*group).c_str()]];
            NSString *contactGroupStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk FROM ContactGroup WHERE name = ? limit 1;" withValues:[contactGroup name], nil];
            NSArray *contactGroupRes = [ZIMDbConnection dataSource:@"addressbook" query:contactGroupStatement];
            if ([contactGroupRes count] == 0) {
                [contactGroup save];
            } else {
                [contactGroup setPk:[[contactGroupRes objectAtIndex:0] valueForKey:@"pk"]];
                [contactGroup save];
            }
            [contact setGid:[contactGroup pk]];
        }
        //[contact setKey:[NSString stringWithUTF8String:(*it).first.c_str()]];
        [contact setJid:[NSString stringWithUTF8String:pItem->jid().c_str()]];
        [contact setName:[NSString stringWithUTF8String:pItem->name().c_str()]];
        [contact setPresence:[NSNumber numberWithInt:(pItem->online() ? 1 : 0)]];
        NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk FROM Contact WHERE jid = ?;" withValues:[contact jid], nil];
        NSArray *contactRes = [ZIMDbConnection dataSource:@"addressbook" query:contactStatement];
        if ([contactRes count] == 0) {
            [contact save];
        } else {
            [contact setPk:[[contactRes objectAtIndex:0] valueForKey:@"pk"]];
            [contact save];
        }
        requestVcard([contact jid]);
    }
}

void 	CXmpp::handleRosterError (const gloox::IQ &iq)
{
}

void 	CXmpp::handlePresence (const gloox::Presence &presence)
{
    if (!m_pDelegate) {
        return;
    }
    //update contact presence
    /*ContactItem* item = [[ContactItem alloc] init];
     [item setVcard:YES];
     [item setJid:[NSString stringWithUTF8String:presence.from().bare().c_str()]];
     [item setFullJid:[NSString stringWithUTF8String:presence.from().full().c_str()]];
     [item setStatus:[NSString stringWithUTF8String:presence.status().c_str()]];
     [item setPresence:presence.subtype()];
     [m_pDelegate performSelectorOnMainThread:@selector(updateContact:) withObject:item waitUntilDone:NO];*/
}

bool 	CXmpp::handleSubscriptionRequest (const gloox::JID &jid, const std::string &msg)
{
    /*m_delegateMutex.lock();
     if (!m_pRosterManager) {
     m_delegateMutex.unlock();
     return false;
     }
     printf( "subscription: %s\n", jid.bare().c_str() );
     printf( "subscription msg: %s\n", msg.c_str() );
     gloox::StringList groups;
     groups.insert(groups.begin(), "sina");
     m_pRosterManager->subscribe(jid, "", groups, "");
     m_delegateMutex.unlock();*/
    return false;
}

void    CXmpp::handleEvent (const gloox::Event &event) {
    std::string sEvent;
    switch (event.eventType())
    {
        case gloox::Event::PingPing:
            sEvent = "PingPing";
            break;
        case gloox::Event::PingPong:
            sEvent = "PingPong";
            m_heartbeat = 0;
            break;
        case gloox::Event::PingError:
            sEvent = "PingError";
            break;
        default:
            break;
    }
    return;
}

void    CXmpp::requestVcard(NSString* jid)
{
    [vcardRequestStack addObject:jid];
}

void 	CXmpp::handleVCard (const gloox::JID &jid, const gloox::VCard *vcard)
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
    NSString* handleJid = [NSString stringWithUTF8String: jid.bare().c_str()];
    NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String:vcard->photo().extval.c_str()]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    if ([handleJid isNotEqualTo: myJid]) {
        NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `Contact` SET `image`=? WHERE jid=?" withValues:imageData, handleJid, nil];
        [ZIMDbConnection dataSource: @"addressbook" execute: contactStatement];
    } else {
        NSImage *headImg = [[NSImage alloc] initWithData: imageData];
        NSImage *resizeHeadImg = [[NSImage alloc] initWithSize: NSMakeSize(96, 96)];
        NSSize originalSize = [headImg size];
        [resizeHeadImg lockFocus];
        [headImg drawInRect: NSMakeRect(0, 0, [resizeHeadImg size].width, [resizeHeadImg size].height)
                   fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height)
                  operation: NSCompositeSourceOver
                   fraction: 1.0];
        [resizeHeadImg unlockFocus];
        NSData *resizedData = [resizeHeadImg TIFFRepresentation];
        NSString *userStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `User` SET headimg=? WHERE logintime=(SELECT MAX(logintime) FROM `User`)" withValues:resizedData, nil];
        [ZIMDbConnection dataSource: @"user" execute: userStatement];
    }
    
}

void 	CXmpp::handleVCardResult (gloox::VCardHandler::VCardContext context, const gloox::JID &jid, gloox::StanzaError se)
{
    NSLog(@"vcard result");
}

void    CXmpp::startChat(gloox::JID& jid)
{
    if (!m_pClient || !m_pDelegate) {
        return; 
    }
    /*gloox::MessageSession* pSession = new gloox::MessageSession( m_pClient, jid );
    XMPPSession* session = [[XMPPSession alloc] init];
    [session setSession:pSession];
    [session setXmpp:m_pDelegate];
    [[m_pDelegate sessionManager] addSession:session];*/
}

void 	CXmpp::handleMessageSession(gloox::MessageSession *session)
{
    if (!m_pDelegate) {
        return;
    }
    /*XMPPSession* s = [[XMPPSession alloc] init];
     [s setSession:session];
     [s setIncomingSession:YES];
     [s setXmpp:m_pDelegate];
     [[m_pDelegate sessionManager] performSelectorOnMainThread:@selector(addSession:) withObject:s waitUntilDone:YES];*/
}

void 	CXmpp::onSessionCreateError (const gloox::Error *error)
{
    if (!m_pClient || !m_pDelegate) {
        return; 
    }
    std::string errorString;
    if (error) {
        errorString = error->text();
    } else {
        errorString = "";
    }
    NSString* errorMessage = [[NSString init ]initWithCString:errorString.c_str() encoding:NSASCIIStringEncoding];
    [m_pDelegate performSelectorOnMainThread:@selector(onDisconnect:) withObject:errorMessage waitUntilDone:NO];    
}

void    CXmpp::closeSession(gloox::MessageSession* pSession)
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    m_pClient->disposeMessageSession(pSession);
}

void    CXmpp::handleLog(gloox::LogLevel level, gloox::LogArea area, const std::string &message){
    //printf("log: level: %d, area: %d, %s\n", level, area, message.c_str());
}

#pragma mark -
#pragma mark *** XMPPThread ***
@interface XMPPThread : NSThread {
@private
}
@end

@implementation XMPPThread

- (void)main
{
    NSLog(@"XMPPThread started");
    CXmpp::instance().connect();
    while (![[NSThread currentThread] isCancelled]) {
        sleep(1);
    }
    NSLog(@"XMPPThread ended");
    [NSThread exit];
}
@end

#pragma mark -
#pragma mark *** XMPP Implementation ***

@implementation XMPP
@synthesize myVcard;

static XMPP *instance;
- (id) init
{
    @synchronized(self) {
        if (!instance) {
            instance = [super init];
            // Initialization code here.
            connectionDelegates = [[NSMutableArray alloc] init];
            tgtRequest = [[RequestWithTGT alloc] init];
            myVcard = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"uid", @"", @"jid", @"", @"name", nil, @"image", nil];
        }
        return instance;
    }
}

- (XMPPSessionManager*) sessionManager
{
    return sessionManager;
}

- (XMPPMUCRoomManager*) mucRoomManager
{
    return mucRoomManager;
}

- (RequestWithTGT*) requestWithTgt
{
    return tgtRequest;
}

- (void) registerConnectionDelegate:(id <SinaUCConnectionDelegate>) delegate
{
    [connectionDelegates addObject: delegate];
}

- (BOOL) login:(NSString*)username withPassword:(NSString*)password;
{
    NSEnumerator* e = [connectionDelegates objectEnumerator];
    id < SinaUCConnectionDelegate > connectionDelegate;
    while (connectionDelegate = [e nextObject]) {
        [connectionDelegate willConnect];
    }
    CXmpp::instance().setDelegate(self);
    CXmpp::instance().login(username, password);
    if ([xmppThread isExecuting]) {
        return NO;
    } else {
        xmppThread = nil;
        xmppThread = [[XMPPThread alloc] init];
        [xmppThread start];
        return YES;
    }
}

- (void) onConnect:(NSString*) myJid
{
    NSEnumerator* e = [connectionDelegates objectEnumerator];
    id < SinaUCConnectionDelegate > connectionDelegate;
    while (connectionDelegate = [e nextObject]) {
        [connectionDelegate didConnectedWithJid:myJid];
    }
}

- (void) onDisconnect:(NSString*) errorString
{
    [xmppThread cancel];
    NSEnumerator* e = [connectionDelegates objectEnumerator];
    id < SinaUCConnectionDelegate > connectionDelegate;
    while ((connectionDelegate = [e nextObject])) {
        [connectionDelegate didDisConnectedWithError:[errorString intValue]];
    }
    CXmpp::instance().setDelegate(nil);
}

- (void) requestVcard:(NSString*) jid {
    CXmpp::instance().requestVcard(jid);
}

- (void) startChat:(NSString*) jid
{
    /*if (!jid) {
        return;
    }
    if ([sessionManager activateSession:jid]) {
        return;
    }
    gloox::JID glooxJid([jid UTF8String]);
    CXmpp::instance().startChat(glooxJid);*/
}

- (void) startRoomChat:(NSString*) jid
{
    /*if ([mucRoomManager activateRoom:jid]) {
        return;
    }*/
}

- (void) joinRooms:(NSMutableArray*) rooms
{
    if (!mucRoomManager) {
        return;
    }
    /*for (XMPPMUCRoom* room in rooms) {
     [mucRoomManager updateRoom:room];
     [mucRoomManager joinRoom:room];
     }*/
}

- (void) close:(XMPPSession*) session
{
    /*CXmpp::instance().closeSession([session session]);
    [sessionManager performSelector:@selector(removeSession:) withObject:session afterDelay:0];*/
}

@end
