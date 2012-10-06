//
//  SinaUCRequest.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-5.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaUCRequest : NSObject

+ (void)asyncRequest:(NSURLRequest *)request
             success:(void(^)(NSData *,NSURLResponse *))successBlock_
             failure:(void(^)(NSData *,NSError *))failureBlock_;

@end
