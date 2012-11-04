//
//  SinaUCListGroupCell.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCListGroupCell.h"

@implementation SinaUCListGroupCell

- (id)init
{
    self = [super init];
    if (self) {
        [self setEditable:NO];
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
    }
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView
{
     NSColor* color = [NSColor clearColor];
    [color set];
     NSRectFill(cellFrame);
    [super drawWithFrame:cellFrame inView:controlView];
}

@end