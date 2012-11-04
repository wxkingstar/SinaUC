//
//  RoomContact.m
//  SinaUC
//
//  Created by shuoshi on 10/05/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "SinaUCRoomContact.h"

@implementation SinaUCRoomContact

@synthesize pk = _pk;
@synthesize jid = _jid;
@synthesize rid = _rid;
@synthesize name = _name;
@synthesize image = _image;
@synthesize precense = _precense;

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
	return @"RoomContact";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
