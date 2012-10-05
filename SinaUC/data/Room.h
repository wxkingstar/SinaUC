//
//  Room.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Room
 @discussion This class represents a record in the "Room" table.
 @updated 2012-10-03
 */
@interface Room : ZIMOrmModel {

	@private
		NSNumber *_pk;

}

@property (strong, nonatomic) NSNumber *pk;

@end
