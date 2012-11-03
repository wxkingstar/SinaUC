//
//  SinaUCTabStyle.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-31.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSMTabBarControl/PSMTabStyle.h>
#import <PSMTabBarControl/PSMTabBarCell.h>
#import <PSMTabBarControl/PSMTabBarControl.h>

@interface SinaUCTabStyle : NSObject <PSMTabStyle> {
	NSImage									*SinaUCTabBg;
	NSImage									*SinaUCTabBgDown;
	NSImage									*SinaUCTabBgDownGraphite;
	NSImage									*SinaUCTabBgDownNonKey;
	NSImage									*SinaUCDividerDown;
	NSImage									*SinaUCDivider;
    BOOL                                    hasDivider;
}

@property (assign) BOOL hasDivider;

- (void)loadImages;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
-(NSRect)largeImageRectForBounds:(NSRect)theRect ofTabCell:(PSMTabBarCell *)cell;


@end
