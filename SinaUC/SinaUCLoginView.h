//
//  SinaUCLoginView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCAppDelegate.h"

@interface SinaUCLoginView : NSView <SinaUCActivateProtocol>
{
    NSString *inited;
    NSImage *backgroundTopImage;
    NSImage *backgroundUpsideImage;
    NSImage *backgroundImage;
    NSImageView *accountBackground;
    NSImageView *passwordBackground;
    NSTextField *username;
    NSTextField *password;
    BOOL focused;
}

@property (assign) BOOL focused;
@property (retain) IBOutlet SinaUCAppDelegate *appDelegate;
@property (retain) NSImage *backgroundTopImage;
@property (retain) NSImage *backgroundUpsideImage;
@property (retain) NSImage *backgroundImage;
@property (retain) IBOutlet NSImageView *accountBackground;
@property (retain) IBOutlet NSImageView *passwordBackground;
@property (retain) IBOutlet NSTextField *account;
@property (retain) IBOutlet NSTextField *password;



@end
