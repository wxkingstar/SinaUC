//
//  SinaUCListNameCell.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-3.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCListNameCell.h"

@implementation SinaUCListNameCell
@synthesize title;
@synthesize subTitle;

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
    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSInteger titleSize = 12;
    NSInteger subtitleSize = 11;
	NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:NSLeftTextAlignment];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	//	float fontSize = 5;//[NSFont systemFontSizeForControlSize:NSMiniControlSize],//
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [self isHighlighted]?[NSColor whiteColor]:[NSColor blackColor], NSForegroundColorAttributeName,
						   [NSFont userFontOfSize:titleSize],
						   NSFontAttributeName,
						   paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSRect titleRect = cellFrame;
    if (subTitle) {
        titleRect.size.height /=2;
        NSRect subtitleRect = titleRect;
        subtitleRect.origin.y += titleRect.size.height;
        subtitleRect.origin.y += (subtitleRect.size.height-subtitleSize)/2-4;
        subtitleRect.size.height = subtitleSize+2;
        subtitleRect.origin.x += 5;
        subtitleRect.size.width -= 8;
        
        NSDictionary *subtitleAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self isHighlighted]?[NSColor lightGrayColor]:[NSColor grayColor],
                                       NSForegroundColorAttributeName,
                                       [NSFont userFontOfSize:subtitleSize],
                                       NSFontAttributeName,
                                       paragraphStyle, NSParagraphStyleAttributeName, nil];
        NSMutableAttributedString* attributedSubtitle = [[NSMutableAttributedString alloc] initWithString:subTitle attributes:subtitleAttrs];
        [attributedSubtitle drawInRect:subtitleRect];
    }
    titleRect.origin.y += (titleRect.size.height-titleSize)/2+2;
    titleRect.size.height = titleSize+8;
    titleRect.origin.x += 5;
    titleRect.size.width -= 8;
    NSMutableAttributedString* attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:attrs];
    [attributedTitle drawInRect:titleRect];
}

@end
