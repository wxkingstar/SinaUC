/**
 * @desc
 * 运行过程中一直存在。其中CXmpp的C代表C++，是负责监听各种gloox消息的类。实现了众多主要接口。
 * 要让gloox循环正常运行，最好的方法是单独建立一个进程，由XMPP类代理实现对该进程的访问和控制。
 * XMPP是负责和XMPPSession、XMPPMUCRoom进行交互的类，主要作用是把CXmpp接收到的消息转发给session和room
 * 的manager，再通过各自manager转给各个session和room的实例。session、room和各自manager的实现请看
 * XMPPSession.mm和XMPPMUCRoom.mm
 */

#import "XMPP.h"
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
#import <CommonCrypto/CommonDigest.h>

#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"

#include <sys/time.h>
#include "gloox.h"
#include "client.h"
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

// md5函数
NSString * md5(NSString *str) {
    NSLog(@"%@", str);
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

//CXmpp实现
class CXmpp:public gloox::PresenceHandler, gloox::ConnectionListener, gloox::VCardHandler, gloox::MessageSessionHandler, gloox::RosterListener, gloox::EventHandler, gloox::LogHandler
{
public:
    //仅有一个实例
    static CXmpp& instance();
    
    //和XMPP组合
    void setDelegate (XMPP* pDelegate) {
        m_delegateMutex.lock();
        m_pDelegate = pDelegate;
        vcardRequestStack = [[NSMutableArray alloc] init];
        vcardUpdateStack = [[NSMutableArray alloc] init];
        rooms = [[NSMutableArray alloc] init];
        m_delegateMutex.unlock();
    }
    
    //设置注册用户名、密码
    bool login(NSString* loginId, NSString* password);
    
    //发起连接请求
    void connect();
    
    //发起断开请求
    void disconnect();
    
    //发起获取联系人信息请求
    void requestVcard(NSString* jid);
    
    //返回client实例
    gloox::Client* client() {
        return m_pClient;
    };
    
    //开始个人聊天
    void startChat(gloox::JID& jid);
    
    //关闭个人聊天
    void closeSession(gloox::MessageSession* pSession);
    
    //加入聊天室
    void joinRooms();
    
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
    NSMutableArray* vcardUpdateStack;
    NSMutableArray* rooms;
    gloox::util::Mutex m_delegateMutex;
    
    //xmpp换票
    void exchangeTgt();
    //xmpp心跳
    void heartBeat();
    //发送获取vcard请求
    void sendVcardRequest();
    //更新vcard
    void updateVcard();
    //初始化数据库连接，若是新用户，创建用户本地存储
    void initUserStore();
};

#pragma mark -
#pragma mark *** public functions ***

CXmpp::CXmpp()
:m_pClient(0),
m_pDelegate(0),
m_pRosterManager(0),
m_pVcardManager(0),
m_pPubSubManager(0)
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
    NSInteger l20 = 20;
    NSInteger l30 = 30;
    NSInteger l50 = 50;
    NSInteger l100 = 100;
    if (![fileManager fileExistsAtPath:addressbookDbPath]) {
        [fileManager createFileAtPath:addressbookDbPath contents:nil attributes:nil];
        //创建addressbook数据库
        ZIMSqlCreateTableStatement *createContactGroup = [[ZIMSqlCreateTableStatement alloc] init];
        [createContactGroup table: @"ContactGroup"];
        [createContactGroup column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        //[createContactGroup column: @"name" type: ZIMSqlDataTypeVarChar(l20)];
        NSString *statement = [createContactGroup statement];
        NSLog(@"%@", statement);
        NSNumber *result = [ZIMDbConnection dataSource: @"addressbook" execute: statement];
        
        /*ZIMSqlCreateTableStatement *createContact = [[ZIMSqlCreateTableStatement alloc] init];
        [createContact table: @"Contact"];
        [createContact column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        [createContact column: @"jid" type: ZIMSqlDataTypeVarChar(l50)];
        [createContact column: @"gid" type: ZIMSqlDataTypeBigInt];
        [createContact column: @"name" type: ZIMSqlDataTypeVarChar(l20)];
        [createContact column: @"pinyin" type: ZIMSqlDataTypeVarChar(l30)];
        [createContact column: @"image" type: ZIMSqlDataTypeBlob];
        [createContact column: @"presence" type: ZIMSqlDataTypeSmallInt];
        statement = [createContact statement];
        NSLog(@"%@", statement);
        result = [ZIMDbConnection dataSource: @"addressbook" execute: statement];
        
        ZIMSqlCreateTableStatement *createRoomContactGroup = [[ZIMSqlCreateTableStatement alloc] init];
        [createRoomContactGroup table: @"Room"];
        [createRoomContactGroup column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        [createContact column: @"jid" type: ZIMSqlDataTypeVarChar(l50)];
        [createContact column: @"name" type: ZIMSqlDataTypeVarChar(l20)];
        [createContact column: @"intro" type: ZIMSqlDataTypeVarChar(l100)];
        [createContact column: @"notice" type: ZIMSqlDataTypeVarChar(l50)];
        [createContact column: @"image" type: ZIMSqlDataTypeBlob];
        statement = [createRoomContactGroup statement];
        NSLog(@"%@", statement);
        result = [ZIMDbConnection dataSource: @"addressbook" execute: statement];
        
        ZIMSqlCreateTableStatement *createRoomContact = [[ZIMSqlCreateTableStatement alloc] init];
        [createRoomContact table: @"RoomContact"];
        [createRoomContact column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        [createContact column: @"jid" type: ZIMSqlDataTypeVarChar(l50)];
        [createContact column: @"rid" type: ZIMSqlDataTypeInteger];
        [createContact column: @"name" type: ZIMSqlDataTypeVarChar(l20)];
        [createContact column: @"image" type: ZIMSqlDataTypeBlob];
        [createContact column: @"precense" type: ZIMSqlDataTypeSmallInt];
        statement = [createRoomContact statement];
        NSLog(@"%@", statement);
        result = [ZIMDbConnection dataSource: @"addressbook" execute: statement];*/
    }
    
    if (![fileManager fileExistsAtPath:messageDbPath]) {
        [fileManager createFileAtPath:messageDbPath contents:nil attributes:nil];
        ZIMSqlCreateTableStatement *createMessage = [[ZIMSqlCreateTableStatement alloc] init];
        [createMessage table: @"Message"];
        [createMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        [createMessage column: @"sender" type: ZIMSqlDataTypeVarChar(l50)];
        [createMessage column: @"receier" type: ZIMSqlDataTypeInteger];
        //[createMessage column: @"message" type: ZIMSqlDataTypeVarChar(l20)];
        [createMessage column: @"sendtime" type: ZIMSqlDataTypeBlob];
        NSString *statement = [createMessage statement];
        NSLog(@"%@", statement);
        NSNumber *result = [ZIMDbConnection dataSource: @"message" execute: statement];
        
        ZIMSqlCreateTableStatement *createRoomMessage = [[ZIMSqlCreateTableStatement alloc] init];
        [createRoomMessage table: @"Message"];
        [createRoomMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
        [createRoomMessage column: @"rid" type: ZIMSqlDataTypeInteger];
        //[createRoomMessage column: @"sender" type: ZIMSqlDataTypeVarChar(l50)];
        //[createRoomMessage column: @"receier" type: ZIMSqlDataTypeVarChar(l50)];
        [createRoomMessage column: @"message" type: ZIMSqlDataTypeText];
        [createRoomMessage column: @"sendtime" type: ZIMSqlDataTypeDateTime];
        statement = [createRoomMessage statement];
        NSLog(@"%@", statement);
        result = [ZIMDbConnection dataSource: @"message" execute: statement];
    }
}

void    CXmpp::exchangeTgt()
{
    [[m_pDelegate tgtRequest] exchangeTgt];
}

void    CXmpp::heartBeat()
{
    gloox::JID* jid = new gloox::JID();
    jid->setServer("xmpp.uc.sina.com.cn");
    m_pClient->xmppPing(*jid, this);
}

void    CXmpp::sendVcardRequest()
{
    if ([vcardRequestStack count] > 0 && [vcardRequestStack objectAtIndex:0] != nil) {
        NSString *jidStr = [vcardRequestStack objectAtIndex:0];
        gloox::JID jid([jidStr UTF8String]);
        m_pVcardManager->fetchVCard(jid, this);
        [vcardRequestStack removeObjectAtIndex:0];
    }
}

void    CXmpp::updateVcard()
{
    if ([vcardUpdateStack count] > 0 && [vcardUpdateStack objectAtIndex:0] != nil) {
        //NSString *jidStr = [vcardUpdateStack objectAtIndex:0];
        [vcardUpdateStack removeObjectAtIndex:0];
    }
}

bool    CXmpp::login(NSString* username, NSString* password)
{
    gloox::JID* jid = new gloox::JID();
    jid->setServer("uc.sina.com.cn");
    jid->setResource("darwin");
    if (![[m_pDelegate tgtRequest] tgt]) {
        NSString* firstTgt = md5([NSString stringWithFormat:@"%@%@", username, password]);
        NSLog(@"%@", firstTgt);
        [[m_pDelegate tgtRequest] setTgt:firstTgt];
    }
    NSString* loginId = [NSString stringWithString:[username stringByReplacingOccurrencesOfString:@"@"
                                                                                       withString:@"\\40"]];
    jid->setUsername([loginId UTF8String]);
    m_pClient = new gloox::Client(*jid, [password UTF8String]);
    m_pClient->registerPresenceHandler( this );
    m_pClient->registerConnectionListener( this );
    m_pClient->logInstance().registerLogHandler( gloox::LogLevelDebug, gloox::LogAreaAll, this );
    m_pClient->registerMessageSessionHandler( this );
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
    if (m_pClient->connect(false)) {
        gloox::ConnectionError ce = gloox::ConnNoError;
        int i = 0;
        while (ce == gloox::ConnNoError && ++i) {
            //joinRoom仅执行一次
            if (i == 1) {
                //joinRooms();
                initUserStore();
                NSLog(@"join room");
            }
            //每900次执行tgt换票
            if (i%900 == 0) {
                //exchangeTgt();
            }
            //每10次执行心跳
            if (i%10 == 0) {
                //heartBeat();
            }
            //重置i
            if (i > 1000) {
                i = 1;
            }
            //接收后发送Vcard请求，保证xmpp读写互斥
            //sendVcardRequest();
            //接收后发送消息，保证xmpp读写互斥
            //sendMessage();
            //更新联系人Vcard，由于onConnect和handleVcard、handleRoster顺序不定，initUserStore的工作要在最先完成，所以都向一个队列中写入需要保存的联系人Vcard，再统一写入数据库
            //updateVcard();
            ce = m_pClient->recv(10000);
        }
        printf("ce: %d\n", ce);
    }
    [m_pDelegate disconnect];
}

void    CXmpp::disconnect()
{
    if (m_pClient) {
        m_pClient->disconnect();
        delete m_pClient;
        m_pClient=0;
    }    
}

void 	CXmpp::onConnect ()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
    [m_pDelegate performSelectorOnMainThread:@selector(onConnect:) withObject:myJid waitUntilDone:NO];
}

void 	CXmpp::onDisconnect (gloox::ConnectionError e)
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
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

void    CXmpp::joinRooms()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    /*NSMutableArray* roomInfos = [[NSMutableArray alloc] initWithArray:[[m_pDelegate tgtRequest] getRoomList:uid]];
    for(NSDictionary* roomInfo in roomInfos){
        NSString* roomJidStr = [[NSString alloc] initWithFormat:@"%@@group.uc.sina.com.cn/%@darwin", [roomInfo valueForKey:@"groupid"], uid];
        gloox::JID roomJid([roomJidStr UTF8String]);
        gloox::MUCRoom* mucRoom = new gloox::MUCRoom(m_pClient, roomJid, 0, 0);
        XMPPMUCRoom* room = [[XMPPMUCRoom alloc] init];
        [room setXmpp:m_pDelegate];
        [room setGid:[roomInfo valueForKey:@"groupid"]];
        [room setJid:roomJidStr];
        [room setName:[roomInfo valueForKey:@"groupname"]];
        [room setRoom:mucRoom];
        [room setChatWindowCreated:NO];
        [rooms addObject:room];
        //[room release];
    }
    [m_pDelegate performSelectorOnMainThread:@selector(joinRooms:) withObject:rooms waitUntilDone:NO];*/
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
    /*ContactItem* item = [[ContactItem alloc] init];
     [item setVcard:YES];
     [item setJid:[NSString stringWithUTF8String:jid.bare().c_str()]];
     [item setFullJid:[NSString stringWithUTF8String:jid.full().c_str()]];
     if (vcard->photo().extval == "") {
     NSData* imageData = [NSData dataWithBytes:vcard->photo().binval.c_str() length:vcard->photo().binval.size()];
     [item setPhoto:imageData];
     [imageData release];
     } else {
     NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String:vcard->photo().extval.c_str()]];
     if (url) {
     NSData *imageData = [NSData dataWithContentsOfURL:url];
     [item setPhoto:imageData];
     [imageData release];
     }
     }
     [item setName:[NSString stringWithUTF8String:vcard->nickname().c_str()]];
     if ([[item jid] isEqualToString:[NSString stringWithUTF8String:m_pClient->jid().bare().c_str()]] == NO) {
     [m_pDelegate performSelectorOnMainThread:@selector(updateContact:) withObject:item waitUntilDone:NO];
     } else {
     [m_pDelegate performSelectorOnMainThread:@selector(updateSelfVcard:) withObject:item waitUntilDone:NO];
     }*/
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

void    CXmpp::closeSession(gloox::MessageSession* pSession)
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    m_pClient->disposeMessageSession(pSession);
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

void 	CXmpp::handleRoster (const gloox::Roster &roster)
{
    if (!m_pClient || !m_pDelegate) {
        return; 
    }
    gloox::Roster* pRoster = new gloox::Roster(roster);
    gloox::Roster::iterator it;
    for (it = pRoster->begin(); it != pRoster->end(); it++) {
        gloox::RosterItem* pItem = (*it).second;
        NSMutableArray* groups = [[NSMutableArray alloc]init ];
        gloox::StringList list(pItem->groups());
        gloox::StringList::iterator group;
        for (group = list.begin(); group != list.end(); group++) {
            [groups addObject:[NSString stringWithUTF8String:(*group).c_str()]];            
        }
        NSDictionary *contact = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithUTF8String:(*it).first.c_str()], @"key",
                                 [NSString stringWithUTF8String:pItem->jid().c_str()], @"jid",
                                 [NSString stringWithUTF8String:pItem->name().c_str()], @"name",
                                 groups, @"groups",
                                 nil];
        [vcardUpdateStack addObject:contact];
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
        case gloox::Event::PingPing:   //! 收到PING消息  
            sEvent = "PingPing";  
            break;  
        case gloox::Event::PingPong:   //! 收到返回PONG消息,心跳累计次数减1  
            sEvent = "PingPong";  
            //decreaceHeartBeatCount();  
            break;  
        case gloox::Event::PingError:  //!   
            sEvent = "PingError";  
            break;  
        default:  
            break;  
    }  
    return; 
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
    //NSLog(@"XMPPThread started");
    CXmpp::instance().connect();
    //NSLog(@"XMPPThread ended");
}
@end

