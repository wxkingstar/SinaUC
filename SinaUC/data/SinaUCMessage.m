//
//  Message.m
//  SinaUC
//
//  Created by shuoshi on 03/17/13.
//  Copyright 2013 shuoshi. All rights reserved.
//

#import "SinaUCMessage.h"

@implementation SinaUCMessage

@synthesize pk = _pk;
@synthesize sender = _sender;
@synthesize recevier = _recevier;
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
	return @"Message";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
