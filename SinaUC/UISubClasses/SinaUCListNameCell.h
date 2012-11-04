//
//  SinaUCListNameCell.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-3.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCStrechImage.h"

@interface SinaUCListNameCell : NSTextFieldCell {
@private
    NSString* subTitle;
    NSString* title;
}

@property (retain) NSString* subTitle;
@property (retain) NSString* title;

@end
