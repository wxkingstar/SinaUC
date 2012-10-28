//
//  SinaUCListOutlineView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCListOutlineView.h"
#import "SinaUCContactController.h"
#import <SinaUCInterfaceControllerProtocol.h>
#import <SinaUCListCell.h>
#import <SinaUCListOutlineView.h>
#import <SinaUCListGroup.h>
#import <SinaUCListContact.h>
#import <SinaUCProxyListObject.h>
#import <SinaUCWindowAdditions.h>
#import <SinaUCOutlineViewAdditions.h>
#import <SinaUCBezierPathAdditions.h>
#import <SinaUCEventAdditions.h>
#import "SinaUCSCLViewPlugin.h"

@interface SinaUCListOutlineView ()

- (void)SinaUC_initListOutlineView;

@end

x
+ (void)initialize
{
	if (self != [SinaUCListOutlineView class]) {
		return;
	}
    
	[self exposeBinding:@"desiredHeight"];
	[self exposeBinding:@"totalHeight"];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
	NSSet *superSet = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"desiredHeight"]) {
		return [superSet setByAddingObject:@"totalHeight"];
	}
    
	return superSet;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
		[self SinaUC_initListOutlineView];
	}
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		[self SinaUC_initListOutlineView];
		[self registerForDraggedTypes:[NSArray arrayWithObjects:@"SinaUCListContact",@"SinaUCListObject",nil]];
	}
    
	return self;
}

- (void)SinaUC_initListOutlineView
{
	updateShadowsWhileDrawing = NO;
	
	backgroundImage = nil;
	backgroundFade = 1.0f;
	backgroundColor = nil;
	backgroundStyle = SinaUCNormalBackground;
    
	[self setDrawsGradientSelection:YES];
	[self sizeLastColumnToFit];
    
	groupsHaveBackground = NO;
	
	[adium.preferenceController registerPreferenceObserver:self forGroup:PREF_GROUP_LIST_THEME];
}

- (void)dealloc
{
	[adium.preferenceController unregisterPreferenceObserver:self];
	
	[self unregisterDraggedTypes];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)preferencesChangedForGroup:(NSString *)group
key:(NSString *)key
object:(SinaUCListObject *)object
preferenceDict:(NSDictionary *)prefDict
firstTime:(BOOL)firstTime
{
	groupsHaveBackground = [[prefDict objectForKey:KEY_LIST_THEME_GROUP_GRADIENT] boolValue];
}

// Keep our column full width
- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	[self sizeLastColumnToFit];
}

/*!
 * @brief Should we perform type select next/previous on find?
 *
 * @return YES to switch between type-select results. NO to to switch within the responder chain.
 */
- (BOOL)tabPerformsTypeSelectFind
{
	return YES;
}

- (void)cancelOperation:(id)sender
{
	[self deselectAll:nil];
}

#pragma mark Sizing

/*!
 * @brief Get the desired height for the outline view
 *
 * This includes content and desiredHeightPadding
 */
- (NSInteger)desiredHeight
{
	return ([self totalHeight] + desiredHeightPadding);
}

/*!
 * @brief Add padding to the desired height
 */
- (void)setDesiredHeightPadding:(int)inPadding
{
	desiredHeightPadding = inPadding;
}

/*!
 * @brief Get the desired width for the outline view
 *
 * This includes content; minimumDesiredWidth is respected
 */
- (NSInteger)desiredWidth
{
	NSInteger	row;
	NSInteger	numberOfRows = [self numberOfRows];
	CGFloat		widestCell = 0;
	id			theDelegate = self.delegate;
	
	// Enumerate all rows, find the widest one
	for (row = 0; row < numberOfRows; row++) {
		id		item = [self itemAtRow:row];
		NSCell	*cell = ([theDelegate outlineView:self isGroup:item] ? groupCell : contentCell);
        
		[theDelegate outlineView:self willDisplayCell:cell forTableColumn:nil item:item];
		CGFloat	width = [(SinaUCListCell *)cell cellWidth];
		
		if (width > widestCell) {
			widestCell = width;
		}
	}
    
	return ((widestCell > minimumDesiredWidth) ? widestCell : minimumDesiredWidth);
}

/*!
 * @brief Set the minimum desired width reported by -[self desiredWidth]
 */
- (void)setMinimumDesiredWidth:(CGFloat)inMinimumDesiredWidth
{
	minimumDesiredWidth = inMinimumDesiredWidth;
}

#pragma mark List object access

/*!
 * @brief Return the selected object (to auto-configure the contact menu)
 */
- (SinaUCListObject *)listObject
{
    NSInteger selectedRow = [self selectedRow];
    
    if (selectedRow >= 0 && selectedRow < [self numberOfRows]) {
        return ((SinaUCProxyListObject *)[self itemAtRow:selectedRow]).listObject;
    } else {
        return nil;
    }
}

