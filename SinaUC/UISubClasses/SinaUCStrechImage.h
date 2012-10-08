//
//  SinaUCStrechImage.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-7.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (NinePartDrawing)

- (void)drawStretchableInRect:(NSRect)rect edgeInsets:(NSEdgeInsets)insets operation:(NSCompositingOperation)op fraction:(CGFloat)delta;

@end