#pragma mark -
#pragma mark *** XMPP Implementation ***

@implementation XMPP
@synthesize myVcard;

//SYNTHESIZE_SINGLETON_FOR_CLASS(XMPP)

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        connectionDelegates = [[NSMutableArray alloc] init];
        vcardUpdateDelegates = [[NSMutableArray alloc] init];
        //tgtRequest = [[RequestWithTGT alloc] init];
        myVcard = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"uid", @"", @"jid", @"", @"name", nil, @"image", nil];
        //NSLog(@"XMPP initialized");
    }
    return self;
}

- (XMPPSessionManager*) sessionManager
{
    return sessionManager;
}

- (XMPPMUCRoomManager*) mucRoomManager
{
    return mucRoomManager;
}

- (RequestWithTGT*) tgtRequest
{
    return tgtRequest;
}

- (void) registerVcardUpdateDelegate:(id <XMPPVcardUpdateDelegate>) vcardUpdateDelegate
{
    [vcardUpdateDelegates addObject: vcardUpdateDelegate];
}

- (void) registerConnectionDelegate:(id <SinaUCConnectionDelegate>) connectionDelegate
{
    [connectionDelegates addObject: connectionDelegate];
}

- (BOOL)login:(NSString*)username withPassword:(NSString*)password;
{
    CXmpp::instance().setDelegate(self);
    CXmpp::instance().login(username, password);
    if (xmppThread || [xmppThread isExecuting]) {
        [self disconnect];
        return NO;
    } else {
        xmppThread = [[XMPPThread alloc] init];
        [xmppThread start];
        return YES;
    }
}

