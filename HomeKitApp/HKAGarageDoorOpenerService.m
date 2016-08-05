//
//  HKAGarageDoorOpenerService.m
//  HomeKitOne
//
//  Created by Dennis Lucero on 10/27/13.
//  Copyright (c) 2013 Dennis Lucero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKAGarageDoorOpenerService.h"

@interface HKAGarageDoorOpenerService ()

@end

@implementation HKAGarageDoorOpenerService

@synthesize pTargetDoorSwitch;
@synthesize pTargetLockSwitch;
@synthesize pObstructionDetectedLabel;
@synthesize pCurrentDoorStateLabel;
@synthesize pCurrentLockStateLabel;

@synthesize pHMCharacteristicTypeTargetDoorState;
@synthesize pHMCharacteristicTypeTargetLockMechanismState;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIView*)SetViewControls
{
	UIView* pSubView = [[UIView alloc] init];
	
    UILabel* pNameLabel = [self CreateLabel:@"     Garage Door Opener     " ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pObstructionDetectedLabel = [self CreateLabel:@"Obstruction Dected" ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pCurrentDoorStateLabel = [self CreateLabel:@"Current Door State" ofColor:[UIColor whiteColor] forView:pSubView];
	
    UILabel* pTargetDoorLabel = [self CreateLabel:@"Door Control" ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pTargetDoorSwitch = [self CreateSwitchwithSelector:@selector(SetGarageDoorOpenerState) forView:pSubView];
	
    self.pCurrentLockStateLabel = [self CreateLabel:@"GarageDoorOpener" ofColor:[UIColor whiteColor] forView:pSubView];
	
    UILabel* pLockLabel = [self CreateLabel:@"Door Lock Control" ofColor:[UIColor whiteColor] forView:pSubView];
	
    self.pTargetLockSwitch = [self CreateSwitchwithSelector:@selector(SetGarageDoorLockState) forView:pSubView];
	
	NSDictionary* pViewDictionary = NSDictionaryOfVariableBindings(pNameLabel, pObstructionDetectedLabel, pCurrentDoorStateLabel, pTargetDoorLabel, pTargetDoorSwitch, pCurrentLockStateLabel, pLockLabel, pTargetLockSwitch);
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pNameLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pObstructionDetectedLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pCurrentDoorStateLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pTargetDoorLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	
	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"V:|-0-[pNameLabel]-15-[pObstructionDetectedLabel]-15-[pCurrentDoorStateLabel]-15-[pTargetDoorLabel]-5-[pTargetDoorSwitch]-15-[pCurrentLockStateLabel]-15-[pLockLabel]-5-[pTargetLockSwitch]-0-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];

	[pSubView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat : @"H:|-0-[pCurrentLockStateLabel]-(>=8)-|"
											 options : 0
											 metrics : nil
											   views : pViewDictionary]];
	
	//TODO - NOTICE: there is no horizontal layout for either the pLockLabel or the pTargetLockSwitch. I wonder if I could remove the other horizontal layouts as well.
	
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
		NSLog(@"toggleAccessoryState: characteristic type is::%@", characteristic.characteristicType);
		
        [self EnableNotifications:characteristic];
        
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] )
		{
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
					[self.pObstructionDetectedLabel setText:@"error"];
				}
				else
				{
					NSLog(@"Queried Lightbulb Hue Control");
					if ( [characteristic.value boolValue] )
					{
						[self.pObstructionDetectedLabel setText:@"Danger Danger Danger"];
						[self.pObstructionDetectedLabel setTextColor:[UIColor redColor]];
					}
					else
					{
						[self.pObstructionDetectedLabel setText:@"Everything is groovy"];
						[self.pObstructionDetectedLabel setTextColor:[UIColor greenColor]];					}
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetDoorState] )
		{
            self.pHMCharacteristicTypeTargetDoorState = characteristic;
            
			[characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
				{
					self.pTargetDoorSwitch.on = [characteristic.value boolValue];
				}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentDoorState] )
		{
            [characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
					if ( [characteristic.value integerValue] == HMCharacteristicValueDoorStateOpen )
					{
						[self.pCurrentDoorStateLabel setText:@"Door Is Open"];
						[self.pCurrentDoorStateLabel setTextColor:[UIColor greenColor]];
					}
					else //HMCharacteristicValueDoorStateClosed, HMCharacteristicValueDoorStateOpening, HMCharacteristicValueDoorStateClosing, HMCharacteristicValueDoorStateStopped
					{
						[self.pCurrentDoorStateLabel setText:@"Door is Not Open"];
						[self.pCurrentDoorStateLabel setTextColor:[UIColor redColor]];
					}
			}];
		}
		
		if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentLockMechanismState] )
		{
            [characteristic readValueWithCompletionHandler:^(NSError *error){
				if ( error != nil )
				{
					NSLog(@"Error Encountered");
					NSLog(@"error: %@", error);
				}
				else
					if ( [characteristic.value integerValue] == HMCharacteristicValueLockMechanismStateSecured )
					{
						[self.pCurrentLockStateLabel setText:@"Door Lock is Locked"];
						[self.pCurrentLockStateLabel setTextColor:[UIColor redColor]];
					}
					else //HMCharacteristicValueLockMechanismStateUnsecured, HMCharacteristicValueLockMechanismStateJammed, HMCharacteristicValueLockMechanismStateUnknown
					{
						[self.pCurrentLockStateLabel setText:@"Door Lock is Un-Locked"];
						[self.pCurrentLockStateLabel setTextColor:[UIColor greenColor]];					}
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
					self.pTargetLockSwitch.on = [characteristic.value boolValue];
				}
			}];
		}
	}
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetGarageDoorOpenerState
{
    NSNumber* temp = [NSNumber numberWithBool:self.pTargetDoorSwitch.isOn];
    [self.pHMCharacteristicTypeTargetDoorState writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled GarageDoorOpener Control");
        }
    }];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)SetGarageDoorLockState
{
    NSNumber* temp = [NSNumber numberWithBool:self.pTargetLockSwitch.isOn];
    [self.pHMCharacteristicTypeTargetLockMechanismState writeValue:temp completionHandler:^(NSError* error){
        if ( error != nil )
        {
            NSLog(@"Error Encountered");
            NSLog(@"error: %@", error);
        }
        else
        {
            NSLog(@"Toggled GarageDoor Lock Control");
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
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeObstructionDetected] )
    {
        if ( [characteristic.value boolValue]  )
        {
            [self.pObstructionDetectedLabel setText:@"Dange Danger Danger"];
            [self.pObstructionDetectedLabel setTextColor:[UIColor redColor]];
        }
        else
        {
            [self.pObstructionDetectedLabel setText:@"Everything is Groovy"];
            [self.pObstructionDetectedLabel setTextColor:[UIColor greenColor]];
        }
    }
    
    else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentDoorState] )
    {
        if ( [characteristic.value integerValue] == HMCharacteristicValueDoorStateOpen )
        {
            [self.pCurrentDoorStateLabel setText:@"Door Is Open"];
            [self.pCurrentDoorStateLabel setTextColor:[UIColor greenColor]];
        }
        else //HMCharacteristicValueDoorStateClosed, HMCharacteristicValueDoorStateOpening, HMCharacteristicValueDoorStateClosing, HMCharacteristicValueDoorStateStopped
        {
            [self.pCurrentDoorStateLabel setText:@"Door is Not Open"];
            [self.pCurrentDoorStateLabel setTextColor:[UIColor redColor]];
        }
    }
    
    else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentDoorState] )
    {
        if ( [characteristic.value integerValue] == HMCharacteristicValueDoorStateOpen )
        {
            [self.pCurrentDoorStateLabel setText:@"Door Is Open"];
            [self.pCurrentDoorStateLabel setTextColor:[UIColor greenColor]];
        }
        else //HMCharacteristicValueDoorStateClosed, HMCharacteristicValueDoorStateOpening, HMCharacteristicValueDoorStateClosing, HMCharacteristicValueDoorStateStopped
        {
            [self.pCurrentDoorStateLabel setText:@"Door is Not Open"];
            [self.pCurrentDoorStateLabel setTextColor:[UIColor redColor]];
        }
    }
    
    
    else if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeCurrentLockMechanismState] )
    {
        if ( [characteristic.value integerValue] == HMCharacteristicValueLockMechanismStateSecured )
        {
            [self.pCurrentLockStateLabel setText:@"Door Lock is Locked"];
            [self.pCurrentLockStateLabel setTextColor:[UIColor redColor]];
        }
        else //HMCharacteristicValueLockMechanismStateUnsecured, HMCharacteristicValueLockMechanismStateJammed, HMCharacteristicValueLockMechanismStateUnknown
        {
            [self.pCurrentLockStateLabel setText:@"Door Lock is Un-Locked"];
            [self.pCurrentLockStateLabel setTextColor:[UIColor greenColor]];
        }
    }
    
    //switches
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetDoorState] )
    {
        NSLog(@"notificatin for  Switch Control");
        self.pTargetDoorSwitch.On = [characteristic.value boolValue];
    }
    
    if ( [characteristic.characteristicType isEqualToString:HMCharacteristicTypeTargetLockMechanismState] )
    {
        NSLog(@"notificatin for  Switch Control");
        self.pTargetLockSwitch.On = [characteristic.value boolValue];
    }
    
}


@end
