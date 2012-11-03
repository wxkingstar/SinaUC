//
//  SinaUCTabStyle.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-31.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCTabStyle.h"

@implementation SinaUCTabStyle
@synthesize hasDivider;

+ (NSString *)name {
    return @"SinaUC";
}

- (NSString *)name {
	return [[self class] name];
}

#pragma mark -
#pragma mark Creation/Destruction

- (id) init {
	if((self = [super init])) {
        hasDivider = YES;
		[self loadImages];
	}
	return self;
}

- (void) loadImages {
	// SinaUC Tabs Images
	SinaUCTabBg = [NSImage imageNamed:@"mainpanel_tab_bkg"];
	[SinaUCTabBg setFlipped:YES];
	SinaUCTabBgDown = [NSImage imageNamed:@"mainpanel_tab_bkg_mousedown"];
	[SinaUCTabBgDown setFlipped:YES];
    
	SinaUCDividerDown = [NSImage imageNamed:@"mainpanel_tab_line"];
	[SinaUCDividerDown setFlipped:NO];
	SinaUCDivider = [NSImage imageNamed:@"mainpanel_tab_line"];
	[SinaUCDivider setFlipped:NO];
}

#pragma mark -
#pragma mark Control Specifics

- (CGFloat)leftMarginForTabBarControl:(PSMTabBarControl *)tabBarControl {
	return 0.0f;
}

- (CGFloat)rightMarginForTabBarControl:(PSMTabBarControl *)tabBarControl {
	return 0.0f;
}

- (CGFloat)topMarginForTabBarControl:(PSMTabBarControl *)tabBarControl {
	return 0.0f;
}

#pragma mark -
#pragma mark Add Tab Button

- (NSImage *)addTabButtonImage {
	return nil;
}

- (NSImage *)addTabButtonPressedImage {
	return nil;
}

- (NSImage *)addTabButtonRolloverImage {
	return nil;
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelOfTabCell:(PSMTabBarCell *)cell withFrame:(NSRect)frame inTabBarControl:(PSMTabBarControl *)tabBarControl {
    
	NSRect cellFrame = frame;
    
	// Selected Tab
	if([cell state] == NSOnState) {
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height - 2.5);
		aRect.size.height -= 0.5;
        
		// proper tint
		NSControlTint currentTint;
		if([cell controlTint] == NSDefaultControlTint) {
			currentTint = [NSColor currentControlTint];
		} else{
			currentTint = [cell controlTint];
		}
        
		if(![tabBarControl isWindowActive]) {
			currentTint = NSClearControlTint;
		}
        
		NSImage *bgImage;
		switch(currentTint) {
            case NSGraphiteControlTint:
                bgImage = SinaUCTabBgDownGraphite;
                break;
            case NSClearControlTint:
                bgImage = SinaUCTabBgDownNonKey;
                break;
            case NSBlueControlTint:
            default:
                bgImage = SinaUCTabBgDown;
                break;
		}
        
        [bgImage drawInRect:cellFrame fromRect:NSMakeRect(0.0, 0.0, 1.0, 32.0) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:NO hints:nil];
        
        if ([tabBarControl lastVisibleTab] != cell) {
            [SinaUCDivider drawAtPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0, cellFrame.origin.y) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
		aRect.size.height += 0.5;
	} else { // Unselected Tab
		NSRect aRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
		aRect.origin.y += 0.5;
		aRect.origin.x += 1.5;
		aRect.size.width -= 1;
        
		aRect.origin.x -= 1;
		aRect.size.width += 1;
        
		// Rollover
		if([cell isHighlighted]) {
			[[NSColor colorWithCalibratedWhite:0.0 alpha:0.1] set];
			NSRectFillUsingOperation(aRect, NSCompositeSourceAtop);
		}
        
        if ([tabBarControl lastVisibleTab] != cell) {
            [SinaUCDivider drawAtPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0, cellFrame.origin.y) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
	}
}

- (CGFloat)heightOfTabCellsForTabBarControl:(PSMTabBarControl *)tabBarControl {
    return 32;
}

@end
