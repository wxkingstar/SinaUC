//
//  SinaUCDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-30.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaUCDelegate <NSObject>

- (void)willConnect;
- (void)didConnectedWithJid:(NSString*) jid;
- (void)didDisConnectedWithError:(NSInteger) error;

@end
