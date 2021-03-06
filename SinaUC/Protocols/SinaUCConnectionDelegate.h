//
//  SinaUCDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-30.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaUCConnectionDelegate <NSObject>

- (void)willConnect;
- (void)didConnectedWithJidForFirstTime:(NSString*) jid;
- (void)didConnectedWithJid:(NSString*) jid;
- (void)didDisConnectedWithError:(NSInteger) error;

@end
