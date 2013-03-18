//
//  Message.h
//  SinaUC
//
//  Created by shuoshi on 03/17/13.
//  Copyright 2013 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Message
 @discussion This class represents a record in the "Message" table.
 @updated 2013-03-17
 */
@interface SinaUCMessage : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_sender;
		NSString *_recevier;
		NSNumber *_outgoing;
		NSString *_message;
		NSDate *_sendtime;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *recevier;
@property (strong, nonatomic) NSNumber *outgoing;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *sendtime;

@end
