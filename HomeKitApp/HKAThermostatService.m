//
//  HKAThermostatService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKAThermostatService.h"

#define UI_TEMPERATURE_COLOR greenColor
#define UI_HUMIDITY_COLOR cyanColor

@interface HKAThermostatService ()


@end

@implementation HKAThermostatService

@synthesize pCurrentTemperatureLabel;
@synthesize pTemperatureSlider;
@synthesize pCurrentHumidityLabel;
@synthesize pHumiditySlider;
@synthesize pCurrentValueHumidityLabel;
@synthesize pCurrentValueTemperatureLabel;

@synthesize pHMCharacteristicTypeTargetTemperature;
@synthesize pHMCharacteristicTypeTargetRelativeHumidity;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];
    
    //TODO - fix this - totally unacceptable hack to get the sliders to be longer
    UILabel* pNameLabel = [self CreateLabel:@"                    Thermostat                    " ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pCurrentTemperatureLabel = [self CreateLabel:@"Door Lock Control" ofColor:[UIColor whiteColor] forView:pSubView];
	
    UILabel* pTemperatureLabel = [self CreateLabel:@"Temperature" ofColor:[UIColor UI_TEMPERATURE_COLOR] forView:pSubView];
    
    self.pTemperatureSlider = [self CreateSliderWithMinValue:10.0 MaxValue:30.0 SetSelector:@selector(SetTemperatureState) andUpdateSelector:@selector(UpdateTemperatureState)forView:pSubView];
    
    self.pCurrentValueTemperatureLabel = [self CreateLabel:@"15" ofColor:[UIColor UI_TEMPERATURE_COLOR] forView:pSubView];
	
    self.pCurrentHumidityLabel = [self CreateLabel:@"Current Humidity:0" ofColor:[UIColor whiteColor] forView:pSubView];
	
    UILabel* pHumidityLabel = [self CreateLabel:@"Humidity" ofColor:[UIColor UI_HUMIDITY_COLOR] forView:pSubView];
	
    self.pHumiditySlider = [self CreateSliderWithMinValue:0.0 MaxValue:100 SetSelector:@selector(SetHumidityState) andUpdateSelector:@selector(UpdateHumidityState) forView:pSubView];
	
    self.pCurrentValueHumidityLabel = [self CreateLabel:@"0" ofColor:[UIColor UI_HUMIDITY_COLOR] forView:pSubView];
	
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pCurrentTemperatureLabel, pTemperatureLabel, pTemperatureSlider, pCurrentValueTemperatureLabel, pCurrentHumidityLabel, pHumidityLabel, pHumiditySlider, pCurrentValueHumidityLabel);
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pCurrentTemperatureLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pTemperatureLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pTemperatureSlider]-10-[pCurrentValueTemperatureLabel]-0-|"
											 options : NSLayoutFormatAlignAllCenterY
											 metrics : nil
											   views : pViewDictionary]];
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pCurrentHumidityLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pHumidityLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pHumiditySlider]-10-[pCurrentValueHumidityLabel]-0-|"
											 options : NSLayoutFormatAlignAllCenterY
											 metrics : nil
											   views : pViewDictionary]];
	
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pCurrentTemperatureLabel]-10-[pTemperatureLabel]-0-[pTemperatureSlider]-25-[pCurrentHumidityLabel]-10-[pHumidityLabel]-0-[pHumiditySlider]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	[pSubView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
	
	
	[pSubView setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	[self setInitialControlValues];
	
	return pSubView;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)UpdateTemperatureState
{
	[self.pCurrentValueTemperatureLabel setText:[NSString stringWithFormat:@"%d", (int)self.pTemperatureSlider.value]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetTemperatureState
{
    NSNumber* temp = [NSNumber numberWithInt:(int)self.pTemperatureSlider.value];
    [self.pHMCharacteristicTypeTargetTemperature writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled Thermostate Temperature Control");
        }
    }];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)UpdateHumidityState
{
	[self.pCurrentValueHumidityLabel setText:[NSString stringWithFormat:@"%d", (int)self.pHumiditySlider.value]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetHumidityState
{
    NSNumber* temp = [NSNumber numberWithInt:(int)self.pHumiditySlider.value];
    [self.pHMCharacteristicTypeTargetRelativeHumidity writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled Lightbulb Saturation Control");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setInitialControlValues
{
	for ( int j =0; j < self.pHMService.characteristics.count; j++ )
	{
		HMCharacteristic* characteristic = [self.pHMService.characteristics objectAtIndex:j];
		NSLog(@"toggleAccessoryState: characteristic value is::%@", characteristic.value);
		NSLog(@"toggleAccessoryState: characteristic type is::%@", characteristic.characteristicType);
        
        [self EnableNotifications:characteristic];
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentTemperature] )
		{
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
                }
				else
				{
					NSLog(@"set initial temp Control");
                    self.pCurrentTemperatureLabel.text =[[NSString alloc] initWithFormat:@"Current Temp:  %ld", (long)[characteristic.value integerValue]];
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetTemperature] )
		{
            self.pHMCharacteristicTypeTargetTemperature = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
					self.pTemperatureSlider.value = (int)0;
				}
				else
				{
					NSLog(@"set initial temp Control");
					self.pTemperatureSlider.value = [characteristic.value integerValue];
                    [self.pTemperatureSlider setTintColor:[UIColor UI_TEMPERATURE_COLOR]];
					[self UpdateTemperatureState];
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentRelativeHumidity] )
		{
            [characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"set initial current humidity Control");
					self.pCurrentHumidityLabel.text =[[NSString alloc] initWithFormat:@"Current Humidity:  %ld", (long)[characteristic.value integerValue]];
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetRelativeHumidity] )
		{
            self.pHMCharacteristicTypeTargetRelativeHumidity = characteristic;
            
            [characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
					self.pHumiditySlider.value = (int)0;
				}
				else
				{
					NSLog(@"Set initial target humidity Control");
					self.pHumiditySlider.value = [characteristic.value integerValue];
                    [self.pHumiditySlider setTintColor:[UIColor UI_HUMIDITY_COLOR]];
                    [self UpdateHumidityState];
				}
			}];
		}
	}
}

// NOTIFICATION HANDELRS
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)accessory:(HMAccessory *)accessory didUpdateAssociatedServiceTypeForService:(HMService *)service
{
    // Do Nothing
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)accessory:(HMAccessory *)accessory service:(HMService *)service didUpdateValueForCharacteristic:(HMCharacteristic *)characteristic
{
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetTemperature] )
    {
        NSLog(@"Notification temp Control");
        self.pTemperatureSlider.value = [characteristic.value integerValue];
        [self UpdateTemperatureState];

    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetRelativeHumidity] )
    {
        NSLog(@"Notificatin humidity Control");
        self.pHumiditySlider.value = [characteristic.value integerValue];
        [self UpdateHumidityState];
    }
    
     
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentTemperature] )
    {
        NSLog(@"Notified initial temp Control");
        self.pCurrentTemperatureLabel.text =[[NSString alloc] initWithFormat:@"Current Temp:  %ld", (long)[characteristic.value integerValue]];
        
    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentRelativeHumidity] )
    {
        NSLog(@"notified current humidity Control");
        self.pCurrentHumidityLabel.text =[[NSString alloc] initWithFormat:@"Current Humidity: %ld", (long)[characteristic.value integerValue]];

    }
}

@end
