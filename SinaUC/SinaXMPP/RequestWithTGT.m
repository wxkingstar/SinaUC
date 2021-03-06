//
//  RequestWithTGT.m
//  cocoa-jabber-messenger
//
//  Created by 硕实 陈 on 12-2-4.
//  Copyright (c) 2012年 NHN Corporation. All rights reserved.
//

#import "RequestWithTGT.h"

@implementation RequestWithTGT
@synthesize tgt;

- (NSMutableArray*) getRoomList:(NSString*) uid
{
    NSString* urlStr = [[NSString alloc] initWithFormat:@"http://218.30.115.181/group-list/%@", uid];
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:tgt forHTTPHeaderField:@"X-UC-AUTH"];
    [request setValue:@"tgt" forHTTPHeaderField:@"X-UC-AUTH-TYPE"];
    NSError *err=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request
                                       returningResponse:nil 
                                                   error:&err];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    }
}

- (NSMutableArray*) getRoomContacts:(NSString*) gid withUid: (NSString*) uid
{
    NSString* guid = [[NSUUID UUID] UUIDString];
    NSString* urlStr = [[NSString alloc] initWithFormat:@"http://218.30.115.181/group-user/%@?uid=%@&RandomGuid=%@", gid, uid, guid];
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:tgt forHTTPHeaderField:@"X-UC-AUTH"];
    [request setValue:@"tgt" forHTTPHeaderField:@"X-UC-AUTH-TYPE"];
    NSError *err=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request
                                       returningResponse:nil 
                                                   error:&err];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
}

- (void) exchangeTgt
{
    NSString* urlStr = [[NSString alloc] initWithFormat:@"http://218.30.115.182/sso/update?tgt=%@", tgt];
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:nil 
                                                   error:&err];
    if (data) {
        NSDictionary* ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        tgt = [ret valueForKey:@"tgt"];
    }
}

@end
