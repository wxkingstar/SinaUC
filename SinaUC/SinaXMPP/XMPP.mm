/**
 * @desc
 * 运行过程中一直存在。其中CXmpp的C代表C++，是负责监听各种gloox消息的类。实现了众多主要接口。
 * 要让gloox循环正常运行，最好的方法是单独建立一个XMPP线程，由XMPP类代理实现对该进程的访问和控制。
 * XMPP是负责和XMPPSession、XMPPMUCRoom进行交互的类，主要作用是把CXmpp接收到的消息转发给session和room
 * 的manager，再通过各自manager转给各个session和room的实例。session、room和各自manager的实现请看
 * XMPPSession.mm和XMPPMUCRoom.mm
 *
 * 对于数据更新，在XMPP线程中做完，performSelectorOnMainThread仅负责对UI类进行更新操作（由Delegate调用各个控制器，再通过控制器更新UI
 */
#import "XMPP.h"
#import "XMPPSession.h"
#import "XMPPMUCRoom.h"
#import "SinaUCContact.h"
#import "SinaUCContactGroup.h"
#import "SinaUCRoom.h"
#import "SinaUCRoomContact.h"
#import "SinaUCMD5.h"


//CXmpp实现
class CXmpp:public gloox::EventHandler, gloox::ConnectionListener , gloox::RosterListener, gloox::PresenceHandler, gloox::VCardHandler, gloox::MessageSessionHandler//, gloox::LogHandler
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
    
    gloox::MessageSession* createSession(NSString* jidStr);
    
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
    virtual void    handleMessageSession (gloox::MessageSession* pSession);
    
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
    //virtual void    handleLog(gloox::LogLevel level, gloox::LogArea area, const std::string &message);
    
private:
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

