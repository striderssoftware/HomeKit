//
//  HKAService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKAService.h"

//because this class is its own factory
#import "HKASwitchService.h"
#import "HKALightBulbService.h"
#import "HKAOutletService.h"
#import "HKALockService.h"
#import "HKAThermostatService.h"
#import "HKAGarageDoorOpenerService.h"

@interface HKAService ()

@end

@implementation HKAService

@synthesize pHMService;

// Factory nethod
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (id<ServiceProtocol>)create:(HMService *)pHMService
{
	if ( [[pHMService serviceType]  isEqualToString:HMServiceTypeSwitch] )
	{
		return [[HKASwitchService alloc] init];
	}
	else if ( [pHMService.serviceType  isEqualToString:HMServiceTypeLightbulb] )
	{
		return [[HKALightBulbService alloc] init];
	}
	else if ( [pHMService.serviceType  isEqualToString:HMServiceTypeOutlet] )
	{
		return [[HKAOutletService alloc] init];
	}
	else if ( [pHMService.serviceType  isEqualToString:HMServiceTypeLockMechanism] )
	{
		return [[HKALockService alloc] init];
	}
	else if ( [pHMService.serviceType  isEqualToString:HMServiceTypeThermostat] )
	{
		return [[HKAThermostatService alloc] init];
	}
	else if ( [pHMService.serviceType  isEqualToString:HMServiceTypeGarageDoorOpener] )
	{
		return [[HKAGarageDoorOpenerService alloc] init];
	}
	else
	{
		//TODO - Maybe return a this, make a do nothing implementation of all public facing methods.
		return nil;
	}
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSString*)GetName
{
	return self.pHMService.name;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UILabel*)CreateLabel:(NSString*) szLabel ofColor:(UIColor*) pColor forView:(UIView*) pView
{
    UILabel* pLabel = [[UILabel alloc] init];
    [pLabel setText:szLabel];
    [pLabel setTextColor:pColor];
    [pLabel setBackgroundColor:[UIColor blueColor]];
    pLabel.font = [UIFont boldSystemFontOfSize:18.0f];

    [pLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pView addSubview:pLabel];
    
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    return pLabel;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UISwitch*)CreateSwitchwithSelector:(SEL) pSelector forView:(UIView*) pView
{
    UISwitch* pSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [pSwitch addTarget:self action:pSelector forControlEvents:UIControlEventTouchUpInside];
    
    [pSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pView addSubview:pSwitch];
    
    [pSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pSwitch setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    return pSwitch;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UISlider*)CreateSliderWithMinValue:(float) fMin MaxValue:(float) fMax SetSelector:(SEL) pSetSelector andUpdateSelector:(SEL) pUpdateSelector forView:(UIView*) pView
{
    UISlider* pTemperatureSlider = [[UISlider alloc] init];
    pTemperatureSlider.minimumValue = fMin;
    pTemperatureSlider.maximumValue = fMax;
    pTemperatureSlider.continuous = YES;
  //  pTemperatureSlider.value = 25.0;
    [pTemperatureSlider addTarget:self action:pSetSelector forControlEvents:UIControlEventTouchUpInside];
    [pTemperatureSlider addTarget:self action:pUpdateSelector forControlEvents:UIControlEventValueChanged];
    
    [pTemperatureSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pView addSubview:pTemperatureSlider];
    
    [pTemperatureSlider setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pTemperatureSlider setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    return pTemperatureSlider;
}

//TODO - remove if not used
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetLabel:(UILabel*) pLabel withName:(NSString*) szName forView:(UIView*) pView
{
    [pLabel setText:szName];
    [pLabel setTextColor:[UIColor whiteColor]];
    [pLabel setBackgroundColor:[UIColor blueColor]];
    pLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [pLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pView addSubview:pLabel];
    
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [pLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}

//Enable Notifications
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)EnableNotifications:(HMCharacteristic*) pHMCharacterisitic
{
    [pHMCharacterisitic  enableNotification:YES completionHandler:^(NSError *error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Enabled Notifications");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// HMAccessoryDelegate
- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service
{
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
}

@end
