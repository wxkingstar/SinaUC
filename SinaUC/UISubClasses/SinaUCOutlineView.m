//
//  SinaUCOutlineView.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-26.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCOutlineView.h"

@interface SinaUCOutlineView ()
- (void)_initOutlineView;
- (void)expandOrCollapseItemsOfItem:(id)rootItem;
- (void)_reloadData;
@end

@interface SinaUCOutlineView (KFTypeSelectTableViewSupport)
- (void)findPrevious:(id)sender;
- (void)findNext:(id)sender;
@end

@implementation SinaUCOutlineView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initOutlineView];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect])) {
		[self _initOutlineView];
	}
	return self;
}

- (void)_initOutlineView
{
    
}

- (void)performFindPanelAction:(id)sender;
{
	if ([[self delegate] respondsToSelector:@selector(outlineViewToggleFindPanel:)]) {
		[(id<SinaUCOutlineViewDelegate>)[self delegate] outlineViewToggleFindPanel:self];
	}
}

- (void)expandItem:(id)item expandChildren:(BOOL)expandChildren
{
	[super expandItem:item expandChildren:expandChildren];
    
	if (!ignoreExpandCollapse) {
		//General expand notification
		[[NSNotificationCenter defaultCenter] postNotificationName:SinaUCOutlineViewUserDidExpandItemNotification
															object:self
														  userInfo:[NSDictionary dictionaryWithObject:item forKey:@"contacts"]];
        
		//Inform our delegate directly
		if ([[self delegate] respondsToSelector:@selector(outlineView:setExpandState:ofItem:)]) {
			[(id<SinaUCOutlineViewDelegate>)[self delegate] outlineView:self setExpandState:YES ofItem:item];
		}
	}
}

- (void)collapseItem:(id)item collapseChildren:(BOOL)collapseChildren
{
	[super collapseItem:item collapseChildren:collapseChildren];
    
	if (!ignoreExpandCollapse) {
		//General expand notification
		[[NSNotificationCenter defaultCenter] postNotificationName:SinaUCOutlineViewUserDidCollapseItemNotification
															object:self
														  userInfo:[NSDictionary dictionaryWithObject:item forKey:@"contacts"]];
        
		//Inform our delegate directly
		if ([[self delegate] respondsToSelector:@selector(outlineView:setExpandState:ofItem:)]) {
			[(id<SinaUCOutlineViewDelegate>)[self delegate] outlineView:self setExpandState:NO ofItem:item];
		}
	}
}

- (void)reloadData
{
	/* This code is to correct what I consider a bug with NSOutlineView.
     Basically, if reloadData is called from 'outlineView:setObjectValue:forTableColumn:byItem:' while the last
     row is edited in a way that will reduce the # of rows in the table view, things will crash within system code.
     This crash is evident in many versions of Adium.  When renaming the last contact on the contact list to the name
     of a contact who already exists on the list, Adium will delete the original contact, reducing the # of rows in
     the outline view in the midst of the cell editing, causing the crash.  The fix is to delay reloading until editing
     of the last row is complete.  As an added benefit, we skip the delayed reloading if the outline view had been
     reloaded since the edit, and the reload is no longer necessary.
     */
    if ([self numberOfRows] != 0 && ([self editedRow] == [self numberOfRows] - 1) && !needsReload) {
        needsReload = YES;
        [self performSelector:@selector(_reloadData) withObject:nil afterDelay:0.0001];
        
    } else {
        needsReload = NO;
        
		[super reloadData];
		
		[self expandOrCollapseItemsOfItem:nil];
	}
}

- (void)expandOrCollapseItemsOfItem:(id)rootItem
{
	//After reloading data, we correctly expand/collapse all groups
	if ([[self delegate] respondsToSelector:@selector(outlineView:expandStateOfItem:)]) {
		id<SinaUCOutlineViewDelegate>   delegate = (id<SinaUCOutlineViewDelegate>)[self delegate];
		NSInteger 	numberOfRows = [delegate outlineView:self numberOfChildrenOfItem:rootItem];
		NSInteger 	row;
		
		//go through all items
		for (row = 0; row < numberOfRows; row++) {
			id item = [delegate outlineView:self child:row ofItem:rootItem];
            
			//If the item is expandable, correctly expand/collapse it
			if (item && [delegate outlineView:self isItemExpandable:item]) {
				ignoreExpandCollapse = YES;
				if ([delegate outlineView:self expandStateOfItem:item]) {
					[self expandItem:item];
					[self expandOrCollapseItemsOfItem:item];
				} else {
					[self collapseItem:item];
				}
				ignoreExpandCollapse = NO;
			}
		}
	}
}

- (void)_reloadData{
    if (needsReload) [self reloadData];
}

//Preserve selection through a reload
- (void)reloadItem:(id)item reloadChildren:(BOOL)reloadChildren
{
	NSArray		*selectedItems = [self arrayOfSelectedItems];
    
	[super reloadItem:item reloadChildren:reloadChildren];
    
	//Restore (if possible) the previously selected object
	[self selectItemsInArray:selectedItems];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint	viewPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSInteger row = [self rowAtPoint:viewPoint];
	id item = [self itemAtRow:row];
	
	// Let super handle it if it's not a group, or the command key is down (dealing with selection)
	// Allow clickthroughs for triangle disclosure only.
	//if (![item objectForKey:@"contacts"] || [NSEvent cmdKey] || ![[self window] isKeyWindow]) {
    if (![item objectForKey:@"contacts"] || ![[self window] isKeyWindow]) {
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
            /*if (viewPoint.x >= NSHeight([self frameOfCellAtColumn:0 row:row]))
             [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO]; */
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


@end
