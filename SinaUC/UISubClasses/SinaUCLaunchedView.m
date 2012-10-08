//
//  SinaUCLaunchedView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLaunchedView.h"

@implementation SinaUCLaunchedView

@synthesize isActive;
@synthesize focused;
@synthesize headerView;
@synthesize contactsView;
@synthesize contactsTabView;
@synthesize bottomView;
@synthesize backgroundHeaderImageView;
@synthesize backgroundContactsImageView;
@synthesize backgroundBottomImageView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib
{
    [[self window] setFrame:NSMakeRect(_window.frame.origin.x, _window.frame.origin.y, 221, 395) display:YES animate:NO];
    [headerView setFrame:NSMakeRect(0, 285, 221, 110)];
    [contactsView setFrame:NSMakeRect(0, 35, 221, 250)];
    [bottomView setFrame:NSMakeRect(0, 0, 221, 35)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activate)
                                                 name:@"NSApplicationDidBecomeActiveNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivate)
                                                 name:@"NSApplicationDidResignActiveNotification"
                                               object:nil];
    [self setIsActive:YES];
}

- (void) drawRect:(NSRect)rect {
    NSLog(@"$$");
    // Clear the drawing rect.
    [super drawRect:rect];
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
        
    NSImage *backgroundBuddy = [NSImage imageNamed:@"main_buddylist_bkg"];
    NSEdgeInsets insets = {1,2,1,2};
    [backgroundBuddy drawStretchableInRect:NSMakeRect(0, 35, 221, 250)
                                edgeInsets:insets
                                 operation:NSCompositeSourceOver
                                  fraction:1.0];
    [backgroundContactsImageView setImage:backgroundBuddy];
    
    //窗口focused
    BOOL changed = NO;
    if ([self isActive]) {
        changed = ([self focused] == YES);
        [self setFocused:NO];
        if (changed) {
            @synchronized(self) {
                [backgroundHeaderImageView setImage:[NSImage imageNamed:@"Header+Search_Active"]];
                [backgroundBottomImageView setImage:[NSImage imageNamed:@"main_bottonbar_active"]];
            }
        }
    } else {
        changed = ([self focused] == NO);
        [self setFocused:YES];
        if (changed) {
            @synchronized(self){
                [backgroundHeaderImageView setImage:[NSImage imageNamed:@"Header+Search_Inactive"]];
                [backgroundBottomImageView setImage:[NSImage imageNamed:@"main_bottonbar_inactive"]];
            }
        }
    }
    
    if (changed) {
        [[self window] display];
    }
}

- (void) deactivate
{
    [self setIsActive:NO];
    [self setNeedsDisplay:YES];
}

- (void) activate
{
    [self setIsActive:YES];
    [self setNeedsDisplay:YES];
}

@end
