//
//  SinaUCOutlineView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-26.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCOutlineViewAdditions.h"

#define SinaUCOutlineViewUserDidExpandItemNotification		@"SinaUCOutlineViewUserDidExpandItemNotification"
#define SinaUCOutlineViewUserDidCollapseItemNotification	@"SinaUCOutlineViewUserDidCollapseItemNotification"

/*!
 * @protocol AIOutlineViewDelegate
 * @brief Delegate protocol for <tt>AIOutlineView</tt>
 *
 * Implementation of all methods is optional.
 */
@protocol SinaUCOutlineViewDelegate <NSOutlineViewDelegate, NSOutlineViewDataSource>
@optional
/*!
 * @brief Requests a contextual menu for an event from the delegate
 *
 * This delegate method gives the delegate an opportunity to return an <tt>NSMenu</tt> to be displayed when the user right-clicks (control-clicks) in the outline view.  The passed event can be used to determine where the click occurred to make the menu sensitive to which row or column was clicked.
 * @param outlineView The <tt>NSOutlineView</tt> which was clicked
 * @param theEvent The event of the click
 * @return An <tt>NSMenu</tt> to be displayed, or nil if no menu should be displayed
 */
- (NSMenu *)outlineView:(NSOutlineView *)outlineView menuForEvent:(NSEvent *)theEvent;

/*!
 * outlineView:setExpandState:ofItem:
 * @brief Informs the delegate that the item was collapsed or exapnded
 *
 * This delegate method informs the delegate that the item was collapsed or expanded.
 * @param outlineView The <tt>NSOutlineView</tt> which was changed
 * @param state YES if the item is now expanded; NO if it is no collapsed
 * @param item The item which was changed
 */
- (void)outlineView:(NSOutlineView *)outlineView setExpandState:(BOOL)state ofItem:(id)item;

/*!
 * @brief Requests the correct expanded state for an item
 *
 * After reloading data, NSOutlineView collapses all items, which is generally not a desired behavior.  <tt>AIOutlineView</tt> provides the delegate an opportunity to specify whether each item should be exapnded or collapsed after a reload. This delegate method should return the correct expanded state of the passed item.
 * @param outlineView The <tt>NSOutlineView</tt> which is reloading data
 * @param item The item whose expanded state is requested
 * @return YES if the item should be expanded; NO if it should be collapsed
 */
- (BOOL)outlineView:(NSOutlineView *)outlineView expandStateOfItem:(id)item;

/*!
 * @brief Informs the delegate of a request to delete the selected rows
 *
 * Informs the delegate of a request to delete the selected rows (via the delete key, generally). The delegate may wish to retrieve the currently selected rows and remove them from the data source and subsequently reload the outline view.
 * @param outlineView The <tt>NSOutlineView</tt> from which the user wants to delete one or more rows.
 */
- (void)outlineViewDeleteSelectedRows:(NSOutlineView *)outlineView;

/*!
 * @brief Passes on NSObject's <tt>draggedImage:endedAt:operation:</tt> to the delegate
 *
 * Passes on NSObject's <tt>draggedImage:endedAt:operation:</tt>, which is invoked in the dragging source as the drag ends,
 * to the delegate.  See <tt>NSObject</tt>'s documentation for more details.
 *
 * @param outlineView The <tt>NSOutlineView</tt> which ended the drag
 * @param image The <tt>NSImage</tt> drag image
 * @param screenPoint An <tt>NSPoint</tt> in screen coordinates
 * @param operation The <tt>NSDragOperation</tt> of the drag
 */
- (void)outlineView:(NSOutlineView *)outlineView draggedImage:(NSImage *)image endedAt:(NSPoint)screenPoint operation:(NSDragOperation)operation;

/*!
 * @brief Informs the delegate of a request to show or hide the fine panel
 *
 * Informs the delegate of a request to show the find panel if it is hidden, and hide it if shown. The delegate must implement the find panel UI and filtering
 * @param outlineView The <tt>NSOutlineView</tt> that the user wants to filter
 */
- (void)outlineViewToggleFindPanel:(NSOutlineView *)outlineView;


/*!
 * @brief Informs the delegate of a request to forward a key down event to the find panel text field, displaying it if necessary
 *
 * Informs the delegate of a request to forward a key down event to the find panel text field,displaying it if necessary. The key down event was recieved by outlineView, and it determined it should be added to the search string
 * @param outlineView The <tt>NSOutlineView</tt> that the user wants to filter
 * @param theEvent The key down event
 *
 * @result YES if the find panel handled theEvent. If NO, outlineView will forward theEvent to super for handling
 */
- (BOOL)outlineView:(NSOutlineView *)outlineView forwardKeyEventToFindPanel:(NSEvent *)theEvent;

@end

/*!
 * @protocol AIAlternatingRowsProtocol
 * @brief Delegate protocol for <tt>AIOutlineView</tt>
 *
 * Implementation of all methods is optional.
 */
@protocol SinaUCAlternatingRowsProtocol

/*!
 * @brief Draws rows of the view with alternating colors
 *
 * @param rect The <tt>NSRect</tt> defining the background to color.
 */
- (void)drawAlternatingRowsInRect:(NSRect)rect;
@end

@interface SinaUCOutlineView : NSOutlineView {
    BOOL needsReload;
	BOOL ignoreExpandCollapse;
}

- (void)performFindPanelAction:(id)sender;

@end
