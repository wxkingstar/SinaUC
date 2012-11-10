//
//  SinaUCMessageWindowController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-4.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageWindowController.h"

@interface SinaUCMessageWindowController ()

@end

@implementation SinaUCMessageWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MessageWindow"];
    INAppStoreWindow *aWindow = ((INAppStoreWindow*)[self window]);
    aWindow.titleBarHeight = 0;
    return self;
}

@end
