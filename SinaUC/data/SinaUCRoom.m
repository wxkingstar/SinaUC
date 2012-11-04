//
//  Room.m
//  SinaUC
//
//  Created by shuoshi on 10/05/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "SinaUCRoom.h"

@implementation SinaUCRoom

@synthesize pk = _pk;
@synthesize gid = _gid;
@synthesize jid = _jid;
@synthesize name = _name;
@synthesize intro = _intro;
@synthesize notice = _notice;
@synthesize image = _image;

- (id) init {
	if ((self = [super init])) {
		_saved = nil;
	}
	return self;
}

+ (NSString *) dataSource {
	return @"addressbook";
}

+ (NSString *) table {
	return @"Room";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
