//
//  SinaUCWebView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface SinaUCWebView : WebView {
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
- (NSDragOperation)webView:(SinaUCWebView *)sender draggingEntered:(id <NSDraggingInfo>)info;
- (NSDragOperation)webView:(SinaUCWebView *)sender draggingUpdated:(id <NSDraggingInfo>)info;
- (NSDragOperation)webView:(SinaUCWebView *)sender draggingExited:(id <NSDraggingInfo>)info;
- (BOOL)webView:(SinaUCWebView *)sender performDragOperation:(id <NSDraggingInfo>)info;
- (BOOL)webView:(SinaUCWebView *)sender prepareForDragOperation:(id <NSDraggingInfo>)info;
- (void)webView:(SinaUCWebView *)sender concludeDragOperation:(id <NSDraggingInfo>)info;
- (BOOL)webView:(SinaUCWebView *)sender shouldHandleDragWithPasteboard:(NSPasteboard *)pasteboard;
@end