//
//  SinaUCLoginView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginView.h"
#import "SinaUCMaxLengthFormatter.h"
#import <Quartz/Quartz.h>

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
@synthesize showTop;
@synthesize showingTop;
@synthesize hidingTop;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)slideDirection
{
   
}

- (void)awakeFromNib {
    // Load the images from the bundle's Resources directory
    //backgroundTopImage = [NSImage imageNamed:@"LoginWindow_Background_Top_Active"];
    [[self window] setFrame:NSMakeRect(_window.frame.origin.x, _window.frame.origin.y, 250, 351) display:YES animate:NO];
    showedTop = NO;
    hidingTop = NO;
    inited = @"active";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activate)
                                                 name:@"NSApplicationDidBecomeActiveNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivate)
                                                 name:@"NSApplicationDidResignActiveNotification"
                                               object:nil];
    [passwordBackgroundView setImage:[NSImage imageNamed:@"LoginWindow_Password"]];
    SinaUCMaxLengthFormatter* af = [[SinaUCMaxLengthFormatter alloc] init];
    [af setMaximumLength:25];
    [account setFormatter:af];
    SinaUCMaxLengthFormatter* pf = [[SinaUCMaxLengthFormatter alloc] init];
    [pf setMaximumLength:16];
    [password setFormatter:pf];
}

- (void)drawRect:(NSRect)rect {
    // Clear the drawing rect.
    [super drawRect:rect];
    [[NSColor clearColor] set];
    NSRectFill([self frame]);

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
    
    [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 109)
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver
                              fraction:1.0];
    BOOL show = NO;
    if (showTop == YES) {
        show = (showingTop == YES);
        showingTop = NO;
        if (show) {
            showedTop = YES;
            NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
            [[NSAnimationContext currentContext] setDuration:delay];
            [[backgroundDownsideView animator] setFrame:NSMakeRect(0, 0, 256, 109)];
        }
    } else {
        show = (showingTop == NO);
        showingTop = YES;
        if (show && showedTop == YES) {
            hidingTop = YES;
            [NSAnimationContext beginGrouping];
            NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
            [[NSAnimationContext currentContext] setDuration:delay];
            [[backgroundDownsideView animator] setFrame:NSMakeRect(0, 80, 256, 29)];
            [NSAnimationContext endGrouping];
        }
        if (floor(backgroundDownsideView.frame.size.height) == 29) {
            hidingTop = NO;
        }
        if (!showedTop || hidingTop == NO) {
            [backgroundDownsideView setFrame:NSMakeRect(0, 80, 256, 29)];
        }
    }
    
    if (changed || show) {
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
