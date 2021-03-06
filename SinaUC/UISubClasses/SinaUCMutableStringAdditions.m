//
//  SinaUCMutableStringAdditions.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-18.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMutableStringAdditions.h"

@implementation NSMutableString (SinaUCMutableStringAdditions)

+ (NSMutableString *)stringWithContentsOfASCIIFile:(NSString *)path
{
	return ([[NSMutableString alloc] initWithData:[NSData dataWithContentsOfFile:path]
                                         encoding:NSASCIIStringEncoding]);
}

- (NSMutableString*)mutableString
{
	return self;
}

/*
 * @brief Convert new lines to slashes
 *
 * We first consolidate all duplicate line breaks and process \r\n into being just \n.
 * All remaining \r and \n characters are converted to " / " as is done with multiple lines of a poem
 * displayed on a single line
 */
- (void)convertNewlinesToSlashes
{
	NSRange fullRange = NSMakeRange(0, [self length]);
	NSUInteger replacements = 0;
    
	//First, we remove duplicate linebreaks.
	do {
		replacements = [self replaceOccurrencesOfString:@"\r\r"
											 withString:@"\r"
												options:NSLiteralSearch
												  range:fullRange];
		fullRange.length -= replacements;
	} while (replacements > 0);
	
	do {
		replacements = [self replaceOccurrencesOfString:@"\n\n"
											 withString:@"\n"
												options:NSLiteralSearch
												  range:fullRange];
		fullRange.length -= replacements;
	} while (replacements > 0);
	
	do {
		replacements = [self replaceOccurrencesOfString:@"\r\n"
											 withString:@"\n"
												options:NSLiteralSearch
												  range:fullRange];
		fullRange.length -= replacements;
	} while (replacements > 0);
	
	//Now do the slash replacements
	replacements = [self replaceOccurrencesOfString:@"\r"
										 withString:@" / "
											options:NSLiteralSearch
											  range:fullRange];
	fullRange.length += (2 * replacements);
	
	[self replaceOccurrencesOfString:@"\n"
						  withString:@" / "
							 options:NSLiteralSearch
							   range:fullRange];
}

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)opts
{
	return [self replaceOccurrencesOfString:target withString:replacement options:opts range:NSMakeRange(0, [self length])];
}

@end
