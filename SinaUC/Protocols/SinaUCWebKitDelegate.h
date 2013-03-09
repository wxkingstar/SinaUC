//
//  SinaUCWebKitDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <WebKit/WebKit.h>

@class SinaUCWebView, SinaUCWebKitMessageViewController;

@interface SinaUCWebKitDelegate : NSObject {
	NSMutableDictionary *mapping;
}

+ (SinaUCWebKitDelegate *)sharedWebKitDelegate;
- (void) addDelegate:(SinaUCWebKitMessageViewController *)controller forView:(SinaUCWebView *)wv;
- (void) removeDelegate:(SinaUCWebKitMessageViewController *)controller;

@end
