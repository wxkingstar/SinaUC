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

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
		//return [[groupManager groups] objectAtIndex:index];
	}
    if ([item isKindOfClass:[ContactGroup class]]) {
        //return [[item contacts] objectAtIndex:index];
    }
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([item isKindOfClass:[ContactGroup class]]) {
        return YES;
    }
	return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
		//return [[groupManager groups] count];
	}
    if ([item isKindOfClass:[ContactGroup class]]) {
        //return [[item contacts] count];
    }
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    /*NSManagedObject* obj = [item representedObject];
    BOOL group = [[[obj entity] name] isEqualToString:@"ContactGroup"];
    if (group) {
        NSString* name = [NSString stringWithFormat:@"\t%@", [obj valueForKey:@"name"]];
        return name;
    }
    if ([[tableColumn identifier] isEqualToString:@"photo"]) {
        NSData* imageData = [obj valueForKey:@"photo"];
        if (imageData) {
            NSImage* image = [[[NSImage alloc] initWithData:imageData] autorelease];
            return image;
        }
        return [NSImage imageNamed:@"NSUser"];
    }
    if ([[tableColumn identifier] isEqualToString:@"name"]) {
        [(BuddyCell*)[tableColumn dataCell] setTitle:[obj valueForKey:@"name"]];
        [(BuddyCell*)[tableColumn dataCell] setSubTitle:[obj valueForKey:@"jid"]];
        return [obj valueForKey:@"name"];
    }
    if ([[tableColumn identifier] isEqualToString:@"status"]) {
        return [ContactItem statusImage:[[obj valueForKey:@"presence"] integerValue]];
    }*/
    return nil;
}

@end
