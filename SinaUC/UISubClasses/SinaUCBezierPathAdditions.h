//
//  SinaUCBezierPathAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//


@interface NSBezierPath (SinaUCBezierPathAdditions)

#pragma mark Rounded rectangles

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathRoundedRectOfSize:(NSSize)backgroundSize;
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)bounds;
+ (NSBezierPath *)bezierPathWithRoundedTopCorners:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRoundedBottomCorners:(NSRect)rect radius:(CGFloat)radius;

#pragma mark Arrows

/* default metrics of the arrow (as returned by +bezierPathWithArrow):
 *    ^
 *   / \
 *  /   \
 * /_   _\ ___
 *   | |    | shaft length multiplier:
 *   | |    | 1.0
 *   | |    | equals shaft length:
 *   |_|   _|_0.5
 *
 *   default shaft width: 1/3
 * the bounds of this arrow are { { 0, 0 }, { 1, 1 } }.
 *
 * the other three methods allow you to override either or both of these metrics.
 */
+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti shaftWidth:(CGFloat)shaftWidth;
+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti;
+ (NSBezierPath *)bezierPathWithArrowWithShaftWidth:(CGFloat)shaftWidth;
+ (NSBezierPath *)bezierPathWithArrow;

#pragma mark Nifty things

//these three are in-place. they return self, so that you can do e.g. [[NSBezierPath bezierPathWithArrow] flipVertically].
- (NSBezierPath *)flipHorizontally;
- (NSBezierPath *)flipVertically;
- (NSBezierPath *)scaleToSize:(NSSize)newSize;

//these three return an autoreleased copy.
- (NSBezierPath *)bezierPathByFlippingHorizontally;
- (NSBezierPath *)bezierPathByFlippingVertically;
- (NSBezierPath *)bezierPathByScalingToSize:(NSSize)newSize;

@end

