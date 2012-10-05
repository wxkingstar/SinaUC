//
//  Contact.h
//  SinaUC
//
//  Created by shuoshi on 10/03/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Contact
 @discussion This class represents a record in the "Contact" table.
 @updated 2012-10-03
 */
@interface Contact : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_jid;
		NSNumber *_gid;
		NSString *_name;
		NSString *_pinyin;
		NSData *_image;
		NSNumber *_presence;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSNumber *gid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pinyin;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSNumber *presence;

@end
