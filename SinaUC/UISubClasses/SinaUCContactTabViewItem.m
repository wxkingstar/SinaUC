//
//  SinaUCContactTabViewItem.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-30.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCContactTabViewItem.h"

@implementation SinaUCContactTabViewItem
@synthesize icon = _icon;

- (id)init {
	if((self = [super init])) {
		_icon = nil;
	}
	return self;
}

@end
