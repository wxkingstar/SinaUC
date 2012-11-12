//
//  SinaUCMaxLengthFormatter.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-24.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMaxLengthFormatter.h"

@implementation SinaUCMaxLengthFormatter

- (id)init {
    self = [super init];
    maxLength = INT_MAX;
    return self;
}

- (void)setMaximumLength:(int)len {
    maxLength = len;
}

- (int)maximumLength {
    return maxLength;
}

- (NSString *)stringForObjectValue:(id)object {
    return (NSString *)object;
}

- (BOOL)getObjectValue:(id *)object forString:(NSString *)string errorDescription:(NSString **)error {
    *object = string;
    return YES;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString **)error
{
    long size = [*partialStringPtr length];
    if ( size > maxLength )
    {
        return NO;
    }
    return YES;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes {
    return nil;
}

@end
