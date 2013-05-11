//
//  ESWebView.h
//  SinaUC
//
//  Created by css on 13-5-10.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface ESWebView : WebView {
    id		draggingDelegate;
	BOOL	allowsDragAndDrop;
	BOOL	shouldForwardEvents;
	BOOL	transparentBackground;
}

/*!
 *	@brief Sets background transparency on/off
 */
- (void)setTransparent:(BOOL)flag;

/*!
 *	@brief Sets the font family used in webkit's preferences for adium
 */
- (void)setFontFamily:(NSString *)familyName;

/*!
 *	@brief Gets the font family used in webkit's preferences for adium
 */
- (NSString *)fontFamily;

/*!
 *	@brief Sets the delegate used for drag and drop operations
 */
- (void)setDraggingDelegate:(id)inDelegate;

/*!
 *	@brief Sets whether drag and drop is allowed
 */
- (void)setAllowsDragAndDrop:(BOOL)flag;

/*!
 *	@brief ???
 */
- (void)setShouldForwardEvents:(BOOL)flag;

@end

@interface NSObject (ESWebViewDragDelegate)
- (NSDragOperation)webView:(ESWebView *)sender draggingEntered:(id <NSDraggingInfo>)info;
- (NSDragOperation)webView:(ESWebView *)sender draggingUpdated:(id <NSDraggingInfo>)info;
- (NSDragOperation)webView:(ESWebView *)sender draggingExited:(id <NSDraggingInfo>)info;
- (BOOL)webView:(ESWebView *)sender performDragOperation:(id <NSDraggingInfo>)info;
- (BOOL)webView:(ESWebView *)sender prepareForDragOperation:(id <NSDraggingInfo>)info;
- (void)webView:(ESWebView *)sender concludeDragOperation:(id <NSDraggingInfo>)info;
- (BOOL)webView:(ESWebView *)sender shouldHandleDragWithPasteboard:(NSPasteboard *)pasteboard;

@end
