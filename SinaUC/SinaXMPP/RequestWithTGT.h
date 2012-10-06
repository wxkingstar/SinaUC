//
//  RequestWithTGT.h
//  cocoa-jabber-messenger
//
//  Created by 硕实 陈 on 12-2-4.
//  Copyright (c) 2012年 NHN Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestWithTGT : NSObject {
@private
    NSString* tgt;
}

@property (strong) NSString* tgt;

- (NSMutableArray*) getRoomList :(NSString*) uid;
- (NSMutableArray*) getRoomContacts :(NSString*) gid withUid: (NSString*) uid;
- (void) exchangeTgt;

@end
