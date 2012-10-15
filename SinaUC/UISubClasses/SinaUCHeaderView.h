//
//  SinaUCHeaderView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCHeaderView : NSView
{
    NSImageView *myHeadImg;
    NSTextField *nickname;
    NSTextField *note;
}

@property (retain) IBOutlet NSImageView* myHeadImg;
@property (retain) IBOutlet NSTextField* nickname;
@property (retain) IBOutlet NSTextField* note;

@end
