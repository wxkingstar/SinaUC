//
//  RoomMessage.m
//  SinaUC
//
//  Created by shuoshi on 11/04/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "SinaUCRoomMessage.h"

@implementation SinaUCRoomMessage

@synthesize pk = _pk;
@synthesize rid = _rid;
@synthesize sender = _sender;
@synthesize receier = _receier;
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
