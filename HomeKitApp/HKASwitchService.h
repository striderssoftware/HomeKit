//
//  HKASwitchService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#include "HKAService.h"
#include "ServiceProtocol.h"

@interface HKASwitchService : HKAService <ServiceProtocol>

@property (strong, nonatomic) UISwitch* pSwitch;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypePowerState;

- (void)SetSwitchState;
- (UIView*)SetViewControls;
- (void)setInitialControlValues;

@end
