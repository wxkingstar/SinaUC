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
    [loginBtn setOrigImage:@"LoginWindow_LoginBtn_Hover"];
    [loginBtn setHoverImage:@"LoginWindow_LoginBtn_Normal"];
    [loginBtn setAlternateImage:[NSImage imageNamed:@"LoginWindow_LoginBtn_Click"]];

    [moreBtn setOrigImage:@"LoginWindow_DownArrow_Normal"];
    [moreBtn setHoverImage:@"LoginWindow_DownArrow_Hover"];
    [moreBtn setAlternateImage:[NSImage imageNamed:@"LoginWindow_DownArrow_Click"]];
}

- (IBAction) showMore:(id)sender
{
    NSLog(@"showmore");
}

- (IBAction) login:(id)sender
{
}

@end
