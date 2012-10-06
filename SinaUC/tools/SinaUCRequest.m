//
//  SinaUCRequest.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-5.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCRequest.h"

@implementation SinaUCRequest

#pragma mark API
+ (void)asyncRequest:(NSURLRequest*) request
             success:(void(^)(NSData*, NSURLResponse*))successBlock_
             failure:(void(^)(NSData*, NSError*))failureBlock_
{
	[NSThread detachNewThreadSelector:@selector(backgroundSync:)
                             toTarget:[SinaUCRequest class]
						   withObject:[NSDictionary dictionaryWithObjectsAndKeys:
									   request, @"request",
									   successBlock_, @"success",
									   failureBlock_, @"failure",
									   nil]];
}

#pragma mark Private
+ (void) backgroundSync:(NSDictionary*) dictionary
{
	void(^success)(NSData*, NSURLResponse*) = [dictionary objectForKey:@"success"];
	void(^failure)(NSData*, NSError*) = [dictionary objectForKey:@"failure"];
	NSURLRequest *request = [dictionary objectForKey:@"request"];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		failure(data, error);
	} else {
		success(data, response);
	}
}

@end


