//
//  SinaUCLaunchedViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-10-6.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLaunchedViewController.h"

@interface SinaUCLaunchedViewController ()

@end

@implementation SinaUCLaunchedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) awakeFromNib
{
    [xmpp registerConnectionDelegate:self];
}

- (void) willConnect
{
}

- (void) didDisConnectedWithError:(NSInteger) error
{
}

- (void) didConnectedWithJid:(NSString*) jid
{
}

@end
