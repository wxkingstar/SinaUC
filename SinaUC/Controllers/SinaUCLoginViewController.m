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
}

- (IBAction) showTop:(id)sender
{
    //发送消息？
    [(SinaUCLoginView*)self.view setShowTop:YES];
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:YES];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:NO];
}

- (IBAction) hideTop:(id)sender
{
    [(SinaUCLoginView*)self.view setShowTop:NO];
    [[(SinaUCLoginView*)self.view valueForKey:@"showTopBtn"] setHidden:NO];
    [[(SinaUCLoginView*)self.view valueForKey:@"hideTopBtn"] setHidden:YES];
}

- (IBAction) login:(id)sender
{
}

@end
