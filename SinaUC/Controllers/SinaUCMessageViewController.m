//
//  SinaUCMessageViewController.m
//  SinaUC
//
//  Created by 陈 硕实 on 12-11-11.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import "SinaUCMessageViewController.h"
#import "SinaUCMessage.h"
#import "SinaUCTextView.h"

@interface SinaUCMessageViewController ()

@end

@implementation SinaUCMessageViewController

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
    messages = [[NSMutableArray alloc] init];
    [input setTarget:self];
    [input setAction:@selector(send:)];
    //messageDisplayController = [SinaUCWebKitMessageViewController messageDisplayControllerForChat];
}

- (IBAction)send:(id)sender
{
    NSLog(@"%@", [input string]);
    SinaUCMessage *msg = [[SinaUCMessage alloc] init];
    [msg setMessage:[input string]];
    //[msg setRecevier:];
    //[msg setSender:];
    [messages addObject:msg];
}

@end
