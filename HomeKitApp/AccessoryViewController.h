//
//  AccessoryViewController.h
//  HomeKitApp
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface AccessoryViewController : UITableViewController <UITableViewDataSource, HMAccessoryBrowserDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) HMRoom* pHMRoom;
@property (strong, nonatomic) HMHome* pHMHome;
@property (strong, nonatomic) HMAccessoryBrowser* pHMAccessoryBrowser;
@property (strong, nonatomic) NSMutableArray* AccessorysList;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

// HMAccessoryBrowserDelegate
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory;
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory;

//- (void) clickedButtonAtIndex:
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

