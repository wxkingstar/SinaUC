//
//  SinaUCLoginViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginViewController.h"
#import "SinaUCButton.h"
#import "SinaUCLoginView.h"

@interface SinaUCLoginViewController ()

@end

@implementation SinaUCLoginViewController

@synthesize loginBtn;
@synthesize hideTopBtn;
@synthesize showTopBtn;

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
    [loginBtn setOrig:@"LoginWindow_LoginBtn_Normal"];
    [loginBtn setHover:@"LoginWindow_LoginBtn_Hover"];
    [loginBtn setAlternate:@"LoginWindow_LoginBtn_Click"];

    [showTopBtn setOrig:@"LoginWindow_DownArrow_Normal"];
    [showTopBtn setHover:@"LoginWindow_DownArrow_Hover"];
    [showTopBtn setAlternate:@"LoginWindow_DownArrow_Click"];
    
    [hideTopBtn setOrig:@"LoginWindow_UpArrow_Normal"];
    [hideTopBtn setHover:@"LoginWindow_UpArrow_Hover"];
    [hideTopBtn setAlternate:@"LoginWindow_UpArrow_Click"];
}

- (IBAction) showTop:(id)sender
{
    //发送消息？
    [(SinaUCLoginView*)self.view setShowTop:YES];
    [showTopBtn setHidden:YES];
    [hideTopBtn setHidden:NO];
}

- (IBAction) hideTop:(id)sender
{
    [(SinaUCLoginView*)self.view setShowTop:NO];
    [showTopBtn setHidden:NO];
    [hideTopBtn setHidden:YES];
}

- (IBAction) login:(id)sender
{
}

@end
