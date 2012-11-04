//
//  SinaUCRoomsViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCRoomsViewController.h"

@interface SinaUCRoomsViewController ()

@end

@implementation SinaUCRoomsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    if (!rooms) {
        [xmpp setRDelegate:self];
        
        rooms = [[NSMutableArray alloc] init];
        iGroupRowCell = [[SinaUCListGroupCell alloc] init];
        
        [(NSOutlineView*)self.view setIntercellSpacing:NSMakeSize(0,0)];
        [(NSOutlineView*)self.view setTarget:self];
        [(NSOutlineView*)self.view setDoubleAction:@selector(onDoubleClick:)];
        [(NSOutlineView*)self.view setAction:@selector(onClick:)];
    }
}

- (void)updateRoster
{
    NSString *rmStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Room" withValues:nil, nil];
    NSArray *roomRes = [ZIMDbConnection dataSource:@"addressbook" query:rmStatement];
    NSMutableDictionary *roomGroup = [[NSMutableDictionary alloc] init];
    [roomGroup setValue:@"群组" forKey:@"name"];
    [roomGroup setValue:roomRes forKeyPath:@"children"];
    [rooms addObject:roomGroup];
    /*NSMutableDictionary *discussGroup = [[NSMutableDictionary alloc] init];
    [discussGroup setValue:@"讨论组" forKey:@"name"];
    [discussGroup setValue:@"" forKeyPath:@"rooms"];
    [rooms addObject:discussGroup];*/
    [(NSOutlineView*)self.view reloadData];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item objectForKey:@"children"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayOutlineCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([item objectForKey:@"children"]) {
        BOOL expanded = [outlineView isItemExpanded:item];
        BOOL selected = [outlineView rowForItem:item] == [outlineView selectedRow];
        if (expanded) {
            if (selected) {
                [cell setImage:[NSImage imageNamed:@"buddy_arrow_down_selected"]];
            } else {
                [cell setImage:[NSImage imageNamed:@"buddy_arrow_down"]];
            }
        } else {
            if (selected) {
                [cell setImage:[NSImage imageNamed:@"buddy_arrow_right_selected"]];
            } else {
                [cell setImage:[NSImage imageNamed:@"buddy_arrow_right"]];
            }
        }
    }
}

- (CGFloat) outlineView:(NSOutlineView*) outlineView heightOfRowByItem:(id) item
{
    if ([item objectForKey:@"children"]) {
        return 20;
    } else {
        return 52;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [rooms count];
    }
    if ([item objectForKey:@"children"]) {
        return [[item objectForKey:@"children"] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [rooms objectAtIndex:index];
    }
    if ([item objectForKey:@"children"]) {
        return [[item objectForKey:@"children"] objectAtIndex:index];
    }
    return nil;
}

- (NSCell*) outlineView:(NSOutlineView*) outlineView dataCellForTableColumn:(NSTableColumn*)tableColumn item:(id) item
{
    if (tableColumn == nil && [item objectForKey:@"children"]) {
        return iGroupRowCell;
    }
	return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item objectForKey:@"children"]) {
        return [NSString stringWithFormat:@" %@", [item valueForKey:@"name"]];
    }
    /*if ([[tableColumn identifier] isEqualToString:@"photo"]) {
        return [NSImage imageNamed:@"NSUser"];
        NSData* imageData = [item valueForKey:@"image"];
        if (imageData) {
            NSImage* image = [[NSImage alloc] initWithData:imageData];
            return image;
        }
    }*/
    if ([[tableColumn identifier] isEqualToString:@"name"]) {
        [(SinaUCListNameCell*)[tableColumn dataCell] setTitle:[item valueForKey:@"name"]];
        [(SinaUCListNameCell*)[tableColumn dataCell] setSubTitle:[item valueForKey:@"jid"]];
        return [item valueForKey:@"name"];
    }
    return nil;
}

- (void) onClick:(id) sender
{
    NSInteger selected = [(NSOutlineView*)self.view selectedRow];
    NSTreeNode* node = [(NSOutlineView*)self.view itemAtRow:selected];
    if ([(NSOutlineView*)self.view isExpandable:node]) {
        if ([(NSOutlineView*)self.view isItemExpanded:node]) {
            [(NSOutlineView*)self.view collapseItem:node];
        }
        else {
            [(NSOutlineView*)self.view expandItem:node];
        }
    }
}

- (void) onDoubleClick:(id) sender
{
    NSInteger selected = [(NSOutlineView*)self.view selectedRow];
    NSDictionary* room = [(NSOutlineView*)self.view itemAtRow:selected];
    
}

@end
