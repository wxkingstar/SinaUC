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
@synthesize myHeadimg;
@synthesize loginAnimationView;
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
@synthesize myAccountBtn;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loginAnimate:(id)sender
{
    if (++loginAnimationImagesCurrentIndex>=12) {
        loginAnimationImagesCurrentIndex = 0;
    }
    [loginAnimationView setImage:[loginAnimationImages objectAtIndex:loginAnimationImagesCurrentIndex]];
}

- (void)awakeFromNib {
    //[loginAnimationView setHidden:YES];
    loginAnimationImages = [[NSMutableArray alloc] init];
    for (loginAnimationImagesCurrentIndex=1; loginAnimationImagesCurrentIndex<=12; loginAnimationImagesCurrentIndex++) {
        [loginAnimationImages addObject:[NSImage imageNamed:[NSString stringWithFormat:@"LoginWindow_WelcomeAnimation_%02d", loginAnimationImagesCurrentIndex]]];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loginAnimate:) userInfo:nil repeats:YES];
    // Load the images from the bundle's Resources directory
    [myAccountBtn setOrig:@"LoginWindow_HeadMask_Active"];
    [myAccountBtn setHover:@"LoginWindow_HeadMask_Active_Hover"];
    [myAccountBtn setAlternate:@"LoginWindow_HeadMask_Active"];
    
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
        if (changed) {
            @synchronized(self) {
                [myAccountBtn setOrig:@"LoginWindow_HeadMask_Active"];
                [myAccountBtn setHover:@"LoginWindow_HeadMask_Active_Hover"];
                
                backgroundUpsideImage = [NSImage imageNamed:@"LoginWindow_Background_Upside_Active"];
                [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                                          fromRect:NSZeroRect
                                         operation:NSCompositeSourceOver
                                          fraction:1.0];
                [backgroundTopImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_Active_Top"]];
                [backgroundImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_Active"]];
                [accountBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Active"]];
            }
        } else {
            [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                                      fromRect:NSZeroRect
                                     operation:NSCompositeSourceOver
                                      fraction:1.0];
        }
    } else {
        changed = (focused == NO);
        focused = YES;
        if (changed) {
            @synchronized(self){
                [myAccountBtn setOrig:@"LoginWindow_HeadMask_InActive"];
                [myAccountBtn setHover:@"LoginWindow_HeadMask_InActive_Hover"];
                
                backgroundUpsideImage = [NSImage imageNamed:@"LoginWindow_Background_Upside_InActive"];
                [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                                          fromRect:NSZeroRect
                                         operation:NSCompositeSourceOver
                                          fraction:1.0];
                [backgroundTopImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_InActive_Top"]];
                [backgroundImageView setImage:[NSImage imageNamed:@"LoginWindow_Background_InActive"]];
                [accountBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Logining"]];
            }
        } else {
            [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                                      fromRect:NSZeroRect
                                     operation:NSCompositeSourceOver
                                      fraction:1.0];
        }
    }

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
