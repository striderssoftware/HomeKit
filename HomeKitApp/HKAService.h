//
//  HKAService.h
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#ifndef HKAService_h
#define HKAService_h

#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>

#import "ServiceProtocol.h"

@interface HKAService : NSObject <HMAccessoryDelegate>

// Factory Method
+ (id<ServiceProtocol>)create:(HMService *)pHMService;

@property (strong, nonatomic) HMService* pHMService;

// strider
- (NSString*)GetName;
- (UILabel*)CreateLabel:(NSString*) szLabel ofColor:(UIColor*) pColor forView:(UIView*) pView;
- (UISwitch*)CreateSwitchwithSelector:(SEL) pSelector forView:(UIView*) pView;
- (UISlider*)CreateSliderWithMinValue:(float) fMin MaxValue:(float) fMax SetSelector:(SEL) pSetSelector andUpdateSelector:(SEL) pUpdateSelector forView:(UIView*) pView;
//TODO - remove if not used
- (void)SetLabel:(UILabel*) pLabel withName:(NSString*) szName forView:(UIView*) pView;
- (void)EnableNotifications:(HMCharacteristic*) pHMCharacterisitic;

// HMAccessoryDelegate
- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service;
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic;

@end

#endif

