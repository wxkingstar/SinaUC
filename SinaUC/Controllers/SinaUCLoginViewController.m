//
//  SinaUCLoginViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCLoginViewController.h"
#import "SinaUCLoginView.h"

@interface SinaUCLoginViewController ()

@end

@implementation SinaUCLoginViewController

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
    [[(SinaUCLoginView*)self.view valueForKey:@"myHeadimg"] setImage:[NSImage imageNamed:@"LoginWindow_BigDefaultHeadImage"]];
}

- (IBAction) showTop:(id)sender
{
    //发送消息？
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:YES];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:NO];
    [NSAnimationContext beginGrouping];
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay];
    [[[(SinaUCLoginView*)self.view valueForKey:@"backgroundDownsideView"] animator] setFrame:NSMakeRect(0, 0, 256, 109)];
    [NSAnimationContext endGrouping];
}

- (IBAction) hideTop:(id)sender
{
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:NO];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:YES];
    [NSAnimationContext beginGrouping];
    NSTimeInterval delay = [[NSAnimationContext currentContext] duration];
    [[NSAnimationContext currentContext] setDuration:delay];
    [[[(SinaUCLoginView*)self.view valueForKey:@"backgroundDownsideView"] animator] setFrame:NSMakeRect(0, 80, 256, 29)];
    [NSAnimationContext endGrouping];
}

- (IBAction) login:(id)sender
{
}

@end
