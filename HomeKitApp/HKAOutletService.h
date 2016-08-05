//
//  HKAOutletService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#import "ServiceProtocol.h"
#import "HKAService.h"

@interface HKAOutletService : HKAService <ServiceProtocol>

@property (strong, nonatomic) HMCharacteristic* pPowerStateCharacteristic;
@property (strong, nonatomic) HMCharacteristic* pInUseCharacteristic;

@property (strong, nonatomic) UISwitch* pSwitch;
@property (strong, nonatomic) UILabel* pInUseLabel;

- (void)SetOutletState;
- (UIView*)SetViewControls;
- (void)setInitialControlValues;

@end
