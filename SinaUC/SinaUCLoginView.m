//
//  SinaUCLoginView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "SinaUCLoginView.h"
#import "SinaUCMaxLengthFormatter.h"
#import "SinaUCButton.h"

@implementation SinaUCLoginView

@synthesize backgroundUpsideImage;
@synthesize backgroundTopImageView;
@synthesize backgroundImageView;
@synthesize backgroundDownsideView;
@synthesize accountBackgroundView;
@synthesize passwordBackgroundView;
@synthesize account;
@synthesize password;
@synthesize focused;
@synthesize loginBtn;
@synthesize hideTopBtn;
@synthesize showTopBtn;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    // Load the images from the bundle's Resources directory
    [loginBtn setOrig:@"LoginWindow_LoginBtn_Normal"];
    [loginBtn setHover:@"LoginWindow_LoginBtn_Hover"];
    [loginBtn setAlternate:@"LoginWindow_LoginBtn_Click"];
    
    [showTopBtn setOrig:@"LoginWindow_DownArrow_Normal"];
    [showTopBtn setHover:@"LoginWindow_DownArrow_Hover"];
    [showTopBtn setAlternate:@"LoginWindow_DownArrow_Click"];
    [showTopBtn setHidden:NO];
    
    [hideTopBtn setOrig:@"LoginWindow_UpArrow_Normal"];
    [hideTopBtn setHover:@"LoginWindow_UpArrow_Hover"];
    [hideTopBtn setAlternate:@"LoginWindow_UpArrow_Click"];
    [hideTopBtn setHidden:YES];
    
    [passwordBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Password"]];
    SinaUCMaxLengthFormatter* af = [[SinaUCMaxLengthFormatter alloc] init];
    [af setMaximumLength:25];
    [account setFormatter:af];
    SinaUCMaxLengthFormatter* pf = [[SinaUCMaxLengthFormatter alloc] init];
    [pf setMaximumLength:16];
    [password setFormatter:pf];
    [[self window] setFrame:NSMakeRect(_window.frame.origin.x, _window.frame.origin.y, 250, 351) display:YES animate:NO];
    [backgroundDownsideView setFrame:NSMakeRect(0, 80, 256, 29)];
    inited = @"active";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activate)
                                                 name:@"NSApplicationDidBecomeActiveNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivate)
                                                 name:@"NSApplicationDidResignActiveNotification"
                                               object:nil];
}

- (void)drawRect:(NSRect)rect {
    // Clear the drawing rect.
    [super drawRect:rect];
    [[NSColor clearColor] set];
    NSRectFill([self frame]);

    //窗口focused
    BOOL changed = NO;
    if ([inited isEqualToString:@"active"]) {
        changed = (focused == YES);
        focused = NO;
        backgroundUpsideImage = [NSImage imageNamed:@"LoginWindow_Background_Upside_Active"];
        [backgroundTopImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_Active_Top"]];
        [backgroundImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_Active"]];
        [accountBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Active"]];
    } else {
        changed = (focused == NO);
        focused = YES;
        backgroundUpsideImage = [NSImage imageNamed:@"LoginWindow_Background_Upside_InActive"];
        [backgroundTopImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_InActive_Top"]];
        [backgroundImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_InActive"]];
        [accountBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Logining"]];
    }
    
    //上半部分背景永远不变
    [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver
                              fraction:1.0];
    
    if (changed) {
        [[self window] display];
    }
}

- (void) deactivate
{
    inited = @"inactive";
}

- (void) activate
{
    inited = @"active";
}

@end
