//
//  SinaUCMD5.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-5.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SinaUCMD5

+ (NSString*) md5:(NSString*) input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end
