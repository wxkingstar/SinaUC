//
//  SinaUCLoginViewController.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SinaUCButton;
@class SinaUCLoginView;
@interface SinaUCLoginViewController : NSViewController

@property (retain) IBOutlet SinaUCButton *loginBtn;
@property (retain) IBOutlet SinaUCButton *showTopBtn;
@property (retain) IBOutlet SinaUCButton *hideTopBtn;

- (IBAction) showTop:(id)sender;
- (IBAction) hideTop:(id)sender;
- (IBAction) login:(id)sender;

@end
