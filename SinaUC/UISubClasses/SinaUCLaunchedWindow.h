//
//  SinaUCLaunchedWindow.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCLaunchedWindow : NSWindow <NSWindowDelegate> {
    NSPoint initialLocation;
}

@property (assign) NSPoint initialLocation;

@end
