//
//  SinaUCSinaUCWebKitMessageViewController.m
//  SinaUC
//
//  Created by css on 13-5-10.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import "SinaUCWebKitMessageViewController.h"
#import "SinaUCWebKitDelegate.h"
#import "SinaUCWebView.h"
#import "SinaUCMessage.h"
#import "SinaUCMessageStyle.h"
#import "SinaUCWebKitDelegate.h"

#define NEW_CONTENT_RETRY_DELAY					0.01

@implementation NSString (AIStringAdditions)

#define BUNDLE_STRING	@"$$BundlePath$$"
- (NSString *)stringByExpandingBundlePath
{
    if ([self hasPrefix:BUNDLE_STRING]) {
        return [[[[NSBundle mainBundle] bundlePath] stringByExpandingTildeInPath] stringByAppendingString:[self substringFromIndex:[BUNDLE_STRING length]]];
    } else {
        return [self copy];
    }
}

+ (id)stringWithContentsOfUTF8File:(NSString *)path
{
	if (!path) return nil;
	NSString	*string;
	NSError	*error = nil;
	string = [self stringWithContentsOfFile:path
								   encoding:NSUTF8StringEncoding
									  error:&error];
	if (error) {
		BOOL	handled = NO;
		if ([[error domain] isEqualToString:NSCocoaErrorDomain]) {
			NSInteger		errorCode = [error code];
			if (errorCode == NSFileReadNoSuchFileError) {
				string = nil;
				handled = YES;
			} else if (errorCode == NSFileReadInapplicableStringEncodingError) {
				NSError				*newError = nil;
				string = [self stringWithContentsOfFile:path
											   encoding:NSASCIIStringEncoding
												  error:&newError];
				//If there isn't a new error, we recovered reasonably successfully...
				if (!newError) {
					handled = YES;
				}
			}
		}
		if (!handled) {
			NSLog(@"Error reading %@:\n%@; %@.",path,
				  [error localizedDescription], [error localizedFailureReason]);
		}
	}
	return string;
}

@end

@implementation NSBundle (StupidCompatibilityHack)
- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type
{
	NSString *path = [self pathForResource:res ofType:type];
	if(!path)
		path = [self pathForResource:[res lowercaseString] ofType:type];
	return path;
}

- (NSString *)semiCaseInsensitivePathForResource:(NSString *)res ofType:(NSString *)type inDirectory:(NSString *)dirpath
{
	NSString *path = [self pathForResource:res ofType:type inDirectory:dirpath];
	if(!path)
		path = [self pathForResource:[res lowercaseString] ofType:type inDirectory:dirpath];
	return path;
}

@end

@implementation SinaUCWebKitMessageViewController

@synthesize messageStyle, messageView=webView;

- (void)awakeFromNib
{
    [self _initWebView];
}

- (void)_initWebView
{
	//Create our webview
    contentQueue =  [[NSMutableArray alloc] init];
	webView = [[SinaUCWebView alloc] initWithFrame:NSMakeRect(0,100,450,300) //Arbitrary frame
									 frameName:nil
									 groupName:nil];
	[webView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [webView setMaintainsBackForwardList:NO];
    [webView setDrawsBackground:NO];
    delegateProxy = [SinaUCWebKitDelegate sharedWebKitDelegate];
	[delegateProxy addDelegate:self forView:webView];
    NSURL *baseURL = [NSURL URLWithString:@"sinauc://im.adium.Renkoo.style/adium"];
    NSString *tplPath = [[NSString alloc] initWithString:@"$$BundlePath$$/Contents/Resources"];
    NSBundle *tplBundle = [NSBundle bundleWithPath:[tplPath stringByExpandingBundlePath]];
    NSString *stylePath = [[NSString alloc] initWithString:@"$$BundlePath$$/Contents/Resources/message style/Renkoo.AdiumMessageStyle"];
    NSBundle *styleBundle = [NSBundle bundleWithPath:[stylePath stringByExpandingBundlePath]];
    NSString* baseHTML = [NSString stringWithContentsOfUTF8File:[tplBundle semiCaseInsensitivePathForResource:@"Template" ofType:@"html"]];
    
    NSMutableString	*templateHTML;
    templateHTML = [NSMutableString stringWithFormat:baseHTML,						//Template
                    [[NSURL fileURLWithPath:[styleBundle resourcePath]] absoluteString],				//Base path
                    @"@import url( \"main.css\" );",                                //Import main.css for new enough styles
                    @"Variants/Blue on Green Alternating.css",						//Variant path
                    @"",
                    @""];
    [[webView mainFrame] loadHTMLString:templateHTML baseURL:baseURL];
    [frameView setDocumentView:webView];
    [[frameView documentView] setFrame:[frameView visibleRect]];
        
	/*if (!draggedTypes) {
     draggedTypes = [[NSArray alloc] initWithObjects:
     NSFilenamesPboardType,
     AIiTunesTrackPboardType,
     NSTIFFPboardType,
     NSPDFPboardType,
     NSHTMLPboardType,
     NSFileContentsPboardType,
     NSRTFPboardType,
     NSStringPboardType,
     NSPostScriptPboardType,
     nil];
     }
     [webView registerForDraggedTypes:draggedTypes];*/
}


/*- (void)setupMarkedScroller
 {
 WebFrame *contentFrame = [[webView mainFrame] findFrameNamed:@"_current"];
 NSScrollView *scrollView = [[[contentFrame frameView] documentView] enclosingScrollView];
 
 [scrollView setHasHorizontalScroller:NO];
 
 JVMarkedScroller *scroller = (JVMarkedScroller *)[scrollView verticalScroller];
 if( scroller && ! [scroller isMemberOfClass:[JVMarkedScroller class]] ) {
 NSRect scrollerFrame = [[scrollView verticalScroller] frame];
 NSScroller *oldScroller = scroller;
 scroller = [[JVMarkedScroller alloc] initWithFrame:scrollerFrame];
 [scroller setFloatValue:oldScroller.floatValue];
 [scroller setKnobProportion:oldScroller.knobProportion];
 [scrollView setVerticalScroller:scroller];
 }
 }*/

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	if (
		sel_isEqual(aSelector, @selector(handleAction:forFileTransfer:)) ||
		sel_isEqual(aSelector, @selector(debugLog:)) ||
		sel_isEqual(aSelector, @selector(zoomImage:)) ||
		sel_isEqual(aSelector, @selector(_setDocumentReady))
        )
		return NO;
	
	return YES;
}

