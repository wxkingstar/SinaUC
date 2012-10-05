//
//  Message.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Message
 @discussion This class represents a record in the "Message" table.
 @updated 2012-10-03
 */
@interface Message : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSNumber *_receier;
		NSData *_sendtime;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSNumber *receier;
@property (strong, nonatomic) NSData *sendtime;

@end
