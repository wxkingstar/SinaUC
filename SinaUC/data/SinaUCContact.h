//
//  Contact.h
//  SinaUC
//
//  Created by shuoshi on 11/07/12.
//  Copyright 2012 shuoshi. All rights reserved.
//

#import "ZIMOrmModel.h"

/*!
 @class Contact
 @discussion This class represents a record in the "Contact" table.
 @updated 2012-11-07
 */
@interface SinaUCContact : ZIMOrmModel {

	@private
		NSNumber *_pk;
		NSString *_jid;
		NSNumber *_gid;
		NSString *_name;
		NSString *_pinyin;
        NSString *_avatar;
		NSData *_image;
		NSString *_mood;
		NSNumber *_presence;

}

@property (strong, nonatomic) NSNumber *pk;
@property (strong, nonatomic) NSString *jid;
@property (strong, nonatomic) NSNumber *gid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pinyin;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSData *image;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSNumber *presence;

@end
