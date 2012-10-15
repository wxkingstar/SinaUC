//
//  SinaUCTabviewItem.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-13.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCTabviewItem.h"

@implementation SinaUCTabviewItem

- (void)drawLabel:(BOOL)shouldTruncateLabel inRect:(NSRect)tabRect
{
    NSLog(@"!!");
    // do we have an image to draw
    NSImage *pImage = [NSImage imageNamed:@"mainpanel_tab_bkg"];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    NSAffineTransform* xform = [NSAffineTransform transform];
    [xform translateXBy:0.0 yBy: tabRect.size.height];
    [xform scaleXBy:1.0 yBy:-1.0];
    [xform concat];
    
    
    CGFloat x_Offset =0;
    if(pImage){
        [pImage drawInRect:NSMakeRect(tabRect.origin.x-8,-6,16, 16)fromRect:NSZeroRect
                 operation:NSCompositeSourceOver
                  fraction:1.0];
        x_Offset =  16;
    }
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
    [super drawLabel:shouldTruncateLabel inRect:tabRect];

}

@end
