//
//  SinaUCControllerProtocol.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinaUCControllerProtocol <NSObject>
- (void)controllerDidLoad;
- (void)controllerWillClose;
@end
