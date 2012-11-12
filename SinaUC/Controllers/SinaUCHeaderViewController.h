//
//  SinaUCHeaderViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import "SinaUCSVcardUpdateDelegate.h"

@interface SinaUCHeaderViewController : NSViewController <SinaUCSVcardUpdateDelegate>
{
    IBOutlet XMPP *xmpp;
}

- (void)updateVcard;

@end