- (void)_setDocumentReady
{
	documentIsReady = YES;
}

/*- (void)contentObjectAdded:(NSNotification *)notification
 {
 AIContentObject	*contentObject = [[notification userInfo] objectForKey:@"AIContentObject"];
 [self enqueueContentObject:contentObject];
 }*/
 
- (void)enqueueContentObject:(id) message
{
    [contentQueue addObject:message];
    [self processQueuedContent];
    /*if ([contentObject displayContentImmediately]) {
        [self processQueuedContent];
    }*/
}

- (void)_appendContent:(id) content
{
    messageStyle = [[SinaUCMessageStyle alloc] init];
    NSString *html = [messageStyle scriptForAppendingContent:content];
	[webView stringByEvaluatingJavaScriptFromString:[html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	NSAccessibilityPostNotification(webView, NSAccessibilityValueChangedNotification);
}

/*!
 * @brief Append new content to our processing queueProcess any content in the queuee
 */
- (void)processQueuedContent
{
	dispatch_async(dispatch_get_main_queue(), ^{
		@autoreleasepool {
            /* If the webview isn't ready, assume we have at least one piece of content left to display */
            NSUInteger	contentQueueCount = 1;
            NSUInteger	objectsAdded = 0;
            if (webViewIsReady && documentIsReady) {
                contentQueueCount = contentQueue.count;
                
                while (contentQueueCount > 0) {
                    BOOL willAddMoreContent = (contentQueueCount > 1);
                    
                    //Display the content
                    [self _appendContent:[contentQueue objectAtIndex:0]];
                    
                    //If we are going to reflect preference changes, store this content object
                    /*if (shouldReflectPreferenceChanges) {
                     [storedContentObjects addObject:content];
                     }*/
                    
                    //Remove the content we just displayed from the queue
                    [contentQueue removeObjectAtIndex:0];
                    objectsAdded++;
                    contentQueueCount--;
                }
            }
            
            /* If we added two or more objects, we may want to scroll to the bottom now, having not done it as each object
             * was added.
             */
            /*if (objectsAdded > 1) {
             NSString	*scrollToBottomScript = [messageStyle scriptForScrollingAfterAddingMultipleContentObjects];
             if (scrollToBottomScript) {
             [webView stringByEvaluatingJavaScriptFromString:scrollToBottomScript];
             }
             }*/
            
            //If there is still content to process (the webview wasn't ready), we'll try again after a brief delay
            if (contentQueueCount) {
                double delayInSeconds = NEW_CONTENT_RETRY_DELAY;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self processQueuedContent];
                });
            }
		}
	});
}

- (void)webViewIsReady
{
	webViewIsReady = YES;
	//[self setupMarkedScroller];
	//[self setIsGroupChat:chat.isGroupChat];
	[self processQueuedContent];
	
	// force the window to redisplay, otherwise the shadow will not draw properly with transparent message views
	NSWindow *win = [webView window];
	[win invalidateShadow];
	[win display];
}

- (void)webView:(WebView *)sender didClearWindowObject:(WebScriptObject *)windowObject forFrame:(WebFrame *)frame
{
    [[webView windowScriptObject] setValue:self forKey:@"client"];
	
	// Add an event listener for DOM ready and notify back our controller
	[[webView windowScriptObject] evaluateWebScript:@"document.addEventListener(\"DOMContentLoaded\", function() {window.client.$_setDocumentReady()}, false);"];
}

@end