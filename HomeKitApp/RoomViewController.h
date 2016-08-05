//
//  RoomViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@class ZoneDetailViewController;

@interface RoomViewController : UITableViewController <UITableViewDataSource, HMHomeManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) HMHomeManager* pHMHomeManager;
@property (strong, nonatomic) HMHome* pHMHome;
@property (strong, nonatomic) ZoneDetailViewController* pHMZoneDetialViewController;
@property (strong, nonatomic) NSMutableArray* pRoomsList;
@property (strong, nonatomic) NSMutableArray* pHomesList;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

// HMHomeManagerDelegate
//- (void) homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home;
//- (void) homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home;
- (void) homeManagerDidUpdateHomes:(HMHomeManager *)manager;
- (void) homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager;

// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end