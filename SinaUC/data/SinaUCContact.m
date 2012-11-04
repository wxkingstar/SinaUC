//
//  Contact.m
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "SinaUCContact.h"

@implementation SinaUCContact

@synthesize pk = _pk;
@synthesize jid = _jid;
@synthesize gid = _gid;
@synthesize name = _name;
@synthesize pinyin = _pinyin;
@synthesize image = _image;
@synthesize presence = _presence;

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
	return @"Contact";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
