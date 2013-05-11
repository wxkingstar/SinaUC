//
//  SinaUCWebKitDelegate.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCWebKitDelegate.h"
#import "SinaUCWebKitMessageViewController.h"
#import "SinaUCWebView.h"
#import "SinaUCURLProtocol.h"
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
		[NSURLProtocol registerClass:[SinaUCURLProtocol class]];
		[SinaUCWebView registerURLSchemeAsLocal:@"sinauc"];
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
 * @brief Announce when the window script object is available for modification
 */
- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame {
    SinaUCWebKitMessageViewController *controller = [mapping objectForKey:[NSValue valueWithPointer:(void *)sender]];
	if(controller)
        [controller webView:sender didClearWindowObject:windowObject forFrame:frame];
}

@end

