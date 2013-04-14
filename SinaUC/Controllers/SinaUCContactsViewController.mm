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
        contactsKV = [[NSMutableDictionary alloc] init];
        iGroupRowCell = [[SinaUCListGroupCell alloc] init];
        
        [(NSOutlineView*)self.view setIntercellSpacing:NSMakeSize(0,0)];
        [(NSOutlineView*)self.view setTarget:self];
        [(NSOutlineView*)self.view setDoubleAction:@selector(onDoubleClick:)];
        [(NSOutlineView*)self.view setAction:@selector(onClick:)];
    }
}

- (void)updateRoster
{
    [contacts removeAllObjects];
    NSArray *contactGroupRes;
    do {
        @try {
            NSString *cgStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM ContactGroup" withValues:nil, nil];
            contactGroupRes = [ZIMDbConnection dataSource:@"addressbook" query:cgStatement];
            break;
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    } while (1);

    int i = 0;
    for (NSDictionary *groupInfo in contactGroupRes) {
        NSMutableDictionary *group = [[NSMutableDictionary alloc] init];
        [group setValue:[groupInfo valueForKey:@"name"] forKey:@"name"];
        do {
            @try {
                NSString *cStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Contact WHERE gid=? ORDER BY presence" withValues:[groupInfo valueForKey:@"pk"], nil];
                NSArray *contactsRes = [ZIMDbConnection dataSource:@"addressbook" query:cStatement];
                int j = 0;
                for (NSDictionary *contactInfo in contactsRes) {
                    [contactsKV setObject:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i], @"g_idx",
                      [NSNumber numberWithInt:j++], @"c_idx",
                      nil]
                                   forKey:[contactInfo valueForKey:@"jid"]];
                }
                [group setObject:[NSMutableArray arrayWithArray:contactsRes] forKey:@"children"];
                [contacts addObject:group];
                break;
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        } while (1);
        i++;
    }
    [(NSOutlineView*)self.view reloadData];
}

- (void)updatePresence:(NSString*) jid
{
    NSString *cStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Contact WHERE jid=?" withValues:jid, nil];
    NSArray *contactInfo = [ZIMDbConnection dataSource:@"addressbook" query:cStatement];
    
    do {
        @try {
            [[[contacts objectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]] objectForKey:@"children"] removeObjectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"c_idx"] intValue]];
            if ([[[contactInfo objectAtIndex:0] valueForKey:@"presence"] intValue] <= 4) {
                [[[contacts objectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]] objectForKey:@"children"] insertObject:[contactInfo objectAtIndex:0] atIndex:0];
                for (NSString* idx in contactsKV) {
                    if (([[[contactsKV objectForKey:idx] valueForKey:@"g_idx"] intValue] == [[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]) && ([[[contactsKV objectForKey:idx] valueForKey:@"c_idx"] intValue] < [[[contactsKV objectForKey:jid] valueForKey:@"c_idx"] intValue])) {
                        NSNumber* newIdx = [NSNumber numberWithInt:[[[contactsKV objectForKey:idx] valueForKey:@"c_idx"] intValue]+1];
                        [[contactsKV objectForKey:idx] setValue:newIdx forKey:@"c_idx"];
                    }
                }
                [[contactsKV objectForKey:jid] setValue:[NSNumber numberWithInt:0] forKey:@"c_idx"];
            } else {
                NSNumber* lastIdx = [NSNumber numberWithLong:([[[contacts objectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]] objectForKey:@"children"] count]-1)];
                [[[contacts objectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]] objectForKey:@"children"] insertObject:[contactInfo objectAtIndex:0] atIndex:[lastIdx intValue]];
                for (NSString* idx in contactsKV) {
                    if (([[[contactsKV objectForKey:idx] valueForKey:@"g_idx"] intValue] == [[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]) && ([[[contactsKV objectForKey:idx] valueForKey:@"c_idx"] intValue] > [[[contactsKV objectForKey:jid] valueForKey:@"c_idx"] intValue])) {
                        NSNumber* newIdx = [NSNumber numberWithInt:[[[contactsKV objectForKey:idx] valueForKey:@"c_idx"] intValue]-1];
                        [[contactsKV objectForKey:idx] setValue:newIdx forKey:@"c_idx"];
                    }
                }
                [[contactsKV objectForKey:jid] setValue:lastIdx forKey:@"c_idx"];
            }
            [(NSOutlineView*)self.view reloadData];
            break;
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
        }
    } while (1);
}

- (void)updateVcard:(NSString*) jid
{
    NSString *cStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT * FROM Contact WHERE jid=?" withValues:jid, nil];
    NSArray *contactInfo = [ZIMDbConnection dataSource:@"addressbook" query:cStatement];
    [[[contacts objectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"g_idx"] intValue]] objectForKey:@"children"] replaceObjectAtIndex:[[[contactsKV objectForKey:jid] valueForKey:@"c_idx"] intValue] withObject:[contactInfo objectAtIndex:0]];
    [(NSOutlineView*)self.view reloadData];
    /*for (NSDictionary* group in contacts) {
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
    }*/
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
    if (tableColumn == nil && item && [item objectForKey:@"children"]) {
        return iGroupRowCell;
    }
	return nil;
}

- (id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if ([item objectForKey:@"children"]) {
        return [NSString stringWithFormat:@"\t%@", [item valueForKey:@"name"]];
    }
    if ([[tableColumn identifier] isEqualToString:@"photo"]) {
        NSData* imageData = [item valueForKey:@"image"];
        if ([imageData length] > 0) {
            if ([[item valueForKey:@"presence"] intValue] <= 4) {
                return [[NSImage alloc] initWithData:imageData];
            } else {
                return [[[NSImage alloc] initWithData:imageData] grayscaleImageWithAlphaValue:1.0 saturationValue:0.0 brightnessValue:0.0 contrastValue:0.8];
            }
        }
        return [NSImage imageNamed:@"NSUser"];
    }
    if ([[tableColumn identifier] isEqualToString:@"name"]) {
        [(SinaUCListNameCell*)[tableColumn dataCell] setTitle:[item valueForKey:@"name"]];
        [(SinaUCListNameCell*)[tableColumn dataCell] setSubTitle:[item valueForKey:@"mood"]];
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
        } else {
            [(NSOutlineView*)self.view expandItem:node];
        }
    }
}

- (void) onDoubleClick:(id) sender
{
    NSInteger selected = [(NSOutlineView*)self.view selectedRow];
    NSDictionary* contact = [(NSOutlineView*)self.view itemAtRow:selected];
    
    if ([contact valueForKey:@"jid"]) {
        [xmpp iStartChat:contact];
    }
}

@end
