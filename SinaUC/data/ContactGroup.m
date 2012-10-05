//
//  ContactGroup.m
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ContactGroup.h"

@implementation ContactGroup

@synthesize pk = _pk;
@synthesize name = _name;

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
	return @"ContactGroup";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
