//
//  Room.m
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "Room.h"

@implementation Room

@synthesize pk = _pk;

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
