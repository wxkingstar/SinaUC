//
//  SinaUCTextView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCTextView.h"

@implementation SinaUCTextView

@synthesize target;
@synthesize action;

- (void)keyDown:(NSEvent *)theEvent
{
    if ([theEvent keyCode] == 36) // enter key
    {
        NSUInteger modifiers = [theEvent modifierFlags];
        if ((modifiers & NSShiftKeyMask) || (modifiers & NSAlternateKeyMask))
        {
            // shift or option/alt held: new line
            [super insertNewline:self];
        }
        else
        {
            // straight enter key: perform action
            [target performSelector:action withObject:self];
        }
    }
    else
    {
        // allow NSTextView to handle everything else
        [super keyDown:theEvent];
    }
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
