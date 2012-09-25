//
//  SinaUCAppDelegate.h
//  SinaUC
//
//  Created by 陈 硕实 on 12-9-23.
//  Copyright (c) 2012年 陈 硕实. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Protocols/SinaUCActivateProtocol.h"

@interface SinaUCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *loginWindow;
@property (assign) IBOutlet NSWindow *launchedWindow;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain) NSMutableArray *activeDelegates;

- (IBAction)saveAction:(id)sender;
- (IBAction)login:(id)sender;
- (void)applicationDidResignActive:(NSNotification *)aNotification;
- (void)applicationDidBecomeActive:(NSNotification *)aNotification;
- (void)registerActive:(id <SinaUCActivateProtocol>)view;

@end
