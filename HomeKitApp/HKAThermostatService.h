//
//  HKAThermostatService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#include "HKAService.h"
#include "ServiceProtocol.h"

@interface HKAThermostatService : HKAService <ServiceProtocol>

@property (strong, nonatomic) UILabel* pCurrentTemperatureLabel;

@property (strong, nonatomic) UILabel* pCurrentValueTemperatureLabel;
@property (strong, nonatomic) UISlider* pTemperatureSlider;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeTargetTemperature;

@property (strong, nonatomic) UILabel* pCurrentHumidityLabel;

@property (strong, nonatomic) UISlider* pHumiditySlider;
@property (strong, nonatomic) UILabel* pCurrentValueHumidityLabel;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeTargetRelativeHumidity;

- (void)setInitialControlValues;

- (void)UpdateTemperatureState;
- (void)SetTemperatureState;

- (void) UpdateHumidityState;
- (void) SetHumidityState;

- (UIView*)SetViewControls;

@end