- (void) disconnect
{
    CXmpp::instance().disconnect();
    //NSLog(@"XMPP disconnect");
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
    /*gloox::ConnectionError error = (gloox::ConnectionError)[errorString intValue];
     NSEnumerator* e = [connectionDelegates objectEnumerator];
     id < XMPPConnectionDelegate > connectionDelegate;
     while ((connectionDelegate = [e nextObject])) {
     [connectionDelegate onDisconnectWithErrorCode:error];
     }
     [errorString release];
     CXmpp::instance().setDelegate(nil);*/
}


- (void) requestVcard:(NSString*) jid {
    CXmpp::instance().requestVcard(jid);
}

- (void) updateVcard:(Contact*) item
{
    /* if ([[myVcard valueForKey:@"uid"] isEqualTo:@""] == YES) {
     NSArray* jidArr = [[NSArray alloc] initWithArray:[[item jid] componentsSeparatedByString:@"@"]];
     [myVcard setValue:[jidArr objectAtIndex:0] forKey:@"uid"];
     [myVcard setValue:[item jid] forKey:@"jid"];
     [myVcard setValue:[item name] forKey:@"name"];
     [myVcard setValue:[item photo] forKey:@"image"];
     [tgtRequest setMyJid:[item jid]];
     }*/
}


- (void) updateContact:(Contact*) contact
{
    /* NSEnumerator* e = [vcardUpdateDelegates objectEnumerator];
     id <XMPPVcardUpdateDelegate> vcardUpdateDelegate;
     while (vcardUpdateDelegate = [e nextObject]) {
     [vcardUpdateDelegate vcardUpdate: contact];
     }
     if (![contact vcard]) {
     CXmpp::instance().requestVcard([contact fullJid]);
     }*/
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