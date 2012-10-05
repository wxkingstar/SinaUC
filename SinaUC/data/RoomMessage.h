//
//  RoomMessage.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class RoomMessage
 @discussion This class represents a record in the "RoomMessage" table.
 @updated 2012-10-03
 */
@interface RoomMessage : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSNumber *_rid;
		NSString *_message;
		NSDate *_sendtime;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSNumber *rid;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *sendtime;

@end
