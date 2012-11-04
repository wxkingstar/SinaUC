//
//  SinaUCListImageCell.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-3.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCListImageCell.h"

@implementation SinaUCListImageCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    if ([self isHighlighted]) {
        NSImage *gradient = [NSImage imageNamed:@"BuddyHighlightColor"];
        [gradient setFlipped:YES];
        NSSize gradientSize = [gradient size];
        for (int i = cellFrame.origin.x; i < (cellFrame.origin.x + cellFrame.size.width); i += gradientSize.width) {
            [gradient drawInRect:NSMakeRect(i, cellFrame.origin.y, gradientSize.width, cellFrame.size.height)
                        fromRect:NSMakeRect(0, 0, gradientSize.width, gradientSize.height)
                       operation:NSCompositeSourceOver
                        fraction:1.0];
        }
    }
    cellFrame.origin.x += 10;
    cellFrame.origin.y += 5;
    cellFrame.size.width -= 10;
    cellFrame.size.height -= 10;
    [super drawWithFrame:cellFrame inView:controlView];
}

@end
