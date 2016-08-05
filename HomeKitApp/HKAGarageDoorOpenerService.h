//
//  HKAGarageDoorOpenerService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#include "HKAService.h"
#include "ServiceProtocol.h"

@interface HKAGarageDoorOpenerService : HKAService <ServiceProtocol>

@property (strong, nonatomic) UISwitch* pTargetDoorSwitch;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeTargetDoorState;

@property (strong, nonatomic) UISwitch* pTargetLockSwitch;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeTargetLockMechanismState;

@property (strong, nonatomic) UILabel* pObstructionDetectedLabel;
@property (strong, nonatomic) UILabel* pCurrentDoorStateLabel;
@property (strong, nonatomic) UILabel* pCurrentLockStateLabel;

- (void)setInitialControlValues;
- (void)SetGarageDoorOpenerState;
- (void)SetGarageDoorLockState;
- (UIView*)SetViewControls;

@end
