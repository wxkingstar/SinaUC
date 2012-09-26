//
//  SinaUCLoginView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginWindow.h"
#import "SinaUCLoginView.h"
#import "SinaUCMaxLengthFormatter.h"

@implementation SinaUCLoginView

@synthesize backgroundTopImage;
@synthesize backgroundUpsideImage;
@synthesize backgroundImage;
@synthesize accountBackground;
@synthesize passwordBackground;
@synthesize account;
@synthesize password;
@synthesize focused;
@synthesize showTop;

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
    //backgroundTopImage = [NSImage imageNamed:@"LoginWindow_Background_Top_Active"];
    inited = @"active";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activate)
                                                 name:@"NSApplicationDidBecomeActiveNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deactivate)
                                                 name:@"NSApplicationDidResignActiveNotification"
                                               object:nil];
    [passwordBackground setImage:[NSImage imageNamed:@"LoginWindow_Password"]];
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
        backgroundImage = [NSImage imageNamed:@"LoginWindow_Background_Active"];
        backgroundTopImage = [NSImage imageNamed:@"LoginWindow_Background_Active_Top"];
        [accountBackground setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Active"]];
    } else {
        changed = (focused == NO);
        focused = YES;
        backgroundUpsideImage = [NSImage imageNamed:@"LoginWindow_Background_Upside_InActive"];
        backgroundImage = [NSImage imageNamed:@"LoginWindow_Background_InActive"];
        backgroundTopImage = [NSImage imageNamed:@"LoginWindow_Background_InActive_Top"];
        [accountBackground setImage:[NSImage imageNamed:@"LoginWindow_Accounts_Logining"]];
    }
    
    [backgroundUpsideImage drawAtPoint:NSMakePoint(0, 19)
                              fromRect:NSZeroRect
                             operation:NSCompositeSourceOver
                              fraction:1.0];
    [backgroundImage drawAtPoint:NSMakePoint(0, -10)
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
