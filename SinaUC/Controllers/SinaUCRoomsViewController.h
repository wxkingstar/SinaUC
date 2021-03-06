//
//  SinaUCRoomsViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "XMPP.h"
#import "SinaUCRoomRosterUpdateDelegate.h"
#import "SinaUCListGroupCell.h"
#import "SinaUCListNameCell.h"
#import "SinaUCListImageCell.h"

#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "SinaUCContact.h"
#import "SinaUCContactGroup.h"

@interface SinaUCRoomsViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate, SinaUCRoomRosterUpdateDelegate>
{
    NSMutableArray              *rooms;
    SinaUCListGroupCell         *iGroupRowCell;
    IBOutlet XMPP               *xmpp;
}

- (void)updateRoster;
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;


@end
