//
//  Message.h
//  SinaUC
//
//  Created by shuoshi on 11/18/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Message
 @discussion This class represents a record in the "Message" table.
 @updated 2012-11-18
 */
@interface SinaUCMessage : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_sender;
		NSNumber *_recevier;
		NSNumber *_outgoing;
		NSString *_message;
		NSDate *_sendtime;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSNumber *recevier;
@property (strong, nonatomic) NSNumber *outgoing;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *sendtime;

- (BOOL) isOutgoing;

@end
