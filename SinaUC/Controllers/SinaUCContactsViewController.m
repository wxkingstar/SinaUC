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
        
        contacts = [[NSMutableArray alloc] init];
        iGroupRowCell = [[NSTextFieldCell alloc] init];
        [iGroupRowCell setEditable:NO];
        [iGroupRowCell setLineBreakMode:NSLineBreakByTruncatingTail];
        
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
        NSArray *groupContacts = [ZIMDbConnection dataSource:@"addressbook" query:cStatement];
        [group setObject:groupContacts forKey:@"contacts"];        
        [contacts addObject:group];
    }
    [(NSOutlineView*)self.view reloadData];
    /*
     ({name=xx, contacts=()}, {name=xx, contacts=()})
     */
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item valueForKey:@"contacts"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if ([item valueForKey:@"contacts"]) {
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat) outlineView:(NSOutlineView*) outlineView heightOfRowByItem:(id) item
{
    if ([item valueForKey:@"contacts"]) {
        return 20;
    } else {
        return 42;
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [contacts count];
    }
    if ([item valueForKey:@"contacts"]) {
        return [[item objectForKey:@"contacts"] count];
    }
    return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) { //item is nil when the outline view wants to inquire for root level items
        return [contacts objectAtIndex:index];
    }
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [[item objectForKey:@"contacts"] objectAtIndex:index];
    }
    return nil;
}

- (NSCell*) outlineView:(NSOutlineView*) outlineView dataCellForTableColumn:(NSTableColumn*)tableColumn item:(id) item
{
    if (tableColumn == nil && [item valueForKey:@"contacts"]) {
        return iGroupRowCell;
    }
	return nil;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item
{
    
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item valueForKey:@"contacts"]) {
        return [item valueForKey:@"name"];
    }
    if ([[tableColumn identifier] isEqualToString:@"photo"]) {
        return [NSImage imageNamed:@"NSUser"];
        NSData* imageData = [item valueForKey:@"image"];
        if (imageData) {
            NSImage* image = [[NSImage alloc] initWithData:imageData];
            return image;
        }
    }
    if ([[tableColumn identifier] isEqualToString:@"name"]) {
        /*[(BuddyCell*)[tableColumn dataCell] setTitle:[obj valueForKey:@"name"]];
        [(BuddyCell*)[tableColumn dataCell] setSubTitle:[obj valueForKey:@"jid"]];*/
        return [item valueForKey:@"name"];
    }
    /*if ([[tableColumn identifier] isEqualToString:@"status"]) {
        return [ContactItem statusImage:[[obj valueForKey:@"presence"] integerValue]];
    }*/
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
