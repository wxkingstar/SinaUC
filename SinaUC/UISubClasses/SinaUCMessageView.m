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
@synthesize contactsView;

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
