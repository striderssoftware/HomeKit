//
//  HKALockService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKALockService.h"

@interface HKALockService ()

@end

@implementation HKALockService

@synthesize pSwitch;
@synthesize pCurrentLockStateLabel;

@synthesize pHMCharacteristicTypeTargetLockMechanismState;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];
	
    UILabel* pNameLabel = [self CreateLabel:@"Lock" ofColor:[UIColor whiteColor] forView:pSubView];
	
    pCurrentLockStateLabel = [self CreateLabel:@"Current Lock State" ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pSwitch = [self CreateSwitchwithSelector:@selector(SetLockState) forView:pSubView];
    
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pCurrentLockStateLabel, pSwitch);
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pCurrentLockStateLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pCurrentLockStateLabel]-5-[pSwitch]-0-|"
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
        
        if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentLockMechanismState] )
		{
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					if ( [characteristic.value integerValue] == HMCharacteristicValueLockMechanismStateSecured )
					{
						[self.pCurrentLockStateLabel setText:@"Current lock state is Locked"];
						[self.pCurrentLockStateLabel setTextColor:[UIColor redColor]];
					}
					else //HMCharacteristicValueLockMechanismStateUnsecured, HMCharacteristicValueLockMechanismStateJammed, HMCharacteristicValueLockMechanismStateUnknown
					{
						[self.pCurrentLockStateLabel setText:@"Current lock state is Un-Locked"];
						[self.pCurrentLockStateLabel setTextColor:[UIColor greenColor]];
					}
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState] )
		{
            self.pHMCharacteristicTypeTargetLockMechanismState = characteristic;
            
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
				}
			}];
		}
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetLockState
{
    NSNumber* temp = [NSNumber numberWithBool:self.pSwitch.isOn];
    [self.pHMCharacteristicTypeTargetLockMechanismState writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled Lock Control");
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
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState] )
    {
        NSLog(@"notificatin for  Switch Control");
        self.pSwitch.On = [characteristic.value boolValue];
    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentLockMechanismState] )
    {
        if ( [characteristic.value integerValue] == HMCharacteristicValueLockMechanismStateSecured )
        {
            [self.pCurrentLockStateLabel setText:@"Current lock state is Locked"];
            [self.pCurrentLockStateLabel setTextColor:[UIColor redColor]];
        }
        else
        {
            [self.pCurrentLockStateLabel setText:@"Current lock state is Un-Locked"];
            [self.pCurrentLockStateLabel setTextColor:[UIColor greenColor]];
        }
    }
}

@end
