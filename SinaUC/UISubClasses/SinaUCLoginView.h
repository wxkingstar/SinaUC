//
//  SinaUCLoginView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SinaUCDelegate;
@class SinaUCButton;
@interface SinaUCLoginView : NSView <SinaUCDelegate>
{
    //是否处于激活状态
    NSString *inited;
    //上半部分-我的账号
    NSView * backgroundUpsideMyAccountView;
    //上半部分-其它账号
    NSView * backgroundUpsideOtherAccountsView;
    //下半部分
    NSView *backgroundDownsideView;
    //上半部分背景
    NSImageView *backgroundUpsideImageView;
    //下半部分背景
    NSImageView *backgroundTopImageView;
    //下半部分边框背景
    NSImageView *backgroundImageView;
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
    //切换其它账号
    SinaUCButton *myAccountBtn;
    //我的头像
    NSImageView *myHeadimg;
    //登陆动画
    NSImageView *loginAnimationView;
    NSMutableArray *loginAnimationImages;
    int loginAnimationImagesCurrentIndex;
    BOOL focused;
}

@property (assign) BOOL focused;
@property (retain) IBOutlet NSView *backgroundUpsideMyAccountView;
@property (retain) IBOutlet NSView *backgroundUpsideOtherAccountsView;
@property (retain) IBOutlet NSView *backgroundDownsideView;
@property (retain) IBOutlet NSImageView *backgroundUpsideImageView;
@property (retain) IBOutlet NSImageView *myHeadimg;
@property (retain) IBOutlet NSImageView *loginAnimationView;
@property (retain) IBOutlet NSImageView *backgroundTopImageView;
@property (retain) IBOutlet NSImageView *backgroundImageView;
@property (retain) IBOutlet NSImageView *accountBackgroundView;
@property (retain) IBOutlet NSImageView *passwordBackgroundView;
@property (retain) IBOutlet NSTextField *username;
@property (retain) IBOutlet NSTextField *password;
@property (retain) IBOutlet SinaUCButton *myAccountBtn;
@property (retain) IBOutlet SinaUCButton *loginBtn;
@property (retain) IBOutlet SinaUCButton *showTopBtn;
@property (retain) IBOutlet SinaUCButton *hideTopBtn;

- (void)loginAnimate:(id)sender;

@end
