//
//  SinaUCLoginWindow.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCLoginWindow : NSWindow {
    // this point is used in dragging to mark the initial click location
    NSPoint initialLocation;
}

@property (assign) NSPoint initialLocation;

@end
