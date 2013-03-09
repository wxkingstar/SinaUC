//
//  SinaUCWebKitDelegate.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCWebKitDelegate.h"
//#import "SinaUCWebKitMessageViewController.h"
#import "SinaUCWebView.h"
//#import "AIURLHandlerPlugin.h"
//#import "AIEventAdditions.h"
//#import "AIAdiumURLProtocol.h"

static SinaUCWebKitDelegate *sharedWebKitDelegate;

/*@interface SinaUCWebKitMessageViewController (DelegateCallbacks)
- (void)webViewIsReady;
@end*/

@implementation SinaUCWebKitDelegate

- (id)init
{
	if ((self = [super init]))  {
		mapping = [[NSMutableDictionary alloc] init];
		
		//[NSURLProtocol registerClass:[AIAdiumURLProtocol class]];
		[SinaUCWebView registerURLSchemeAsLocal:@"adium"];
	}
	return self;
}

+ (SinaUCWebKitDelegate *)sharedWebKitDelegate
{
	if(!sharedWebKitDelegate)
		sharedWebKitDelegate = [[self alloc] init];
	return sharedWebKitDelegate;
}

- (void) addDelegate:(SinaUCWebKitMessageViewController *)controller forView:(SinaUCWebView *)webView
{
	[mapping setObject:controller forKey:[NSValue valueWithPointer:(__bridge void *)webView]];
	
	[webView setFrameLoadDelegate:self];
	[webView setPolicyDelegate:self];
	[webView setUIDelegate:self];
	[webView setDraggingDelegate:self];
	[webView setEditingDelegate:self];
	[webView setResourceLoadDelegate:self];
	
    //	[[webView windowScriptObject] setValue:self forKey:@"client"];
}
- (void) removeDelegate:(SinaUCWebKitMessageViewController *)controller
{
	SinaUCWebView *webView = (SinaUCWebView *)[controller messageView];
	
	[webView setFrameLoadDelegate:nil];
	[webView setPolicyDelegate:nil];
	[webView setUIDelegate:nil];
	[webView setDraggingDelegate:nil];
	[webView setEditingDelegate:nil];
	[webView setResourceLoadDelegate:nil];
	
	[mapping removeObjectForKey:[NSValue valueWithPointer:(__bridge void *)webView]];
}

//WebView Delegates ----------------------------------------------------------------------------------------------------
#pragma mark Webview delegates
/*!
 * @brief Invoked once the webview has loaded and is ready to accept content
 */
- (void)webView:(SinaUCWebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	if(controller) {
		//Flag the view as ready (as soon as the current methods exit) so we know it's now safe to add content
		[controller performSelector:@selector(webViewIsReady) withObject:nil afterDelay:0];
	}
	
	//We don't care about any further didFinishLoad notifications
	[sender setFrameLoadDelegate:nil];
}

/*!
 * @brief Prevent the webview from following external links.  We direct these to the user's web browser.
 */
- (void)webView:(SinaUCWebView *)sender
decidePolicyForNavigationAction:(NSDictionary *)actionInformation
		request:(NSURLRequest *)request
		  frame:(WebFrame *)frame
decisionListener:(id<WebPolicyDecisionListener>)listener
{
    NSInteger actionKey = [[actionInformation objectForKey: WebActionNavigationTypeKey] integerValue];
    if (actionKey == WebNavigationTypeOther) {
		[listener use];
	} else if ([[((__bridge_transfer NSString *)LSCopyDefaultHandlerForURLScheme((__bridge CFStringRef)request.URL.scheme)) lowercaseString] isEqualToString:@"com.adiumx.adiumx"]) {
		// We're the default for this URL, let's open it ourself.
		[[NSNotificationCenter defaultCenter] postNotificationName:@"AIURLHandleNotification" object:request.URL.absoluteString];
		
		[listener ignore];
    } else {
		NSURL *url = [actionInformation objectForKey:WebActionOriginalURLKey];
		
		//Ignore file URLs, but open anything else
		if (![url isFileURL]) {
			/*if ([NSEvent cmdKey]) {
				NSArray *urls = [NSArray arrayWithObject:url];
				
				[[NSWorkspace sharedWorkspace] openURLs:urls
								withAppBundleIdentifier:nil
												options:NSWorkspaceLaunchWithoutActivation
						 additionalEventParamDescriptor:nil
									  launchIdentifiers:nil];
			} else {
				[[NSWorkspace sharedWorkspace] openURL:url];
			}*/
		}
		
		[listener ignore];
    }
}


/*!
 * @brief Append our own menu items to the webview's contextual menus
 
- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	if(controller)
		return [controller webView:sender contextMenuItemsForElement:element defaultMenuItems:defaultMenuItems];
	return defaultMenuItems;
}*/

/*!
 * @brief Announce when the window script object is available for modification
 
- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	if(controller)
        [controller webView:sender didClearWindowObject:windowObject forFrame:frame];
}*/

/*!
 * @brief Dragging entered
 
- (NSDragOperation)webView:(SinaUCWebView *)sender draggingEntered:(id <NSDraggingInfo>)info
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
    
	return controller ? [controller draggingEntered:info] : NSDragOperationNone;
}*/

/*!
 * @brief Dragging updated
 
- (NSDragOperation)webView:(SinaUCWebView *)sender draggingUpdated:(id <NSDraggingInfo>)info
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	return controller ? [controller draggingUpdated:info] : NSDragOperationNone;
}*/

/*!
 * @brief Handle a drag onto the webview
 *
 * If we're getting a non-image file, we can handle it immediately.  Otherwise, the drag is the textView's problem.
 
- (BOOL)webView:(SinaUCWebView *)sender performDragOperation:(id <NSDraggingInfo>)info
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	return controller ? [controller performDragOperation:info] : NO;
}*/

/*!
 * @brief Pass on the prepareForDragOperation if it's not one we're handling in this class
 
- (BOOL)webView:(SinaUCWebView *)sender prepareForDragOperation:(id <NSDraggingInfo>)info
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	return controller ? [controller prepareForDragOperation:info] : NO;
}*/

/*!
 * @brief Pass on the concludeDragOperation if it's not one we're handling in this class
 
- (void)webView:(SinaUCWebView *)sender concludeDragOperation:(id <NSDraggingInfo>)info
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	if(controller)
		[controller concludeDragOperation:info];
}

- (BOOL)webView:(SinaUCWebView *)sender shouldHandleDragWithPasteboard:(NSPasteboard *)pasteboard
{
	//AIWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:sender]];
	//return controller ? [controller shouldHandleDragWithPasteboard:pasteboard] : NO;
	return NO;
}

- (BOOL)webView:(SinaUCWebView *)sender shouldInsertText:(NSString *)text replacingDOMRange:(DOMRange *)range givenAction:(WebViewInsertAction)action
{
	if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound) {
		SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
		if(controller)
			[controller editingDidComplete:range];
		
		// The user pressed return; don't let it be entered into the text.
		return NO;
	} else {
		return YES;
	}
}

- (BOOL)webView:(SinaUCWebView *)sender shouldEndEditingInDOMRange:(DOMRange *)range
{
	SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(__bridge void *)sender]];
	if(controller)
		[controller editingDidComplete:range];
	
	return YES;
}

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
	NSMutableURLRequest *newRequest = [request mutableCopy];
	[newRequest setHTTPShouldHandleCookies:NO];
	return newRequest;
}*/
@end

