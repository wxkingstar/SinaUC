//
//  User.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-30.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSData * headimg;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * logintime;

@end
