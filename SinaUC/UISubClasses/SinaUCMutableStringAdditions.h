//
//  SinaUCMutableStringAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (SinaUCMutableStringAdditions)
+ (NSMutableString *)stringWithContentsOfASCIIFile:(NSString *)path;

//This is so that code that may be dealing with a mutable string
//or mutable attributed string can call [str mutableString] and get
//a mutable string out of it, that it can work with that without
//worrying about what kind of string it's dealing with
- (NSMutableString*)mutableString;

- (void)convertNewlinesToSlashes;

//There is/was code in Adium that attempted to be smart about avoiding doing NSMakeRange(0, [str length]) over and over again
//At least a few cases were wrong, and it's generally pointless. Please use this instead and ignore the slight overhead.
- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)opts;

@end

