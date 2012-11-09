//
//  NSImage+Grayscale.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-8.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Grayscale)
- (NSImage *)grayscaleImageWithAlphaValue:(CGFloat)alphaValue
                          saturationValue:(CGFloat)saturationValue
                          brightnessValue:(CGFloat)brightnessValue
                            contrastValue:(CGFloat)contrastValue;
@end
