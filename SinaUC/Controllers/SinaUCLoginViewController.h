//
//  SinaUCLoginViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCDelegate.h"

@protocol SinaUCDelegate;
@class XMPP;
@class SinaUCLoginView;
@interface SinaUCLoginViewController : NSViewController <SinaUCDelegate>
{
    IBOutlet XMPP *xmpp;
}

- (IBAction) showTop:(id)sender;
- (IBAction) hideTop:(id)sender;
- (IBAction) login:(id)sender;
- (void)willConnect;
- (void)didDisConnectedWithError:(NSInteger) error;

@end