- (NSArray *)arrayOfListObjects
{
	NSMutableArray *array = [NSMutableArray array];
	for (SinaUCProxyListObject *proxyObject in self.arrayOfSelectedItems) {
		[array addObject:proxyObject.listObject];
	}
	
	return array;
}

- (NSArray *)arrayOfListObjectsWithGroups
{
	NSMutableArray *array = [NSMutableArray array];
	for (SinaUCProxyListObject *proxyObject in self.arrayOfSelectedItems) {
		[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:proxyObject.listObject, @"ListObject",
						  proxyObject.containingObject, @"ContainingObject", nil]];
	}
	
	return array;
}

- (SinaUCListContact *)firstVisibleListContact
{
	SinaUCInteger numberOfRows = [self numberOfRows];
	for (unsigned i = 0; i <numberOfRows ; i++) {
		SinaUCProxyListObject *item = [self itemAtRow:i];
		if ([item isKindOfClass:[SinaUCListContact class]]) {
			return (SinaUCListContact *)item.listObject;
		}
	}
    
	return nil;
}

- (int)indexOfFirstVisibleListContact
{
	NSInteger numberOfRows = [self numberOfRows];
	for (unsigned i = 0; i <numberOfRows ; i++) {
		if ([[self itemAtRow:i] isKindOfClass:[SinaUCListContact class]]) {
			return i;
		}
	}
	
	return -1;
}

#pragma mark Group expanding

/*!
 * @brief Expand or collapses groups on mouse down
 */
- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint	viewPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSInteger row = [self rowAtPoint:viewPoint];
	id item = [self itemAtRow:row];
	
	// Let super handle it if it's not a group, or the command key is down (dealing with selection)
	// Allow clickthroughs for triangle disclosure only.
	if (![item isKindOfClass:[SinaUCListGroup class]] || [NSEvent cmdKey] || ![[self window] isKeyWindow]) {
		[super mouseDown:theEvent];
		return;
	}
	
	// Wait for the next event
	NSEvent *nextEvent = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSPeriodicMask)
													untilDate:[NSDate distantFuture]
													   inMode:NSEventTrackingRunLoopMode
													  dequeue:NO];
	
	// Only expand/contract if they release the mouse. Otherwise pass on the goods.
	switch ([nextEvent type]) {
		case NSLeftMouseUp:
			if ([self isItemExpanded:item]) {
				[self collapseItem:item];
			} else {
				[self expandItem:item];
			}
			
			/* If the disclosure triangle was not the click-point, select the row.
			 *
			 * We use the approximation that the height of the row is about the same widht
			 * as the disclosure triangle.
			 */
            if (viewPoint.x >= NSHeight([self frameOfCellAtColumn:0 row:row]))
                [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
            break;
		case NSLeftMouseDragged:
			[super mouseDown:theEvent];
			[super mouseDragged:nextEvent];
			break;
		default:
			[super mouseDown:theEvent];
			break;
	}
}

#pragma mark Drag & Drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	// From previous implementation - still needed?
	[[sender draggingDestinationWindow] makeKeyAndOrderFront:self];
    
	return [super draggingEntered:sender];
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
	return (NSDragOperationCopy | NSDragOperationMove | NSDragOperationPrivate);
}

- (BOOL)shouldCollapseAutoExpandedItemsForDeposited:(BOOL)deposited
{
	return YES;
}

#pragma mark Copying selected objects via the data source

- (IBAction)copy:(id)sender
{
	id dataSource = [self dataSource];
    
	if (dataSource) {
		NSIndexSet *selection = [self selectedRowIndexes];
        
		NSMutableArray *items = [NSMutableArray arrayWithCapacity:[selection count]];
		for (NSUInteger idx = [selection firstIndex]; idx <= [selection lastIndex]; idx = [selection indexGreaterThanIndex:idx]) {
			[items addObject:[self itemAtRow:idx]];
		}
        
		[dataSource outlineView:self
	                 writeItems:items
	               toPasteboard:[NSPasteboard generalPasteboard]];
	}
}

#pragma mark Menu items

- (BOOL) validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
	if ([anItem action] == @selector(copy:))
		return [self numberOfSelectedRows] > 0;
	else
		return [super validateUserInterfaceItem:anItem];
}

#pragma mark Accessibility
#if ACCESSIBILITY_DEBUG

- (NSArray *)accessibilityAttributeNames
{
	SinaUCLogWithSignature(@"names: %@", [super accessibilityAttributeNames]);
	return [super accessibilityAttributeNames];
}

- (id)accessibilityAttributeValue:(NSString *)attribute
{
	SinaUCLogWithSignature(@"%@ -> %@", attribute, [super accessibilityAttributeValue:attribute]);
	return [super accessibilityAttributeValue:attribute];
	
}

#endif

@end
