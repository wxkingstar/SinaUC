//
//  RoomContact.h
//  SinaUC
//
//  Created by shuoshi on 10/05/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class RoomContact
 @discussion This class represents a record in the "RoomContact" table.
 @updated 2012-10-05
 */
@interface RoomContact : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_jid;
		NSNumber *_rid;
		NSString *_name;
		NSData *_image;
		NSNumber *_precense;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSNumber *rid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSNumber *precense;

@end
