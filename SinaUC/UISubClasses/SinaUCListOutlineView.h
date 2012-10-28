//
//  SinaUCListOutlineView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <SinaUCMultiCellOutlineView.h>
#import <SinaUCAbstractListController.h>
#import <SinaUCContactControllerProtocol.h>
#import <SInaUCListOutlineView+Drawing.h>

@class SinaUCListObject;

typedef enum {
	SinaUCNormalBackground = 0,
	SinaUCTileBackground,
	SinaUCFillProportionatelyBackground,
	SinaUCFillStretchBackground
} SinaUCBackgroundStyle;

@interface SinaUCListOutlineView : SinaUCMultiCellOutlineView <ContactListOutlineView> {
	BOOL				groupsHaveBackground;
	BOOL				updateShadowsWhileDrawing;
    
	NSImage				*backgroundImage;
	CGFloat				backgroundFade;
	BOOL				_drawBackground;
	AIBackgroundStyle	backgroundStyle;
	AIContactListWindowStyle windowStyle;
	
	NSColor				*backgroundColor;
	NSColor				*_backgroundColorWithOpacity;
	CGFloat				backgroundOpacity;
	
	NSColor				*highlightColor;
    
	NSColor				*rowColor;
	NSColor				*_rowColorWithOpacity;
	
	CGFloat				minimumDesiredWidth;
	BOOL	 			desiredHeightPadding;
    
	NSArray				*draggedItems;
}

@property (readonly, nonatomic) NSInteger desiredHeight;
@property (readonly, nonatomic) NSInteger desiredWidth;

// Contact menu
@property (weak, readonly, nonatomic) SinaUCListObject *listObject;
@property (weak, readonly, nonatomic) NSArray *arrayOfListObjects;
@property (weak, readonly, nonatomic) NSArray *arrayOfListObjectsWithGroups;
@property (weak, readonly, nonatomic) SinaUCListContact *firstVisibleListContact;

// Contacts

/*!
 * @brief Index of the first visible list contact
 *
 * @result The index, or -1 if no list contact is visible
 */
@property (readonly, nonatomic) int indexOfFirstVisibleListContact;

- (void)setMinimumDesiredWidth:(CGFloat)inMinimumDesiredWidth;
- (void)setDesiredHeightPadding:(int)inPadding;

@end

@interface SinaUCListOutlineView (SinaUCListOutlineView_Drawing)

@property (readwrite, nonatomic, retain) NSColor *backgroundColor;
@property (readwrite, nonatomic, retain) NSColor *highlightColor;
@property (readwrite, nonatomic, retain) NSColor *alternatingRowColor;

// Shadows
- (void)setUpdateShadowsWhileDrawing:(BOOL)update;

// Backgrounds
- (void)setBackgroundImage:(NSImage *)inImage;
- (void)setBackgroundStyle:(AIBackgroundStyle)inBackgroundStyle;
- (void)setBackgroundOpacity:(CGFloat)opacity forWindowStyle:(AIContactListWindowStyle)windowStyle;
- (void)setBackgroundFade:(CGFloat)fade;

@end

