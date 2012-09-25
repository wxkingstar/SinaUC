//
//  SinaUCLoginViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SinaUCButton.h"

@interface SinaUCLoginViewController : NSViewController

@property (retain) IBOutlet SinaUCButton *loginBtn;
@property (retain) IBOutlet SinaUCButton *moreBtn;

- (IBAction) showMore:(id)sender;
- (IBAction) login:(id)sender;

@end
