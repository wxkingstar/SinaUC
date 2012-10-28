//
//  SinaUCImageDrawingAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

typedef enum {
	IMAGE_POSITION_LEFT = 0,
	IMAGE_POSITION_RIGHT,
	IMAGE_POSITION_LOWER_LEFT,
	IMAGE_POSITION_LOWER_RIGHT
} IMAGE_POSITION;


@interface NSImage (AIImageDrawingAdditions)

- (void)tileInRect:(NSRect)rect;
- (NSImage *)imageByScalingToSize:(NSSize)size;
- (NSImage *)imageByFadingToFraction:(CGFloat)delta;
- (NSImage *)imageByScalingToSize:(NSSize)size fraction:(CGFloat)delta;
- (NSImage *)imageByScalingForMenuItem;
- (NSImage *)imageByScalingToSize:(NSSize)size fraction:(CGFloat)delta flipImage:(BOOL)flipImage proportionally:(BOOL)proportionally allowAnimation:(BOOL)allowAnimation;
- (NSImage *)imageByFittingInSize:(NSSize)size;
- (NSImage *)imageByFittingInSize:(NSSize)size fraction:(CGFloat)delta flipImage:(BOOL)flipImage proportionally:(BOOL)proportionally allowAnimation:(BOOL)allowAnimation;
- (NSRect)drawRoundedInRect:(NSRect)rect radius:(CGFloat)radius;
- (NSRect)drawRoundedInRect:(NSRect)rect fraction:(CGFloat)inFraction radius:(CGFloat)radius;
- (NSRect)drawRoundedInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position fraction:(CGFloat)inFraction radius:(CGFloat)radius;
- (NSRect)drawInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position fraction:(CGFloat)inFraction;
- (NSRect)rectForDrawingInRect:(NSRect)rect atSize:(NSSize)size position:(IMAGE_POSITION)position;

@end