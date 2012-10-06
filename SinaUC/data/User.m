//
//  Userinfo.m
//  SinaUC
//
//  Created by shuoshi on 10/06/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize pk = _pk;
@synthesize username = _username;
@synthesize password = _password;
@synthesize status = _status;
@synthesize logintime = _logintime;
@synthesize headimg = _headimg;

- (id) init {
	if ((self = [super init])) {
		_saved = nil;
	}
	return self;
}

+ (NSString *) dataSource {
	return @"user";
}

+ (NSString *) table {
	return @"User";
}

+ (NSArray *) primaryKey {
	return [NSArray arrayWithObjects: @"pk", nil];
}

+ (BOOL) isAutoIncremented {
	return YES;
}

@end
