//
//  SinaUCMessageTabViewItem.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-10.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageTabViewItem.h"

@implementation SinaUCMessageTabViewItem
@synthesize icon = _icon;

- (id)init {
	if((self = [super init])) {
		_icon = nil;
	}
	return self;
}

@end
