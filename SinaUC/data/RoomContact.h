//
//  RoomContact.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class RoomContact
 @discussion This class represents a record in the "RoomContact" table.
 @updated 2012-10-03
 */
@interface RoomContact : ZIMOrmModel {

	@private
		NSNumber *_pk;

}

@property (strong, nonatomic) NSNumber *pk;

@end
