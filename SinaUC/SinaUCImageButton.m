//
//  SinaUCImageButton.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-24.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCImageButton.h"

@implementation SinaUCImageButton

@synthesize hoverImage;

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
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self setImage:hoverImage];
    [self display];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self setImage:self.image];
    [self display];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}


@end
