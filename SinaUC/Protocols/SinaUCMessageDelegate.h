//
//  SinaUCMessageDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-12.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaUCMessage.h"

@protocol SinaUCMessageDelegate <NSObject>

- (void)handleMessage:(SinaUCMessage*) msg;
- (void)sendMessage:(SinaUCMessage*) msg;

@end
