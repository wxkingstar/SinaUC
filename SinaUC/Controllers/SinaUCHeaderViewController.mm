//
//  SinaUCHeaderViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-14.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCHeaderViewController.h"

@interface SinaUCHeaderViewController ()

@end

@implementation SinaUCHeaderViewController

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
    [xmpp registerSVcardUpdateDelegate:self];
}

- (void)updateVcard
{
    NSString *sVcardStatement = [ZIMSqlPreparedStatement preparedStatement: @"SELECT pk, nickname, headimg FROM User WHERE jid = ?;" withValues:[xmpp myJid], nil];
    NSArray *sVcardResult = [ZIMDbConnection dataSource:@"user" query:sVcardStatement];
    [[self.view valueForKey:@"myHeadImg"] setImage:[[NSImage alloc] initWithData:[[sVcardResult objectAtIndex:0] valueForKey:@"headimg"]]];
    [[self.view valueForKey:@"nickname"] setStringValue:[[sVcardResult objectAtIndex:0] valueForKey:@"nickname"]];
}

@end
