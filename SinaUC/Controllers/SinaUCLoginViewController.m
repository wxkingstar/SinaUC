//
//  SinaUCLoginViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginViewController.h"

@interface SinaUCLoginViewController ()

@end

@implementation SinaUCLoginViewController

@synthesize loginBtn;
@synthesize moreBtn;

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
    [loginBtn setImage:[NSImage imageNamed:@"LoginWindow_LoginBtn_Normal"]];
    [loginBtn setAlternateImage:[NSImage imageNamed:@"LoginWindow_LoginBtn_Hover"]];
    [loginBtn setImagePosition:NSImageOnly];
    [loginBtn setBordered:NO];
    [loginBtn.cell setShowsStateBy:NSPushInCellMask];
    [loginBtn.cell setHighlightsBy:NSContentsCellMask];

    [moreBtn setImage:[NSImage imageNamed:@"LoginWindow_DownArrow_Normal"]];
    [moreBtn setAlternateImage:[NSImage imageNamed:@"LoginWindow_DownArrow_Hover"]];
    [moreBtn setImagePosition:NSImageOnly];
    [moreBtn setBordered:NO];
    [moreBtn.cell setShowsStateBy:NSPushInCellMask];
    [moreBtn.cell setHighlightsBy:NSContentsCellMask];
}

- (IBAction) showMore:(id)sender
{
    NSLog(@"showmore");
}

- (IBAction) login:(id)sender
{
}

@end
