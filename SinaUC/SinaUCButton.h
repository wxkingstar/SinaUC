//
//  SinaUCButton.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-25.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCButton : NSButton {
    NSTrackingArea *trackArea;
}

@property (copy) NSString* hoverImage;
@property (copy, nonatomic) NSString* origImage;

@end
