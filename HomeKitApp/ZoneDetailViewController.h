//
//  ZoneDetailViewController.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <HomeKit/HomeKit.h>

@interface ZoneDetailViewController : UITableViewController <UITableViewDataSource>

// strider
@property (strong, nonatomic) HMHome* pHMHome;
@property (strong, nonatomic) HMZone* pHMZone;
@property (strong, nonatomic) HMRoom* pRoomForAddition;
@property (strong, nonatomic) NSMutableArray* pRooms;

// strider
- (void)addRoomToZoneSegue;

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;


// strider
- (void)allOn;
- (void)allOff;

- (void)setCharacteristicValueTo:(bool) bSetValue;


@end

