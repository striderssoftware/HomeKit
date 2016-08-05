//
//  AccessoryDetailViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <HomeKit/HomeKit.h>

@interface AccessoryDetailViewController : UITableViewController <UITableViewDataSource>

// strider
@property (strong, nonatomic) HMHome* pHMHome;
@property (strong, nonatomic) HMAccessory* pHMAccessory;
@property (strong, nonatomic) NSMutableArray* pServiceContainer;
@property (strong, nonatomic) NSMutableArray* pViewContainer;
@property (strong, nonatomic) UIView* pLastViewLayout;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;

@end

