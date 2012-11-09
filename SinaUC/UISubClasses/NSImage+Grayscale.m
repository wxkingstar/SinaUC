//
//  NSImage+Grayscale.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-8.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "NSImage+Grayscale.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSImage (Grayscale)
- (NSImage *)grayscaleImageWithAlphaValue:(CGFloat)alphaValue
                          saturationValue:(CGFloat)saturationValue
                          brightnessValue:(CGFloat)brightnessValue
                            contrastValue:(CGFloat)contrastValue
{
    NSSize size = [self size];
    NSRect bounds = { NSZeroPoint, size };
    NSImage *tintedImage = [[NSImage alloc] initWithSize:size];
    
    [tintedImage lockFocus];
    
    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [monochromeFilter setDefaults];
    [monochromeFilter setValue:[CIImage imageWithData:[self TIFFRepresentation]] forKey:@"inputImage"];
    [monochromeFilter setValue:[CIColor colorWithRed:255 green:255 blue:255 alpha:1] forKey:@"inputColor"];
    [monochromeFilter setValue:[NSNumber numberWithFloat:0.1] forKey:@"inputIntensity"];
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIColorControls"];
    [colorFilter setDefaults];
    [colorFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
    [colorFilter setValue:[NSNumber numberWithFloat:saturationValue] forKey:@"inputSaturation"];
    [colorFilter setValue:[NSNumber numberWithFloat:brightnessValue] forKey:@"inputBrightness"];
    [colorFilter setValue:[NSNumber numberWithFloat:contrastValue] forKey:@"inputContrast"];
    
    [[colorFilter valueForKey:@"outputImage"] drawAtPoint:NSZeroPoint
                                                 fromRect:bounds
                                                operation:NSCompositeCopy
                                                 fraction:alphaValue];
    
    [tintedImage unlockFocus];
    
    return tintedImage;
}


@end
