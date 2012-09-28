//
//  SinaUCButton.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-25.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCButton.h"

@implementation SinaUCButton

@synthesize hover;
@synthesize orig;
@synthesize alternate;

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
    [self setBordered:NO];
    [self setImagePosition:NSImageOnly];
    [self.cell setShowsStateBy:NSPushInCellMask];
    [self.cell setHighlightsBy:NSContentsCellMask];
}

- (void)setOrig:(NSString *)theOrig
{
    [super setImage:[NSImage imageNamed:theOrig]];
    orig = theOrig;
}

- (void)setAlternate:(NSString *)theAlternate
{
    [super setAlternateImage:[NSImage imageNamed:theAlternate]];
    alternate = theAlternate;
}

- (void)updateTrackingAreas
{
    [self removeTrackingArea:trackArea];
    [self createTrackingArea];
    [super updateTrackingAreas];
}

- (void) createTrackingArea
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
        [self mouseEntered: nil];
    } else {
        [self mouseExited: nil];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setImage: [NSImage imageNamed:hover]];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setImage: [NSImage imageNamed:orig]];
}

@end
