//
//  RoomMessage.m
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "RoomMessage.h"

@implementation RoomMessage

@synthesize pk = _pk;
@synthesize rid = _rid;
@synthesize message = _message;
@synthesize sendtime = _sendtime;

- (id) init {
	if ((self = [super init])) {
		_saved = nil;
	}
	return self;
}

+ (NSString *) dataSource {
	return @"message";
}

+ (NSString *) table {
	return @"RoomMessage";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