private:
    CXmpp();
    gloox::PrivateXML* m_pXML;
    gloox::Client* m_pClient;
    gloox::PubSub::Manager* m_pPubSubManager;
    gloox::RosterManager* m_pRosterManager;
    gloox::VCardManager* m_pVcardManager;
    XMPP* m_pDelegate;
    gloox::util::Mutex m_delegateMutex;
    bool m_connected;
    int m_logintimes;
    int m_heartbeat;
    NSMutableArray* vcardRequestStack;
    NSMutableArray* rooms;
    NSString* m_username;
    NSString* m_password;
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
m_logintimes(0),
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
    if ([username isEqualToString:@""]) {
        //disconnect
        return;
    }
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
            ZIMSqlCreateIndexStatement *createContactGroupIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createContactGroupIndex index:@"name" on:@"ContactGroup"];
            [createContactGroupIndex unique:YES];
            [createContactGroupIndex column:@"name"];
            statement = [createContactGroupIndex statement];
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
            [createContact column: @"avatar" type: ZIMSqlDataTypeText];
            [createContact column: @"image" type: ZIMSqlDataTypeBlob];
            [createContact column: @"mood" type: ZIMSqlDataTypeVarChar(30)];
            [createContact column: @"presence" type: ZIMSqlDataTypeSmallInt];
            statement = [createContact statement];
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            ZIMSqlCreateIndexStatement *createContactIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createContactIndex index:@"contact_jid" on:@"Contact"];
            [createContactIndex column:@"jid"];
            statement = [createContactIndex statement];
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            [createContactIndex index:@"contact_gid" on:@"Contact"];
            [createContactIndex column:@"gid"];
            statement = [createContactIndex statement];
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
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            ZIMSqlCreateIndexStatement *createRoomIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createRoomIndex index:@"room_jid" on:@"Room"];
            [createRoomIndex column:@"jid"];
            statement = [createRoomIndex statement];
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
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
            ZIMSqlCreateIndexStatement *createRoomContactIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createRoomContactIndex index:@"room_contact_rid_jid" on:@"RoomContact"];
            [createRoomContactIndex columns:[NSSet setWithObjects:@"rid", @"jid", nil]];
            statement = [createRoomContactIndex statement];
            [ZIMDbConnection dataSource: @"addressbook" execute: statement];
        }
    }
    
    if (![fileManager fileExistsAtPath:messageDbPath]) {
        if ([fileManager createFileAtPath:messageDbPath contents:nil attributes:nil]) {
            ZIMSqlCreateTableStatement *createMessage = [[ZIMSqlCreateTableStatement alloc] init];
            [createMessage table: @"Message"];
            [createMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createMessage column: @"sender" type: ZIMSqlDataTypeVarChar(50)];
            [createMessage column: @"recevier" type: ZIMSqlDataTypeInteger];
            [createMessage column: @"outgoing" type: ZIMSqlDataTypeBoolean];
            [createMessage column: @"message" type: ZIMSqlDataTypeText];
            [createMessage column: @"sendtime" type: ZIMSqlDataTypeDateTime];
            NSString *statement = [createMessage statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
            ZIMSqlCreateIndexStatement *createMessageIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createMessageIndex index:@"msg_sender" on:@"Message"];
            [createMessageIndex column:@"sender"];
            statement = [createMessageIndex statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
            [createMessageIndex index:@"msg_recevier" on:@"Message"];
            [createMessageIndex column:@"recevier"];
            statement = [createMessageIndex statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
            
            ZIMSqlCreateTableStatement *createRoomMessage = [[ZIMSqlCreateTableStatement alloc] init];
            [createRoomMessage table: @"RoomMessage"];
            [createRoomMessage column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createRoomMessage column: @"rid" type: ZIMSqlDataTypeInteger];
            [createRoomMessage column: @"sender" type: ZIMSqlDataTypeVarChar(50)];
            [createRoomMessage column: @"recevier" type: ZIMSqlDataTypeVarChar(50)];
            [createRoomMessage column: @"outgoing" type: ZIMSqlDataTypeBoolean];
            [createRoomMessage column: @"message" type: ZIMSqlDataTypeText];
            [createRoomMessage column: @"sendtime" type: ZIMSqlDataTypeDateTime];
            statement = [createRoomMessage statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
            ZIMSqlCreateIndexStatement *createRoomMessageIndex = [[ZIMSqlCreateIndexStatement alloc] init];
            [createRoomMessageIndex index:@"room_msg_rid_sender" on:@"RoomMessage"];
            [createRoomMessageIndex columns:[NSSet setWithObjects:@"rid", @"sender", nil]];
            statement = [createRoomMessageIndex statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
            [createRoomMessageIndex index:@"room_msg_rid_recevier" on:@"RoomMessage"];
            [createRoomMessageIndex columns:[NSSet setWithObjects:@"rid", @"recevier", nil]];
            statement = [createRoomMessageIndex statement];
            [ZIMDbConnection dataSource: @"message" execute: statement];
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
        gloox::JID jid([jidStr UTF8String]);
        m_pVcardManager->fetchVCard(jid, this);
        [vcardRequestStack removeObjectAtIndex:0];
    }
}

bool    CXmpp::login(NSString* username, NSString* password)
{
    if (!m_username) m_username = username;
    if (!m_password) m_password = password;
    gloox::JID* jid = new gloox::JID();
    jid->setServer("uc.sina.com.cn");
    jid->setResource("darwin");
    if (![[m_pDelegate requestWithTgt] tgt]) {
        NSString* firstTgt = [SinaUCMD5 md5:[NSString stringWithFormat:@"%@%@", m_username, m_password]];
        [[m_pDelegate requestWithTgt] setTgt:firstTgt];
    }
    NSString* loginId = [NSString stringWithString:[m_username stringByReplacingOccurrencesOfString:@"@"
                                                                                       withString:@"\\40"]];
    jid->setUsername([loginId UTF8String]);
    m_pClient = new gloox::Client(*jid, [m_password UTF8String]);
    //m_pClient->logInstance().registerLogHandler(gloox::LogLevelDebug, gloox::LogAreaAll, this);
    m_pClient->registerConnectionListener(this);
    m_pClient->registerPresenceHandler(this);
    m_pClient->registerMessageSessionHandler(this);
    m_pRosterManager = m_pClient->rosterManager();//new gloox::RosterManager(m_pClient);//;
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
    while (true) {
        if (m_pClient->connect(false)) {
            int i = 0;
            ++m_logintimes;
            do {
                ce = m_pClient->recv(10000);
                //每90000次执行tgt换票
                if (m_connected) {
                    if (i%90000 == 0) {
                        exchangeTgt();
                    }
                    if (i%100 == 0) {
                        heartBeat();
                    }
                    //接收后发送Vcard请求，保证xmpp读写互斥
                    sendVcardRequest();
                    //接收后发送消息，保证xmpp读写互斥
                    //sendMessage();
                }
                //重置i
                if (i > 1000) {
                    i = 1;
                }
            } while (ce == gloox::ConnNoError && ++i);
            NSLog(@"error: %d", ce);
            login(m_username, m_password);
        }
        sleep(2);
        NSLog(@"try to reconnect");
    }
}

void 	CXmpp::onConnect()
{
    if (!m_pClient || !m_pDelegate) {
        return;
    }
    m_connected = true;
    initUserStore();
    NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
    requestVcard(myJid);
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:myJid, @"jid", [NSNumber numberWithInt:m_logintimes], @"times", nil];
    joinRooms();
    [m_pDelegate performSelectorOnMainThread:@selector(onConnect:) withObject:dict waitUntilDone:NO];
}

void 	CXmpp::onDisconnect(gloox::ConnectionError e)
{
    m_delegateMutex.lock();
    m_connected = false;
    m_heartbeat = 0;
    if (m_pVcardManager){
        delete m_pVcardManager;
        m_pVcardManager = 0;
    }
    if (m_pRosterManager) {
        m_pRosterManager->removeRosterListener();
        delete m_pRosterManager;
        m_pRosterManager = 0;
    }
    if (m_pPubSubManager) {
        delete m_pPubSubManager;
        m_pPubSubManager = 0;
    }
    NSString* errorString = [[NSString alloc] initWithFormat:@"%d", e];
    [m_pDelegate performSelectorOnMainThread:@selector(onDisconnect:) withObject:errorString waitUntilDone:YES];
    m_delegateMutex.unlock();
}

void 	CXmpp::handleRoster(const gloox::Roster &roster)
{
    m_delegateMutex.lock();
    if (!m_pDelegate) {
        m_delegateMutex.unlock();
        return;
    }
    gloox::Roster* pRoster = new gloox::Roster(roster);
    gloox::Roster::iterator it;
    for (it = pRoster->begin(); it != pRoster->end(); it++) {
        SinaUCContact *contact = [[SinaUCContact alloc] init];
        [contact setGid:[NSNumber numberWithInt:1]];
        SinaUCContactGroup *contactGroup = [[SinaUCContactGroup alloc] init];
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
                try {
                    [contactGroup save];
                } catch (NSException* e) {
                    
                }
            }
            [contact setGid:[contactGroup pk]];
            break;
        }
        //[contact setKey:[NSString stringWithUTF8String:(*it).first.c_str()]];
        NSString* jid = [NSString stringWithUTF8String:pItem->jid().c_str()];
        [contact setJid:jid];
        [contact setName:[NSString stringWithUTF8String:pItem->name().c_str()]];
        NSString* avatar = [NSString stringWithUTF8String:pItem->data()->tag()->findAttribute("avatar").c_str()];
        [contact setAvatar:avatar];
        NSString* mood = [NSString stringWithUTF8String:pItem->data()->tag()->findAttribute("mood").c_str()];
        if ([mood length]>0) {
            [contact setMood:mood];
        } else {
            [contact setMood:@""];
        }
        [contact setPresence:[NSNumber numberWithInt:5]];
        NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, jid, avatar FROM Contact WHERE jid = ?;" withValues:[contact jid], nil];
        NSArray *contactRes = [ZIMDbConnection dataSource:@"addressbook" query:contactStatement];
        if ([contactRes count] == 0) {
            requestVcard(jid);
            [contact save];
        } else {
            if ([[[contactRes objectAtIndex:0] valueForKey:@"image"] length] == 0 || [avatar isNotEqualTo:[[contactRes objectAtIndex:0] valueForKey:@"avatar"]]) {
                requestVcard([[contactRes objectAtIndex:0] valueForKey:@"jid"]);
            }
            NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `Contact` SET `name`=?, `mood`=?, `presence`=? WHERE pk=?" withValues:[contact name], [contact mood], [contact presence], [[contactRes objectAtIndex:0] valueForKey:@"pk"], nil];
            [ZIMDbConnection dataSource: @"addressbook" execute: contactStatement];
        }
    }
    [m_pDelegate performSelectorOnMainThread:@selector(updateContactRoster) withObject:nil waitUntilDone:YES];
    m_delegateMutex.unlock();
}

void 	CXmpp::handleRosterError(const gloox::IQ &iq)
{
}

void    CXmpp::joinRooms()
{
    if (!m_pDelegate) {
        return;
    }
    NSString* uid = [NSString stringWithUTF8String:m_pClient->jid().username().c_str()];
    NSArray* roomsData = [[m_pDelegate requestWithTgt] getRoomList:uid];
    for (NSDictionary* roomData in roomsData) {
        SinaUCRoom* info = [[SinaUCRoom alloc] init];
        [info setGid:[roomData valueForKey:@"groupid"]];
        [info setName:[roomData valueForKey:@"groupname"]];
        [info setJid:[NSString stringWithFormat:@"%@@group.uc.sina.com.cn", [roomData valueForKey:@"groupid"]]];
        [info setIntro:[roomData valueForKey:@"intro"]];
        NSURL* url = [NSURL URLWithString:[roomData valueForKey:@"avatar"]];
        NSError* error = nil;
        try {
            [info setImage:[NSData dataWithContentsOfURL:url options:0 error:&error]];
        } catch (NSException* e) {
            NSLog(@"%@", e);
        }
        NSString *roomStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk FROM Room WHERE gid = ?;" withValues:[roomData valueForKey:@"groupid"], nil];
        NSArray *roomRes = [ZIMDbConnection dataSource:@"addressbook" query:roomStatement];
        if ([roomRes count] == 0) {
            [info save];
        } else {
            [info setPk:[[roomRes objectAtIndex:0] valueForKey:@"pk"]];
            [info save];
        }
        NSArray* contactsData = [[m_pDelegate requestWithTgt] getRoomContacts:[roomData valueForKey:@"groupid"] withUid:uid];
        for (NSDictionary* contactData in contactsData) {
            NSString* contactJid = [NSString stringWithFormat:@"%@@uc.sina.com.cn", [contactData valueForKey:@"uid"]];
            SinaUCRoomContact* roomContact = [[SinaUCRoomContact alloc] init];
            [roomContact setRid:[info pk]];
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
        [m_pDelegate performSelectorOnMainThread:@selector(updateRoomRoster) withObject:nil waitUntilDone:NO];
        gloox::JID roomJid([[NSString stringWithFormat:@"%@/%@darwin", [info jid], uid] UTF8String]);
        gloox::MUCRoom *xmppRoom = new gloox::MUCRoom(m_pClient, roomJid, 0, 0);
        XMPPMUCRoom *room = [[XMPPMUCRoom alloc] init];
        [room setInfo:info];
        [room setRoom:xmppRoom];
        [m_pDelegate performSelectorOnMainThread:@selector(joinRoom:) withObject:room waitUntilDone:NO];
    }
}

void 	CXmpp::handlePresence(const gloox::Presence &presence)
{
    while (!m_delegateMutex.trylock()) {
        if (!m_pDelegate) {
            break;
        }
        NSString* jid = [NSString stringWithUTF8String:presence.from().bare().c_str()];
        NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
        if ([jid isEqualToString: myJid]) {
            break;
        }
        NSString* contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, avatar, image FROM Contact WHERE jid = ?;" withValues:jid, nil];
        NSArray* contactRes = [ZIMDbConnection dataSource:@"addressbook" query:contactStatement];
        if ([contactRes count] > 0) {
            NSString* contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `Contact` SET `presence`=? WHERE jid=?" withValues:[NSNumber numberWithInt:presence.subtype()], jid, nil];
            do {
                try {
                    [ZIMDbConnection dataSource: @"addressbook" execute: contactStatement];
                    break;
                } catch (NSException* e) {
                    sleep(1);
                }
            } while (1);
        }
        [m_pDelegate performSelectorOnMainThread:@selector(updatePresence:) withObject:jid waitUntilDone:YES];
        m_delegateMutex.unlock();
    }
}

bool 	CXmpp::handleSubscriptionRequest(const gloox::JID &jid, const std::string &msg)
{
    printf( "subscription: %s\n", jid.bare().c_str() );
    NSError *err;
    //NSXMLDocument *subscription = [[NSXMLDocument alloc] initWithXMLString:[NSString stringWithUTF8String:msg.c_str()] options:0 error:&err];
    NSString *root = [NSString stringWithFormat:@"<root>%@</root>", [NSString stringWithUTF8String:msg.c_str()]];
    NSXMLDocument *subscription = [[NSXMLDocument alloc] initWithXMLString:root options:0 error:&err];
    NSArray *nick = [subscription nodesForXPath:@"/root/nick" error:&err];
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

void    CXmpp::handleEvent(const gloox::Event &event) {
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

void 	CXmpp::handleVCard(const gloox::JID &jid, const gloox::VCard *vcard)
{
    while (!m_delegateMutex.trylock()) {
        if (!m_pDelegate) {
            break;
        }
        NSString* myJid = [NSString stringWithUTF8String: m_pClient->jid().bare().c_str()];
        NSString* nickname = [NSString stringWithUTF8String:vcard->nickname().c_str()];
        NSString* handleJid = [NSString stringWithUTF8String: jid.bare().c_str()];
        NSURL* url = [NSURL URLWithString:[NSString stringWithUTF8String:vcard->photo().extval.c_str()]];
        NSError* error = nil;
        try {
            NSData *imageData = [NSData dataWithContentsOfURL:url options:0 error:&error];
            if ([handleJid isNotEqualTo: myJid]) {
                if (!error && [imageData length] > 0) {
                    NSString *contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `Contact` SET `image`=? WHERE jid=?" withValues:imageData, handleJid, nil];
                    [ZIMDbConnection dataSource: @"addressbook" execute: contactStatement];
                    [m_pDelegate performSelectorOnMainThread:@selector(updateContact:) withObject:handleJid waitUntilDone:YES];
                }
            } else {
                NSImage *headImg = [[NSImage alloc] initWithData: imageData];
                NSImage *resizeHeadImg = [[NSImage alloc] initWithSize: NSMakeSize(95, 95)];
                NSSize originalSize = [headImg size];
                [resizeHeadImg lockFocus];
                [headImg drawInRect: NSMakeRect(0, 0, [resizeHeadImg size].width, [resizeHeadImg size].height)
                           fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height)
                          operation: NSCompositeSourceOver
                           fraction: 1.0];
                [resizeHeadImg unlockFocus];
                NSData *resizedData = [resizeHeadImg TIFFRepresentation];
                NSString *userStatement;
                if (!error && [resizedData length] > 0) {
                    userStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `User` SET jid=?, nickname=?, mood=?, headimg=? WHERE logintime=(SELECT MAX(logintime) FROM `User`)" withValues:myJid, nickname, @"", resizedData, nil];
                } else {
                    userStatement = [ZIMSqlPreparedStatement preparedStatement: @"UPDATE `User` SET jid=?, nickname=?, mood=? WHERE logintime=(SELECT MAX(logintime) FROM `User`)" withValues:myJid, nickname, @"", nil];
                }
                [ZIMDbConnection dataSource: @"user" execute: userStatement];
                [m_pDelegate performSelectorOnMainThread:@selector(updateSelfVcard) withObject:nil waitUntilDone:YES];
            }
        } catch (NSException* e) {
            NSLog(@"%@", e);
        }
        m_delegateMutex.unlock();
    }
}

void 	CXmpp::handleVCardResult (gloox::VCardHandler::VCardContext context, const gloox::JID &jid, gloox::StanzaError se)
{
    NSLog(@"vcard result");
}

gloox::MessageSession*    CXmpp::createSession(NSString* jidStr)
{
    gloox::JID jid([jidStr UTF8String]);
    gloox::MessageSession* session = new gloox::MessageSession(m_pClient, jid);
    return session;
}

void 	CXmpp::handleMessageSession(gloox::MessageSession *pSession)
{
    if (!m_pDelegate) {
        return;
    }
    SinaUCContact *info = [[SinaUCContact alloc] init];
    NSString* jidStr = [NSString stringWithUTF8String:pSession->target().bare().c_str()];
    NSString* contactStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, jid, name, image FROM Contact WHERE jid = ?;" withValues:jidStr, nil];
    NSArray* contactRes = [ZIMDbConnection dataSource:@"addressbook" query:contactStatement];
    if ([contactRes count] == 0) {
        requestVcard(jidStr);
        [info setJid:jidStr];
    } else {
        [info setJid:[[contactRes objectAtIndex:0] valueForKey:@"jid"]];
        [info setName:[[contactRes objectAtIndex:0] valueForKey:@"name"]];
        [info setImage:[[contactRes objectAtIndex:0] valueForKey:@"image"]];
    }
    XMPPSession *session = [[XMPPSession alloc] init];
    [session setSession:pSession];
    [session setInfo:info];
    [m_pDelegate performSelectorOnMainThread:@selector(uStartChat:) withObject:session waitUntilDone:YES];
}

void 	CXmpp::onSessionCreateError (const gloox::Error *error)
{
    if (!m_pDelegate) {
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


/*void    CXmpp::handleLog(gloox::LogLevel level, gloox::LogArea area, const std::string &message)
{
    printf("log: level: %d, area: %d, %s\n", level, area, message.c_str());
}*/

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
@synthesize myJid;
@synthesize cDelegate;
@synthesize rDelegate;

static XMPP *instance;
- (id) init
{
    @synchronized(self) {
        if (!instance) {
            instance = [super init];
            // Initialization code here.
            connectionDelegates = [[NSMutableArray alloc] init];
            sVcardUpdateDelegates = [[NSMutableArray alloc] init];
            cVcardUpdateDelegates = [[NSMutableArray alloc] init];
            tgtRequest = [[RequestWithTGT alloc] init];
            smngr = [[XMPPSessionManager alloc] init];
            [smngr setXmpp:self];
            rmngr = [[XMPPMUCRoomManager alloc] init];
        }
        return instance;
    }
}

- (RequestWithTGT *) requestWithTgt
{
    return tgtRequest;
}

- (void) registerConnectionDelegate:(id <SinaUCConnectionDelegate>) delegate
{
    [connectionDelegates addObject: delegate];
}

- (void) registerSVcardUpdateDelegate:(id <SinaUCSVcardUpdateDelegate>) delegate
{
    [sVcardUpdateDelegates addObject: delegate];
}

- (void) registerCVcardUpdateDelegate:(id <SinaUCCVcardUpdateDelegate>) delegate
{
    [cVcardUpdateDelegates addObject: delegate];
}

- (BOOL) login:(NSString *)username withPassword:(NSString *)password;
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

- (void) onConnect:(NSDictionary *) dict
{
    [self setMyJid:[dict valueForKey:@"jid"]];
    NSEnumerator* e = [connectionDelegates objectEnumerator];
    id < SinaUCConnectionDelegate > connectionDelegate;
    if ([[dict valueForKey:@"times"] intValue] == 1) {
        while (connectionDelegate = [e nextObject]) {
            [connectionDelegate didConnectedWithJidForFirstTime:[dict valueForKey:@"jid"]];
        }
    } else {
        while (connectionDelegate = [e nextObject]) {
            [connectionDelegate didConnectedWithJid:[dict valueForKey:@"jid"]];
        }
    }
}

- (void) onDisconnect:(NSString *) errorString
{
    NSEnumerator* e = [connectionDelegates objectEnumerator];
    id < SinaUCConnectionDelegate > connectionDelegate;
    while ((connectionDelegate = [e nextObject])) {
        [connectionDelegate didDisConnectedWithError:[errorString intValue]];
    }
}

- (void) requestVcard:(NSString* ) jid
{
    CXmpp::instance().requestVcard(jid);
}

- (void) updatePresence:(NSString *) jid
{
    [cDelegate updatePresence:jid];
}

- (void) updateContactRoster
{
    [cDelegate updateRoster];
}

- (void) updateRoomRoster
{
    [rDelegate updateRoster];
}

- (void) updateContact:(NSString *) jid
{
    NSEnumerator* e = [cVcardUpdateDelegates objectEnumerator];
    id < SinaUCCVcardUpdateDelegate > cVcardDelegate;
    while (cVcardDelegate = [e nextObject]) {
        [cVcardDelegate updateVcard: jid];
    }
}

- (void) updateSelfVcard
{
    NSEnumerator* e = [sVcardUpdateDelegates objectEnumerator];
    id < SinaUCSVcardUpdateDelegate > sVcardDelegate;
    while (sVcardDelegate = [e nextObject]) {
        [sVcardDelegate updateVcard];
    }
}

- (void) iStartChat:(SinaUCContact *) info
{
    XMPPSession *session = [smngr getSession:[info jid]];
    if (session == nil) {
        session = [[XMPPSession alloc] init];
        [session setInfo:info];
        [session setSession:CXmpp::instance().createSession([info jid])];
    }
    [smngr openSession:session withWindow:YES];
}

- (void) uStartChat:(XMPPSession *) session
{
    [smngr openSession:session withWindow:NO];
}

- (void) startRoomChat:(NSString*) jidStr
{
    if ([rmngr activateRoom:jidStr withWindow:YES]) {
        return;
    }
}

- (void) joinRoom:(XMPPMUCRoom *) room
{
    [rmngr joinRoom:room];
    /*if (!mucRoomManager) {
        return;
    }*/
    /*for (XMPPMUCRoom* room in rooms) {
     [mucRoomManager updateRoom:room];
     [mucRoomManager joinRoom:room];
     }*/
}

- (void) close:(XMPPSession *) session
{
    /*CXmpp::instance().closeSession([session session]);
    [sessionManager performSelector:@selector(removeSession:) withObject:session afterDelay:0];*/
}

@end
