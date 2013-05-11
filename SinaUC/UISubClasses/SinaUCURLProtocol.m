//
//  SinaUCURLProtocol.m
//  SinaUC
//
//  Created by css on 13-5-11.
//  Copyright (c) 2013年 陈 硕实. All rights reserved.
//

#import "SinaUCURLProtocol.h"

@implementation SinaUCURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [[[request URL] scheme] isEqualToString:@"sinauc"];
}

@end
