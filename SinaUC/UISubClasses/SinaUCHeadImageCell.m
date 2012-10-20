//
//  SinaUCHeadImageCell.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-20.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCHeadImageCell.h"

@implementation SinaUCHeadImageCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    cellFrame.origin.x += 5;
    cellFrame.origin.y += 5;
    cellFrame.size.width -= 10;
    cellFrame.size.height -= 10;
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
