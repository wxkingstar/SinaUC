//
//  SinaUCAppDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import "SinaUCLoginWindowController.h"
#import "SinaUCLaunchedWindowController.h"

@class XMPP;
@class SinaUCLoginWindowController;
@class SinaUCLaunchedWindowController;
@interface SinaUCAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet XMPP *xmpp;
    SinaUCLoginWindowController *loginWindowController;
    SinaUCLaunchedWindowController *launchedWindowController;
}

@end
