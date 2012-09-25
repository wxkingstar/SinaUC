//
//  SinaUCMaxLengthFormatter.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-24.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaUCMaxLengthFormatter : NSFormatter {
    int maxLength;
}

- (void)setMaximumLength:(int)len;
- (int)maximumLength;

@end
