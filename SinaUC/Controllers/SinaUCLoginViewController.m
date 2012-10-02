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

@interface SinaUCLoginViewController ()

@end

@implementation SinaUCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [[(SinaUCLoginView*)self.view valueForKey:@"myHeadimg"] setImage:[NSImage imageNamed:@"LoginWindow_BigDefaultHeadImage"]];   
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
    [xmpp login:[[(SinaUCLoginView*)self.view valueForKey:@"username"] stringValue] withPassword:[[(SinaUCLoginView*)self.view valueForKey:@"password"] stringValue]];
}

- (void)willConnect
{
    //显示登录动画
    //不允许修改用户名和密码
    //显示取消登录按钮
}

- (void)didDisConnectedWithError:(NSInteger) error
{
    //取消后隐藏登陆动画
    //允许修改用户名和密码
    //隐藏取消登陆按钮
}


@end
