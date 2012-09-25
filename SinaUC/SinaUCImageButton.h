//
//  SinaUCImageButton.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-24.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCImageButton : NSButton {
    NSTrackingArea *_trackingArea;
}

@property (retain) NSImage *hoverImage;

@end
