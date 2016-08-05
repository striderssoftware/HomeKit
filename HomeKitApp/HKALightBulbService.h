//
//  HKALightBulbService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#include "HKAService.h"
#include "ServiceProtocol.h"

@interface HKALightBulbService : HKAService <ServiceProtocol>

@property (strong, nonatomic) UILabel* pCurrentValueHueLabel;
@property (strong, nonatomic) UISlider* pHueSlider;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeHue;

@property (strong, nonatomic) UISlider* pSaturationSlider;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeSaturation;
@property (strong, nonatomic) UILabel* pCurrentValueSaturationLabel;

@property (strong, nonatomic) UISlider* pBrightnessSlider;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypeBrightness;
@property (strong, nonatomic) UILabel* pCurrentValueBrightnessLabel;

@property (strong, nonatomic) UISwitch* pSwitch;
@property (strong, nonatomic) HMCharacteristic* pHMCharacteristicTypePowerState;

- (void)setInitialControlValues;

- (void)UpdateHueState;
- (void)SetHueState;

- (void)UpdateSaturationState;
- (void)SetSaturationState;

- (void)UpdateBrightnessState;
- (void)SetBrightnessState;

- (UIView*)SetViewControls;

@end


