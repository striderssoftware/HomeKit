//
//  HKAOutletService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKAOutletService.h"

@interface HKAOutletService ()

@end

@implementation HKAOutletService

@synthesize pPowerStateCharacteristic;
@synthesize pInUseCharacteristic;
@synthesize pSwitch;
@synthesize pInUseLabel;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];

	UILabel* pNameLabel = [self CreateLabel:@"Outlet" ofColor:[UIColor whiteColor] forView:pSubView];
    
    self.pInUseLabel = [self CreateLabel:@"In Use" ofColor:[UIColor whiteColor] forView:pSubView];
    
    self.pSwitch = [self CreateSwitchwithSelector:@selector(SetOutletState) forView:pSubView];
	
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pInUseLabel, pSwitch);
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pInUseLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pInUseLabel]-0-[pSwitch]-0-|"
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
            self.pPowerStateCharacteristic = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried Outlet Control");
					self.pSwitch.On = [characteristic.value boolValue];
				}
			}];
		}

		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeOutletInUse] )
		{
            self.pInUseCharacteristic = characteristic;
                        
            //Set value
			[self.pInUseCharacteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					NSLog(@"Queried outlet InUse Control, value is:%@", characteristic.value);
					if ( [characteristic.value boolValue]  )
					{
						[self.pInUseLabel setText:@"In Use"];
						[pInUseLabel setTextColor:[UIColor greenColor]];
					}
					else
					{
						[self.pInUseLabel setText:@"Not In Use"];
						[pInUseLabel setTextColor:[UIColor redColor]];
					}
				}
			}];
            
         }
	}
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetOutletState
{
    NSNumber* temp = [NSNumber numberWithBool:self.pSwitch.isOn];
    [self.pPowerStateCharacteristic writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled Outlet Control");
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
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeOutletInUse] )
    {
        if ( [characteristic.value boolValue]  )
        {
            [self.pInUseLabel setText:@"In Use"];
            [pInUseLabel setTextColor:[UIColor greenColor]];
        }
        else
        {
            [self.pInUseLabel setText:@"Not In Use"];
            [pInUseLabel setTextColor:[UIColor redColor]];
        }
    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypePowerState] )
    {
        NSLog(@"notificatin for  Switch Control");
        self.pSwitch.On = [characteristic.value boolValue];
    }
}

@end
