//
//  SinaUCLoginView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SinaUCLoginWindow;
@interface SinaUCLoginView : NSView
{
    NSString *inited;
    NSImage *backgroundUpsideImage;
    NSImage *backgroundTopImage;
    NSImage *backgroundImage;
    NSImageView *accountBackground;
    NSImageView *passwordBackground;
    NSTextField *username;
    NSTextField *password;
    BOOL focused;
    BOOL showTop;
}

@property (assign) BOOL focused;
@property (assign) BOOL showTop;
@property (retain) IBOutlet SinaUCLoginWindow *loginWindow;
@property (retain) NSImage *backgroundUpsideImage;
@property (retain) NSImage *backgroundTopImage;
@property (retain) NSImage *backgroundImage;
@property (retain) IBOutlet NSImageView *accountBackground;
@property (retain) IBOutlet NSImageView *passwordBackground;
@property (retain) IBOutlet NSTextField *account;
@property (retain) IBOutlet NSTextField *password;



@end
