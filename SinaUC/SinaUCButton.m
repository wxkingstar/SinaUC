//
//  SinaUCButton.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-25.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCButton.h"

@implementation SinaUCButton

@synthesize hoverImage;
@synthesize origImage;

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
    [self setImagePosition:NSImageOnly];
    [self setBordered:NO];
    [self.cell setShowsStateBy:NSPushInCellMask];
    [self.cell setHighlightsBy:NSContentsCellMask];
}

- (void)setOrigImage:(NSString *)theOrigImage
{
    [super setImage:[NSImage imageNamed:theOrigImage]];
    origImage = theOrigImage;
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (trackArea) {
        [self removeTrackingArea:trackArea];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    trackArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setImage: [NSImage imageNamed:hoverImage]];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setImage: [NSImage imageNamed:origImage]];
}

@end
