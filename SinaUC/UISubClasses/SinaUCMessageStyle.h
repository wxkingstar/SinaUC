//
//  SinaUCMessageStyle.h
//  SinaUC
//
//  Created by css on 13-5-10.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SinaUCMessage;

@interface SinaUCMessageStyle : NSObject {
    NSBundle			*__weak styleBundle;
    NSString			*stylePath;
}

- (NSString*) scriptForAppendingContent:(SinaUCMessage*) content;

@end
