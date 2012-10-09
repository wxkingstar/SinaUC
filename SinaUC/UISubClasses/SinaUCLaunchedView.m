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
    // Clear the drawing rect.
    NSLog(@"$$");
    [super drawRect:rect];
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
        
    NSImage *backgroundBuddy = [NSImage imageNamed:@"main_buddylist_bkg"];
    NSEdgeInsets buddyInsets = {1,2,1,2};
    [backgroundBuddy drawStretchableInRect:NSMakeRect(0, 35, [backgroundContactsImageView frame].size.width, [backgroundContactsImageView frame].size.height)
                                edgeInsets:buddyInsets
                                 operation:NSCompositeSourceOver
                                  fraction:1.0];
    //窗口focused
    BOOL changed = NO;
    if ([self isActive]) {
        changed = ([self focused] == YES);
        [self setFocused:NO];
        //if (changed) {
            @synchronized(self) {
                [backgroundHeaderImageView setImage:[NSImage imageNamed:@"Header+Search_Active"]];
                NSImage *backgroundBottom = [NSImage imageNamed:@"main_bottonbar_active"];
                NSEdgeInsets bodyInsets = {10,10,10,10};
                [backgroundBottom drawStretchableInRect:[backgroundBottomImageView bounds] edgeInsets:bodyInsets operation:NSCompositeSourceOver fraction:1.0];
                //[backgroundBottomImageView setImage:];
            }
        //}
    } else {
        changed = ([self focused] == NO);
        [self setFocused:YES];
        //if (changed) {
            @synchronized(self){
                [backgroundHeaderImageView setImage:[NSImage imageNamed:@"Header+Search_Inactive"]];
                NSImage *backgroundBottom = [NSImage imageNamed:@"main_bottonbar_inactive"];
                NSEdgeInsets bodyInsets = {10,10,10,10};
                [backgroundBottom drawStretchableInRect:[backgroundBottomImageView bounds] edgeInsets:bodyInsets operation:NSCompositeSourceOver fraction:1.0];
            }
        //}
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
