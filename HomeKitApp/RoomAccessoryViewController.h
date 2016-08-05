//
//  RoomAccessoryViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface RoomAccessoryViewController : UITableViewController <UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) HMRoom* pHMRoom;
@property (strong, nonatomic) HMHome* pHMHome;
@property (strong, nonatomic) NSMutableArray* pAccessorysList;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;

// Strider
- (void)deleteAccessory:(HMAccessory*) pHMAccessory;

@end
