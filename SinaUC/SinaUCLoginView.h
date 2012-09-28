//
//  SinaUCLoginView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SinaUCButton;
@interface SinaUCLoginView : NSView
{
    //是否处于激活状态
    NSString *inited;
    //上半部分
    NSImage *backgroundUpsideImage;
    //下半部分边框背景
    NSImageView *backgroundImageView;
    //下半部分背景
    NSImageView *backgroundTopImageView;
    //下半部分
    NSView * backgroundDownsideView;
    //用户名背景
    NSImageView *accountBackgroundView;
    //密码背景
    NSImageView *passwordBackgroundView;
    //用户名输入框
    NSTextField *username;
    //密码输入框
    NSTextField *password;
    //登陆按钮
    SinaUCButton *loginBtn;
    //显示其它信息按钮
    SinaUCButton *showTopBtn;
    //隐藏其它信息按钮
    SinaUCButton *hideTopBtn;
    BOOL focused;
    BOOL showingTop;
    BOOL hidingTop;
    BOOL showTop;
}

@property (assign) BOOL focused;
@property (assign) BOOL showingTop;
@property (assign) BOOL hidingTop;
@property (assign) BOOL showTop;
@property (retain) NSImage *backgroundUpsideImage;
@property (retain) IBOutlet NSImageView *backgroundTopImageView;
@property (retain) IBOutlet NSImageView *backgroundImageView;
@property (retain) IBOutlet NSView *backgroundDownsideView;
@property (retain) IBOutlet NSImageView *accountBackgroundView;
@property (retain) IBOutlet NSImageView *passwordBackgroundView;
@property (retain) IBOutlet NSTextField *account;
@property (retain) IBOutlet NSTextField *password;
@property (retain) IBOutlet SinaUCButton *loginBtn;
@property (retain) IBOutlet SinaUCButton *showTopBtn;
@property (retain) IBOutlet SinaUCButton *hideTopBtn;

@end
