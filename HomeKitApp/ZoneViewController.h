//
//  ZoneViewController.h
//  ZoneKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

@interface ZoneViewController : UITableViewController <UITableViewDataSource,  UIAlertViewDelegate>

@property (strong, nonatomic)  NSMutableArray* zones;
@property (strong, nonatomic) HMHome* pHMHome;

// strider
- (void)addZone;
- (void)deleteZone:(HMZone *) pHMZone atIndexPath:(NSIndexPath *)indexPath;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

