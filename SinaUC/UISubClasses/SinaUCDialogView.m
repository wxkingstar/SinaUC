//
//  SinaUCDialogView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-12.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCDialogView.h"

@implementation SinaUCDialogView
@synthesize headerView;
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

- (void)awakeFromNib
{
    [inputArea setFont:[NSFont fontWithName:@"Menlo" size:12]];

    [emotionBtn setOrig:@"toolbar_emotion_normal"];
    [emotionBtn setHover:@"toolbar_emotion_hover"];
    [emotionBtn setAlternate:@"toolbar_emotion_no"];
    
    [historyBtn setOrig:@"toolbar_history_normal"];
    [historyBtn setHover:@"toolbar_history_hover"];
    [historyBtn setAlternate:@"toolbar_history_no"];
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
            NSImage *backgroundDialog = [NSImage imageNamed:@"dialog_bg"];
            NSColor * dialogColor = [NSColor colorWithPatternImage:backgroundDialog];
            [dialogColor set];
            NSRectFill([dialogView frame]);
            NSRectFill([headerView frame]);
            [[NSColor whiteColor] set];
            NSRectFill([inputView frame]);
        }
        //}
    } else {
        changed = ([self focused] == NO);
        [self setFocused:YES];
        //if (changed) {
        @synchronized(self){
            NSImage *backgroundDialog = [NSImage imageNamed:@"dialog_bg_Inactive"];
            NSColor * dialogColor = [NSColor colorWithPatternImage:backgroundDialog];
            [dialogColor set];
            NSRectFill([dialogView frame]);
            NSRectFill([headerView frame]);
            [[NSColor whiteColor] set];
            NSRectFill([inputView frame]);
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
