//
//  SinaUCOutlineViewAdditions.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-26.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOutlineView (SinaUCOutlineViewAdditions)

- (id)firstSelectedItem;
- (NSArray *)arrayOfSelectedItems;
- (void)selectItemsInArray:(NSArray *)selectedItems;
- (void)redisplayItem:(id)item;

@end
