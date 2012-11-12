//
//  SinaUCMessageView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-10.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCStrechImage.h"

@interface SinaUCMessageView : NSView
{
}

@property (assign) BOOL isActive;
@property (assign) BOOL focused;
@property (retain) IBOutlet NSView *contactsView;

@end
