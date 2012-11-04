//
//  ContactGroup.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class ContactGroup
 @discussion This class represents a record in the "ContactGroup" table.
 @updated 2012-10-03
 */
@interface SinaUCContactGroup : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_name;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *name;

@end
