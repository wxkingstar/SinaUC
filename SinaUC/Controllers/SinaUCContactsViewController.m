//
//  SinaUCContactsViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCContactsViewController.h"

@interface SinaUCContactsViewController ()

@end

@implementation SinaUCContactsViewController

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
    if (!contacts) {
        [xmpp setCDelegate:self];
        [xmpp registerCVcardUpdateDelegate:self];
        
        contacts = [[NSMutableArray alloc] init];
        iGroupRowCell = [[SinaUCListGroupCell alloc] init];
        
        [(NSOutlineView*)self.view setIntercellSpacing:NSMakeSize(0,0)];
        [(NSOutlineView*)self.view setTarget:self];
        [(NSOutlineView*)self.view setDoubleAction:@selector(onDoubleClick:)];
        [(NSOutlineView*)self.view setAction:@selector(onClick:)];
    }
}

- (void)updateRoster
{
    NSString *cgStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM ContactGroup" withValues:nil, nil];
    NSArray *contactGroupRes = [ZIMDbConnection dataSource:@"addressbook" query:cgStatement];
    for (NSDictionary *groupInfo in contactGroupRes) {
        NSMutableDictionary *group = [[NSMutableDictionary alloc] init];
        [group setValue:[groupInfo valueForKey:@"name"] forKey:@"name"];
        NSString *cStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Contact WHERE gid=?" withValues:[groupInfo valueForKey:@"pk"], nil];
        NSMutableArray *groupContacts = [NSMutableArray arrayWithArray:[ZIMDbConnection dataSource:@"addressbook" query:cStatement]];
        [group setObject:groupContacts forKey:@"children"];
        [contacts addObject:group];
    }
    [(NSOutlineView*)self.view reloadData];
}

- (void)updateVcard:(NSString*) jid
{
    for (NSDictionary* group in contacts) {
        for (NSDictionary* contact in [group objectForKey:@"children"]) {
            if ([[contact valueForKey:@"jid"] isEqualToString:jid]) {
                NSString *cStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Contact WHERE jid=?" withValues:jid, nil];
                NSArray *contactInfo = [ZIMDbConnection dataSource:@"addressbook" query:cStatement];
                NSInteger groupIndex = [contacts indexOfObject:group];
                NSInteger contactIndex = [[group valueForKey:@"children"] indexOfObject:contact];                
                [[[contacts objectAtIndex:groupIndex] objectForKey:@"children"] replaceObjectAtIndex:contactIndex withObject:[contactInfo objectAtIndex:0]];
                [(NSOutlineView*)self.view reloadData];
                break;
            }
        }
    }
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
        return [contacts count];
    }
    if ([item objectForKey:@"children"]) {
        return [[item objectForKey:@"children"] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [contacts objectAtIndex:index];
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
        return [NSString stringWithFormat:@"\t%@", [item valueForKey:@"name"]];
    }
    if ([[tableColumn identifier] isEqualToString:@"photo"]) {
        NSData* imageData = [item valueForKey:@"image"];
        if ([imageData length] > 0) {
            NSImage* image = [[NSImage alloc] initWithData:imageData];
            return image;
        }
        return [NSImage imageNamed:@"NSUser"];
    }
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
    NSTreeNode* node = [(NSOutlineView*)self.view itemAtRow:selected];
    /*NSManagedObject* object = [node representedObject];
    if ([[[object entity] valueForKey:@"name"] isEqualToString:@"Contact"] == YES) {
        NSString* jid = [object valueForKey:@"jid"];
        if (!jid) {
            return;
        }
        [xmpp startChat:jid];
    }*/
}

@end
