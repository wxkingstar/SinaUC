//
//  SinaUCMessageView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-10.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageView.h"

@implementation SinaUCMessageView

@synthesize isActive;
@synthesize focused;
@synthesize headerView;
@synthesize contactsView;
@synthesize dialogView;
@synthesize inputView;
@synthesize shadowLine;

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
    [historyBtn setOrig:@"toolbar_history_normal"];
    [historyBtn setHover:@"toolbar_history_hover"];
    [historyBtn setAlternate:@"toolbar_history_no"];
    
    [emotionBtn setOrig:@"toolbar_emotion_normal"];
    [emotionBtn setHover:@"toolbar_emotion_hover"];
    [emotionBtn setAlternate:@"toolbar_emotion_no"];
    
    [inputArea setFont:[NSFont fontWithName:@"Menlo" size:12]];

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
    
    [super drawRect:rect];
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    
    //窗口focused
    BOOL changed = NO;
    
    if ([self isActive]) {
        changed = ([self focused] == YES);
        [self setFocused:NO];
        //if (changed) {
        @synchronized(self) {
            NSImage *backgroundContacts = [NSImage imageNamed:@"tab_bg_texture"];
            NSColor * contactsColor = [NSColor colorWithPatternImage:backgroundContacts];
            [contactsColor set];
            NSRectFill([contactsView frame]);
            NSImage *backgroundDialog = [NSImage imageNamed:@"dialog_bg"];
            NSColor * dialogColor = [NSColor colorWithPatternImage:backgroundDialog];
            [dialogColor set];
            NSRectFill(NSMakeRect(150, 100, [dialogView frame].size.width, [dialogView frame].size.height));
            NSRectFill(NSMakeRect(150, [headerView frame].origin.y, [headerView frame].size.width, 100));
            [[NSColor whiteColor] set];
            NSRectFill(NSMakeRect(150, 0, [inputView frame].size.width, 100));
        }
        //}
    } else {
        changed = ([self focused] == NO);
        [self setFocused:YES];
        //if (changed) {
        @synchronized(self){
            NSImage *backgroundContacts = [NSImage imageNamed:@"tab_bg_texture_InActive"];
            NSColor * imgColor = [NSColor colorWithPatternImage:backgroundContacts];
            [imgColor set];
            NSRectFill([contactsView frame]);
            NSImage *backgroundDialog = [NSImage imageNamed:@"dialog_bg_Inactive"];
            NSColor * dialogColor = [NSColor colorWithPatternImage:backgroundDialog];
            [dialogColor set];
            NSRectFill(NSMakeRect(150, 100, [dialogView frame].size.width, [dialogView frame].size.height));
            NSRectFill(NSMakeRect(150, [headerView frame].origin.y, [headerView frame].size.width, 100));
            [[NSColor whiteColor] set];
            NSRectFill(NSMakeRect(150, 0, [inputView frame].size.width, 100));
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
