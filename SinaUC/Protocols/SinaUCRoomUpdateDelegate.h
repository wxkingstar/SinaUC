//
//  SinaUCRoomUpdateDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaUCRoomUpdateDelegate <NSObject>

- (void)updateRoom:(NSString*) jid;

@end
