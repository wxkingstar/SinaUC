//
//  SinaUCMessageTabViewItem.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-10.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageTabViewItem.h"

@implementation SinaUCMessageTabViewItem
@synthesize icon;
@synthesize jid;

- (id)init {
	if((self = [super init])) {
		icon = nil;
        jid = @"";
	}
	return self;
}

@end
