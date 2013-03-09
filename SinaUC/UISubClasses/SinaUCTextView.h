//
//  SinaUCTextView.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SinaUCTextView : NSTextView
{
    id target;
    SEL action;
}

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;

@end
