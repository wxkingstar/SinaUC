//
//  SinaUCAlternatingRowOutlineView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-26.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCOutlineView.h"
#import "SinaUCGradientAdditions.h"
#import "SinaUCColorAdditions.h"

@interface SinaUCAlternatingRowOutlineView : SinaUCOutlineView <SinaUCAlternatingRowsProtocol> {
	NSColor		*alternatingRowColor;
	
	BOOL		drawsBackground;
	BOOL		drawsGradientSelection;
}

/*!
 * @brief The color used for drawing alternating row backgrounds.
 *
 * Ignored if usesAlternatingRowBackgroundColors is NO.
 */
@property (weak, readwrite, nonatomic) NSColor *alternatingRowColor;

/*!
 * @brief Whether the outlineView should draw its background
 *
 * If this is NO, no background will be drawn (this means that the alternating rows will not be drawn, either).  This is useful if cells wish to draw their own backgrounds.
 */
@property (readwrite, nonatomic) BOOL drawsBackground;

/*!
 * @brief Returns the <tt>NSColor</tt> which should be used to draw the background of the specified row
 *
 * @param row An integer row
 * @return An <tt>NSColor</tt> used to draw the background for <b>row</b>
 */
- (NSColor *)backgroundColorForRow:(NSInteger)row;

@property (readwrite, nonatomic) BOOL drawsGradientSelection;
@end

@interface SinaUCAlternatingRowOutlineView (PRIVATE_SinaUCAlternatingRowOutlineViewAndSubclasses)
- (void)_drawRowInRect:(NSRect)rect colored:(BOOL)colored selected:(BOOL)selected;
@end
