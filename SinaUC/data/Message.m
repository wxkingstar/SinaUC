//
//  Message.m
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize pk = _pk;
@synthesize receier = _receier;
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
