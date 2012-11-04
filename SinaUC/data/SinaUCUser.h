//
//  User.h
//  SinaUC
//
//  Created by shuoshi on 10/06/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class User
 @discussion This class represents a record in the "user" table.
 @updated 2012-10-06
 */
@interface SinaUCUser : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_username;
		NSString *_password;
		NSNumber *_status;
		NSDate *_logintime;
		NSData *_headimg;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSDate *logintime;
@property (strong, nonatomic) NSData *headimg;

@end
