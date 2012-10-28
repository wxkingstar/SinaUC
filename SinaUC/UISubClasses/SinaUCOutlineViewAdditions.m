//
//  SinaUCOutlineViewAdditions.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-26.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCOutlineViewAdditions.h"

@implementation NSOutlineView (AIOutlineViewAdditions)

- (id)firstSelectedItem
{
    NSInteger selectedRow = [self selectedRow];
	
    if (selectedRow >= 0 && selectedRow < [self numberOfRows]) {
        return [self itemAtRow:selectedRow];
    } else {
        return nil;
    }
}

//Redisplay an item (passing nil is the same as requesting a redisplay of the entire list)
- (void)redisplayItem:(id)item
{
	if (item) {
		NSInteger row = [self rowForItem:item];
		if (row >= 0 && row < [self numberOfRows]) {
			[self setNeedsDisplayInRect:[self rectOfRow:row]];
		}
	} else {
		[self setNeedsDisplay:YES];
	}
}

- (NSArray *)arrayOfSelectedItems
{
	NSMutableArray 	*itemArray = [NSMutableArray array];
	id 				item;
	
	//Apple wants us to do some pretty crazy stuff for selections in 10.3
	NSIndexSet *indices = [self selectedRowIndexes];
	NSUInteger bufSize = [indices count];
	NSUInteger *buf = malloc(bufSize * sizeof(NSUInteger));
	unsigned int i;
    
	NSRange range = NSMakeRange([indices firstIndex], ([indices lastIndex]-[indices firstIndex]) + 1);
	[indices getIndexes:buf maxCount:bufSize inIndexRange:&range];
    
	for (i = 0; i != bufSize; i++) {
		if ((item = [self itemAtRow:buf[i]])) {
			[itemArray addObject:item];
		}
	}
    
	free(buf);
    
	return itemArray;
}

- (void)selectItemsInArray:(NSArray *)selectedItems
{
	id  indexSet = [NSMutableIndexSet indexSet];
    
	//Build an index set
	[selectedItems enumerateObjectsUsingBlock:^(id selectedItem, NSUInteger idx, BOOL *stop) {
		NSUInteger selectedRow = [self rowForItem:selectedItem];
		if (selectedRow != NSNotFound) {
			[indexSet addIndex:selectedRow];
		}
	}];
    
	//Select the indexes
	[self selectRowIndexes:indexSet byExtendingSelection:NO];
}

@end