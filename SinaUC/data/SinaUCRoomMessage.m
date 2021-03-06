//
//  RoomMessage.m
//  SinaUC
//
//  Created by shuoshi on 11/18/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "SinaUCRoomMessage.h"

@implementation SinaUCRoomMessage

@synthesize pk = _pk;
@synthesize gid = _gid;
@synthesize sender = _sender;
@synthesize receier = _receier;
@synthesize outgoing = _outgoing;
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
