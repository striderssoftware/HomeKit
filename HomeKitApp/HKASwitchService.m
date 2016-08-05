//
//  HKASwitchService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKASwitchService.h"

@interface HKASwitchService ()

@end

@implementation HKASwitchService

@synthesize pSwitch;
@synthesize pHMCharacteristicTypePowerState;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];
	
    UILabel* pNameLabel = [self CreateLabel:@"Switch" ofColor:[UIColor whiteColor] forView:pSubView];
    
    self.pSwitch = [self CreateSwitchwithSelector:@selector(SetSwitchState) forView:pSubView];
  	
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pSwitch);
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pSwitch]-0-|"
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

		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
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
					NSLog(@"Queried Switch Control");
					self.pSwitch.On = [characteristic.value boolValue];
				}
			}];
		}
	}
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
            NSLog(@"Toggled Switch Control");
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
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
    {
                 NSLog(@"notificatin for  Switch Control");
                self.pSwitch.On = [characteristic.value boolValue];
    }
 
}

@end
