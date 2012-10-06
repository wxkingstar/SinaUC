//
//  Room.h
//  SinaUC
//
//  Created by shuoshi on 10/05/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Room
 @discussion This class represents a record in the "Room" table.
 @updated 2012-10-05
 */
@interface Room : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSNumber *_gid;
		NSString *_jid;
		NSString *_name;
		NSString *_intro;
		NSString *_notice;
		NSData *_image;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSNumber *gid;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *intro;
@property (strong, nonatomic) NSString *notice;
@property (strong, nonatomic) NSData *image;

@end
