//
//  SinaUCLoginViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCAppDelegate.h"
#import "SinaUCLoginViewController.h"
#import "SinaUCLoginView.h"
#import "XMPP.h"
#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "User.h"

@interface SinaUCLoginViewController ()

@end

@implementation SinaUCLoginViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
    //取最后一次登陆用户
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *userDbPath = [NSString pathWithComponents: [NSArray arrayWithObjects: [(NSArray *)NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex: 0], @"SinaUC/user.sqlite", nil]];
    if (![fileManager fileExistsAtPath:userDbPath]) {
        if ([fileManager createFileAtPath:userDbPath contents:nil attributes:nil]) {
            //创建user数据库
            ZIMSqlCreateTableStatement *createUser = [[ZIMSqlCreateTableStatement alloc] init];
            [createUser table: @"User"];
            [createUser column: @"pk" type: ZIMSqlDataTypeInteger defaultValue: ZIMSqlDefaultValueIsAutoIncremented];
            [createUser column: @"username" type: ZIMSqlDataTypeVarChar(25)];
            [createUser column: @"password" type: ZIMSqlDataTypeVarChar(16)];
            [createUser column: @"status" type: ZIMSqlDataTypeSmallInt];
            [createUser column: @"logintime" type: ZIMSqlDataTypeDateTime];
            [createUser column: @"headimg" type: ZIMSqlDataTypeBlob];
            NSString *statement = [createUser statement];
            //NSLog(@"%@", statement);
            [ZIMDbConnection dataSource: @"user" execute: statement];
        }
    }

    NSString *userStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT username, password, headimg FROM User ORDER BY logintime DESC limit 1" withValues:nil, nil];
    NSArray *userRes = [ZIMDbConnection dataSource:@"user" query:userStatement];
    if ([userRes count] == 0) {
        [[(SinaUCLoginView*)self.view valueForKey:@"myHeadimg"] setImage:[NSImage imageNamed:@"LoginWindow_BigDefaultHeadImage"]];
    } else {
        [[(SinaUCLoginView*)self.view valueForKey:@"myHeadimg"] setImage:[[NSImage alloc] initWithData:[[userRes objectAtIndex:0] valueForKey:@"headimg"]]];
        [[(SinaUCLoginView*)self.view valueForKey:@"username"] setStringValue:[[userRes objectAtIndex:0] valueForKey:@"username"]];
        [[(SinaUCLoginView*)self.view valueForKey:@"password"] setStringValue:[[userRes objectAtIndex:0] valueForKey:@"password"]];
    }
}

- (IBAction) showTop:(id)sender
{
    //发送消息？
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:YES];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:NO];
    [NSAnimationContext beginGrouping];
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay];
    [[[(SinaUCLoginView*)self.view valueForKey:@"backgroundDownsideView"] animator] setFrame:NSMakeRect(0, 0, 256, 109)];
    [NSAnimationContext endGrouping];
}

- (IBAction) hideTop:(id)sender
{
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:NO];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:YES];
    [NSAnimationContext beginGrouping];
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay];
    [[[(SinaUCLoginView*)self.view valueForKey:@"backgroundDownsideView"] animator] setFrame:NSMakeRect(0, 80, 256, 29)];
    [NSAnimationContext endGrouping];
}

- (IBAction) login:(id)sender
{
    NSString* username = [[(SinaUCLoginView*)self.view valueForKey:@"username"] stringValue];
    NSString* password = [[(SinaUCLoginView*)self.view valueForKey:@"password"] stringValue];
    [xmpp login:username withPassword:password];
    User* user = [[User alloc] init];
    [user setUsername:username];
    [user setPassword:password];
    NSString *userStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, username, headimg FROM User WHERE username=?" withValues:username, nil];
    NSArray *userRes = [ZIMDbConnection dataSource:@"user" query:userStatement];
    if ([userRes count] == 0) {
        [user save];
    } else {
        [user setPk:[[userRes objectAtIndex:0] valueForKey:@"pk"]];
        [user save];
    }
}

- (void) willConnect
{
    //显示登录动画
    [[(SinaUCLoginView*)self.view valueForKey:@"loginAnimationView"] setHidden:NO];
    //不允许修改用户名和密码
    //显示取消登录按钮
}

- (void) didConnectedWithJid:(NSString*) jid
{
    
}

- (void) didDisConnectedWithError:(NSInteger) error
{
    //取消后隐藏登陆动画
    [[(SinaUCLoginView*)self.view valueForKey:@"loginAnimationView"] setHidden:YES];
    //允许修改用户名和密码
    //隐藏取消登陆按钮
}


@end
