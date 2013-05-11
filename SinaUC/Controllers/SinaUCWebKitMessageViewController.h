//
//  SinaUCSinaUCWebKitMessageViewController.h
//  SinaUC
//
//  Created by css on 13-5-10.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SinaUCMessage, SinaUCWebKitDelegate, SinaUCWebView, SinaUCMessageStyle;

@interface SinaUCWebKitMessageViewController : NSObject {
    IBOutlet NSScrollView       *frameView;
	SinaUCWebKitDelegate		*delegateProxy;
	
	id							plugin;
	//AIChat						*chat;
	//BOOL						shouldReflectPreferenceChanges;
	//BOOL						isUpdatingWebViewForCurrentPreferences;
    
	//Content processing
	//AIContentObject				*previousContent;
	NSMutableArray				*contentQueue;
	NSMutableArray				*storedContentObjects;
	BOOL						webViewIsReady;
	BOOL						documentIsReady;	// Is DOM ready?
	
	//Style & Variant
	NSString					*activeStyle;
	NSString					*preferenceGroup;
	
	//User icon masking
	NSImage						*imageMask;
	NSMutableArray				*objectsWithUserIconsArray;
	NSMutableDictionary			*objectIconPathDict;
	
	//Focus tracking
	BOOL						nextMessageFocus;
	BOOL                        nextMessageRegainedFocus;
}

//@property (assign) IBOutlet NSWindow *window;

/*!
 *	@brief Create a new message view controller
 */
//+ (SinaUCWebKitMessageViewController *)messageDisplayControllerForChat:(AIChat *)inChat withPlugin:(AIWebKitMessageViewPlugin *)inPlugin;

/*!
 *	@brief Print the webview
 *
 *	WebView does not have a print method, and [[webView mainFrame] frameView] is implemented to print only the visible portion of the view.
 *	We have to get the scrollview and from there the documentView to have access to all of the webView.
 */
- (void)adiumPrint:(id)sender;

//Webview
/*!
 *	@return  the ESWebView which should be inserted into the message window
 */
@property (readonly, nonatomic) SinaUCWebView *messageView;
@property (readonly, nonatomic) NSView *messageScrollView;
@property (readonly, nonatomic) SinaUCMessageStyle *messageStyle;

/*!
 *	@brief Clears the view from displayed messages
 *
 *	Implements the method defined in protocol AIMessageDisplayController
 */
- (void)clearView;

/*!
 *	@brief Enable or disable updating to reflect preference changes
 *
 *	When disabled, the view will not update when a preferece changes that would require rebuilding the views content
 */
- (void)setShouldReflectPreferenceChanges:(BOOL)inValue;

/*!
 * @brief The HTML content for the "Chat" area.
 */
@property (readwrite, copy, nonatomic) NSString *chatContentSource;

- (void)enqueueContentObject:(SinaUCMessage *)msg;

@end
