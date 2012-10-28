//
//  SinaUCGradientAdditions.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-27.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//
#import "SinaUCGradientAdditions.h"

@implementation NSGradient (SinaUCGradientAdditions)

+ (NSGradient *) selectedControlGradient
{
	static NSGradient *grad;
	if (!grad) {
		NSColor *selectedColor = [NSColor alternateSelectedControlColor];
		grad = [[NSGradient alloc] initWithStartingColor:[selectedColor darkenAndAdjustSaturationBy:-0.1f] endingColor:[selectedColor darkenAndAdjustSaturationBy:0.1f]];
	}
	
	return grad;
}

@end