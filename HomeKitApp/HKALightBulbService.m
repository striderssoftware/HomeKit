//
//  HKALightBulbService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKALightBulbService.h"

#define UI_HUE_COLOR redColor
#define UI_SATURATION_COLOR cyanColor
#define UI_BRIGHTNESS_COLOR whiteColor

@interface HKALightBulbService ()

@end

@implementation HKALightBulbService

@synthesize pHueSlider;
@synthesize pCurrentValueHueLabel;
@synthesize pSaturationSlider;
@synthesize pCurrentValueSaturationLabel;
@synthesize pBrightnessSlider;
@synthesize pCurrentValueBrightnessLabel;
@synthesize pSwitch;
@synthesize pHMCharacteristicTypeSaturation;
@synthesize pHMCharacteristicTypePowerState;
@synthesize pHMCharacteristicTypeHue;
@synthesize pHMCharacteristicTypeBrightness;


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];
	
    //totally unacceptable hack to get the sliders to be longer.
    UILabel* pNameLabel = [self CreateLabel:@"                    Light Bulb                   " ofColor:[UIColor whiteColor]forView:pSubView];
	
    UILabel* pHueLabel = [self CreateLabel:@"Hue" ofColor:[UIColor UI_HUE_COLOR] forView:pSubView];
    
    self.pHueSlider = [self CreateSliderWithMinValue:0.0 MaxValue:360.0 SetSelector:@selector(SetHueState) andUpdateSelector:@selector(UpdateHueState) forView:pSubView];
	
    self.pCurrentValueHueLabel = [self CreateLabel:@"15" ofColor:[UIColor UI_HUE_COLOR] forView:pSubView];

    UILabel* pSaturationLabel = [self CreateLabel:@"Saturation" ofColor:[UIColor UI_SATURATION_COLOR] forView:pSubView];
    
    self.pSaturationSlider = [self CreateSliderWithMinValue:0.0 MaxValue:100.0 SetSelector:@selector(SetSaturationState) andUpdateSelector:@selector(UpdateSaturationState) forView:pSubView];
	
    self.pCurrentValueSaturationLabel = [self CreateLabel:@"15" ofColor:[UIColor UI_SATURATION_COLOR] forView:pSubView];
    
    UILabel* pBrightnessLabel = [self CreateLabel:@"Brightness" ofColor:[UIColor UI_BRIGHTNESS_COLOR] forView:pSubView];
    
    self.pBrightnessSlider = [self CreateSliderWithMinValue:0.0 MaxValue:100.0 SetSelector:@selector(SetBrightnessState) andUpdateSelector:@selector(UpdateBrightnessState) forView:pSubView];
	
    self.pCurrentValueBrightnessLabel = [self CreateLabel:@"15" ofColor:[UIColor UI_BRIGHTNESS_COLOR]forView:pSubView];
	
    UILabel* pSwitchLabel = [self CreateLabel:@"Switch" ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pSwitch = [self CreateSwitchwithSelector:@selector(SetSwitchState) forView:pSubView];
	
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pHueLabel, pHueSlider, pCurrentValueHueLabel, pSaturationLabel, pSaturationSlider, pCurrentValueSaturationLabel, pBrightnessLabel, pBrightnessSlider, pCurrentValueBrightnessLabel, pSwitchLabel, pSwitch);

	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pHueLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pHueSlider]-10-[pCurrentValueHueLabel]-0-|"
											 options : NSLayoutFormatAlignAllCenterY
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pSaturationLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pSaturationSlider]-10-[pCurrentValueSaturationLabel]-0-|"
											 options : NSLayoutFormatAlignAllCenterY
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pBrightnessLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pBrightnessSlider]-10-[pCurrentValueBrightnessLabel]-0-|"
											 options : NSLayoutFormatAlignAllCenterY
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pSwitchLabel]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pSwitch]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pHueLabel]-0-[pHueSlider]-15-[pSaturationLabel]-0-[pSaturationSlider]-15-[pBrightnessLabel]-0-[pBrightnessSlider]-15-[pSwitchLabel]-0-[pSwitch]-0-|"
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
- (void)setInitialControlValues
{
	for ( int j =0; j < self.pHMService.characteristics.count; j++ )
	{
		HMCharacteristic* characteristic = [self.pHMService.characteristics objectAtIndex:j];
		NSLog(@"toggleAccessoryState: characteristic value is::%@", characteristic.value);
		
		NSLog(@"toggleAccessoryState: characteristic type is::%@", characteristic.characteristicType);
		
        
        [self EnableNotifications:characteristic];
        
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHue] )
		{
            self.pHMCharacteristicTypeHue = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried Lightbulb Hue Control");
                    [self.pHueSlider setValue:[characteristic.value integerValue]];
                    [self.pHueSlider setTintColor:[UIColor UI_HUE_COLOR]];
					[self UpdateHueState];
				}
			}];
		}
		else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeSaturation] )
		{
            self.pHMCharacteristicTypeSaturation = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried Lightbulb Hue Control");
					self.pSaturationSlider.value = [characteristic.value integerValue];
                    [self.pSaturationSlider setTintColor:[UIColor UI_SATURATION_COLOR]];
					[self UpdateSaturationState];
				}
			}];
		}
		else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeBrightness] )
		{
            self.pHMCharacteristicTypeBrightness = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried Lightbulb Hue Control");
					self.pBrightnessSlider.value = [characteristic.value integerValue];
                    [self.pBrightnessSlider setTintColor:[UIColor UI_BRIGHTNESS_COLOR]];
					[self UpdateBrightnessState];
				}
			}];
		}
		else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
		{
            self.pHMCharacteristicTypePowerState = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried Lightbulb Hue Control");
					self.pSwitch.On = [characteristic.value boolValue];
					[self UpdateBrightnessState];
				}
			}];
		}
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)UpdateHueState
{
	[self.pCurrentValueHueLabel setText:[NSString stringWithFormat:@"%d", (int)self.pHueSlider.value]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetHueState
{
    NSNumber* temp = [NSNumber numberWithInt:(int)self.pHueSlider.value];
    [self.pHMCharacteristicTypeHue writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled Lightbulb Hue Control");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)UpdateSaturationState
{
	[self.pCurrentValueSaturationLabel setText:[NSString stringWithFormat:@"%d", (int)self.pSaturationSlider.value]];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetSaturationState
{
    NSNumber* temp = [NSNumber numberWithInt:(int)self.pSaturationSlider.value];
    [self.pHMCharacteristicTypeSaturation writeValue:temp completionHandler:^(NSError* error){
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
- (void)UpdateBrightnessState
{
	[self.pCurrentValueBrightnessLabel setText:[NSString stringWithFormat:@"%d", (int)self.pBrightnessSlider.value]];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetBrightnessState
{
    NSNumber* temp = [NSNumber numberWithInt:(int)self.pBrightnessSlider.value];
    [self.pHMCharacteristicTypeBrightness writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled LightBulb Brightness Control");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetSwitchState
{
    NSNumber* temp = [NSNumber numberWithBool:self.pSwitch.isOn];
    [self.pHMCharacteristicTypePowerState writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled LightBulb Switch Control");
        }
    }];
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
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeHue] )
    {
        NSLog(@"Notified Lightbulb Hue Control");
        self.pHueSlider.value = [characteristic.value integerValue];
        [self UpdateHueState];
    }

    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeSaturation] )
    {
        NSLog(@"Notified Lightbulb Hue Control");
        self.pSaturationSlider.value = [characteristic.value integerValue];
        [self UpdateSaturationState];
    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeBrightness] )
    {
        NSLog(@"Notified Lightbulb Hue Control");
        self.pBrightnessSlider.value = [characteristic.value integerValue];
        [self UpdateBrightnessState];
    }

    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
    {
        NSLog(@"notificatin for  Switch Control");
        self.pSwitch.On = [characteristic.value boolValue];
    }
}

@end
