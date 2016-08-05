//
//  HomeViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface HomeViewController : UITableViewController <UITableViewDataSource, HMHomeManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) HMHomeManager* pHMHomeManager;
@property (strong, nonatomic) NSMutableArray* pHomesList;

// strider
- (void)addHome;
- (void)setPrimaryHome:(HMHome *)pHMHome;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

// HMHomeManagerDelegate
- (void) homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home;
- (void) homeManager:(HMHomeManager *)manager didRemoveHome:(HMHome *)home;
- (void) homeManagerDidUpdateHomes:(HMHomeManager *)manager;
- (void) homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

