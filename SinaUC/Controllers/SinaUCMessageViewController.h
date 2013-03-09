//
//  SinaUCMessageViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-11.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SinaUCWebKitMessageViewController, SinaUCTextView;
@interface SinaUCMessageViewController : NSViewController
{
    NSMutableArray *messages;
    IBOutlet SinaUCTextView *input;
    SinaUCWebKitMessageViewController	*messageDisplayController;

}

- (IBAction)send:(id)sender;

@end
