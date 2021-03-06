//
//  SinaUCDialogView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-12.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCButton.h"

@interface SinaUCDialogView : NSView
{
    IBOutlet SinaUCButton   *historyBtn;
    IBOutlet SinaUCButton   *emotionBtn;
    IBOutlet NSTextView *inputArea;
}

@property (assign) BOOL isActive;
@property (assign) BOOL focused;
@property (retain) IBOutlet NSView *headerView;
@property (retain) IBOutlet NSView *dialogView;
@property (retain) IBOutlet NSView *inputView;
@property (retain) IBOutlet NSImageView *shadowLine;

@end
