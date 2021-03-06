//
//  SinaUCLaunchedView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCStrechImage.h"

@interface SinaUCLaunchedView : NSView

@property (assign) BOOL isActive;
@property (assign) BOOL focused;
@property (retain) IBOutlet NSView *headerView;
@property (retain) IBOutlet NSView *contactsView;
@property (retain) IBOutlet NSTabView *contactsTabView;
@property (retain) IBOutlet NSView *bottomView;
@property (retain) IBOutlet NSImageView *backgroundHeaderImageView;
@property (retain) IBOutlet NSImageView *backgroundContactsImageView;
@property (retain) IBOutlet NSImageView *backgroundBottomImageView;

@end
